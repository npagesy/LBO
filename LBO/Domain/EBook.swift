//
//  EBook.swift
//  LBO
//
//  Created by Noeline PAGESY on 09/02/2023.
//

import Combine
import Foundation

class EBook: Codable, ObservableObject {
    let id: String
    let title: String
    let authors: String?
    let description: String?
    let thumbnail: URL?
    let infoLink: URL
    
    @Published var isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case authors
        case description
        case thumbnail
        case infoLink
        case isFavorite
    }
    
    init(_ book: Book, isFavorite: Bool) {
        self.id = book.id
        self.title = book.volumeInfo.title
        self.authors = book.volumeInfo.authors?.formatted()
        self.description = book.volumeInfo.description
        self.thumbnail = book.volumeInfo.imageLinks?.thumbnail
        self.infoLink = book.volumeInfo.infoLink
        self.isFavorite = isFavorite
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        authors = try container.decodeIfPresent(String.self, forKey: .authors)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        thumbnail = try container.decodeIfPresent(URL.self, forKey: .thumbnail)
        infoLink = try container.decode(URL.self, forKey: .infoLink)
        isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encodeIfPresent(authors, forKey: .authors)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(thumbnail, forKey: .thumbnail)
        try container.encode(infoLink, forKey: .infoLink)
        try container.encode(isFavorite, forKey: .isFavorite)
    }
}

extension EBook: Hashable, Identifiable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: EBook, rhs: EBook) -> Bool {
        lhs.id == rhs.id
    }
}
