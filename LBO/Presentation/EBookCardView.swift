//
//  EBookCardView.swift
//  LBO
//
//  Created by Noeline PAGESY on 09/02/2023.
//

import Kingfisher
import SwiftUI

struct EBookCardView: View {
    var imageURL: URL?
    
    var title: String
    var authors: String
    var description: String
    @Binding var isFavorite: Bool
    
    public let action: () -> Void
    
    var body: some View {
        VStack(spacing: 5) {
            if let imageURL = imageURL {
                KFImage(imageURL)
                    .placeholder { ProgressView() }
                    .cacheOriginalImage(true)
                    .cacheMemoryOnly(false)
                    .cancelOnDisappear(true)
                    .resizable()
                    .frame(width: .none, height: 150)
                    .scaledToFill()
            }
            
            VStack(alignment: .leading, spacing: 5.0) {
                Text(title)
                    .font(.title2)
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(authors)
                    .font(.title3)
                    .bold()
                
                Text(description)
                    .lineLimit(3)
            }
            .padding()
        }
        .overlay(alignment: .topTrailing) {
            VStack(alignment: .center) {
                Button {
                    action()
                } label: {
                    Image(systemName: isFavorite ? "bookmark.fill" : "bookmark")
                        .foregroundColor(Color.white)
                        .frame(width: 30.0, height: 30.0)
                        .padding(6.0)
                        .background(Color.blue.opacity(0.4))
                        .clipShape(Circle())
                }
            }
            .frame(width: 40.0, height: 40.0)
            .padding(10.0)
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(20)
    }
}
