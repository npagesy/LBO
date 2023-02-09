//
//  SearchList.swift
//  LBO
//
//  Created by Noeline PAGESY on 09/02/2023.
//

import SwiftUI

struct SearchList<Model>: View where Model: MainViewModelProtocol {
    @Environment(\.openURL) var openURL
    
    @EnvironmentObject var viewModel: Model
    @State private var searchText = ""
    
    var body: some View {
        if viewModel.viewState == .error {
            VStack {
                Spacer()
                
                Image(systemName: "xmark.icloud.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                
                Text("Oups... !! Un problème est survenu")
                    .font(.title2)
                
                Spacer()
            }
            .padding()
        } else {
            List(viewModel.isSearching ? $viewModel.filteredEbook : $viewModel.filteredLibrary, id: \.id) { book in
                EBookCardView(imageURL: book.wrappedValue.thumbnail,
                              title: book.wrappedValue.title,
                              authors: book.wrappedValue.authors ?? "",
                              description: book.wrappedValue.description ?? "",
                              isFavorite: book.isFavorite) {
                    viewModel.updateFavorite(book.wrappedValue)
                }
            }
            .listStyle(.plain)
            .searchable(text: $viewModel.searchText)
            .overlay {
                if viewModel.viewState == .loading && viewModel.isSearching {
                    ProgressView("Fetching data, please wait...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                }
            }
            .onAppear {
                viewModel.isSearching ? viewModel.search() : viewModel.initLibrary()
            }
        }
    }
}
