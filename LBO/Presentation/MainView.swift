//
//  MainView.swift
//  LBO
//
//  Created by Noeline PAGESY on 06/02/2023.
//

import SwiftUI

struct MainView<Model>: View where Model: MainViewModelProtocol {
    @ObservedObject var viewModel: Model
    
    @State var detailIsActive = false
    
    var body: some View {
        NavigationStack {
            
            VStack(spacing: 20.0) {
                Spacer()
               
                VStack(alignment: .leading) {
                    Text("Titre du livre")
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                    
                    TextField("titre ...", text: $viewModel.searchBookTitle)
                        .textFieldStyle(.plain)
                        .buttonBorderShape(ButtonBorderShape.roundedRectangle)
                }
                .padding()
                
                VStack(alignment: .leading) {
                    Text("Auteur du livre")
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                    
                    TextField("auteur ...", text: $viewModel.searchBookAuthor)
                        .textFieldStyle(.plain)
                        .buttonBorderShape(ButtonBorderShape.roundedRectangle)
                        
                }
                .padding()
                
                Spacer()
                
                Group {
                    NavigationLink(isActive: $detailIsActive) {
                        SearchList<Model>()
                            .environmentObject(viewModel)
                            .navigationTitle(viewModel.isSearching ? "Résultat de la recherche" : "Ma bibliothèque")
                    } label: { EmptyView() }

                    Button {
                        viewModel.isSearching = true
                        detailIsActive.toggle()
                    } label: {
                        Text("Rechercher".uppercased())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
   
                    Button {
                        viewModel.isSearching = false
                        detailIsActive.toggle()
                    } label: {
                        Text("Ma bibliothèque".uppercased())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .background(Color.black)
                    .cornerRadius(10)
                }
                Spacer()
            }
            .padding(.horizontal, 16.0)
            .navigationTitle("Ebook")
        }
    }
}
