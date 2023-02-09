//
//  Book.swift
//  LBO
//
//  Created by Noeline PAGESY on 06/02/2023.
//

import Foundation

struct Books: Codable {
    let totalItems: Int
    let items: [Book]
}

struct Book: Codable {
    let id: String
    let volumeInfo: VolumeInfo
}

extension Book: Hashable, Identifiable {
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    static func == (lhs: Book, rhs: Book) -> Bool {
        lhs.id == rhs.id
    }
}

struct VolumeInfo: Codable {
    let title: String
    let authors: [String]?
    let description: String?
    let imageLinks: Images?
    let infoLink: URL
}

struct Images: Codable {
    let smallThumbnail: URL
    let thumbnail: URL
}
