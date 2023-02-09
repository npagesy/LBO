//
//  Storage.swift
//  LBO
//
//  Created by Noeline PAGESY on 09/02/2023.
//

import Foundation

protocol StorageProtocol {
    func saveSearchTitleTerm(_ title: String)
    func saveSearchAuthorTerm(_ author: String)
    func getOldSearchTitleTerm() -> String?
    func getOldSearchAuthorTerm() -> String?
    func getFavorites() -> Set<EBook>
    func updateFavorite(_ book: EBook) -> Set<EBook>
}

class UserDefaultDataStore: StorageProtocol {
    struct Keys {
        static let historyTitleKey = "historyTitleKey"
        static let historyAuthorKey = "historyAuthorKey"
        static let favoritesKey = "favoritesKey"
    }
    
    private var favorites: Set<EBook> = []
    
    init() {}
    
    func saveSearchTitleTerm(_ title: String) {
        if let _ = UserDefaults.standard.string(forKey: Keys.historyTitleKey) {
            UserDefaults.standard.removeObject(forKey: Keys.historyTitleKey)
        }
        UserDefaults.standard.set(title, forKey: Keys.historyTitleKey)
    }
    
    func getOldSearchTitleTerm() -> String? {
        guard let oldTitleTerm = UserDefaults.standard.string(forKey: Keys.historyTitleKey) else { return nil }
        return oldTitleTerm
    }
    
    func saveSearchAuthorTerm(_ author: String) {
        if let _ = UserDefaults.standard.string(forKey: Keys.historyAuthorKey) {
            UserDefaults.standard.removeObject(forKey: Keys.historyAuthorKey)
        }
        UserDefaults.standard.set(author, forKey: Keys.historyAuthorKey)
    }
    
    func getOldSearchAuthorTerm() -> String? {
        guard let oldAuthorTerm = UserDefaults.standard.string(forKey: Keys.historyAuthorKey) else { return nil }
        return oldAuthorTerm
    }

    func getFavorites() -> Set<EBook> {
        if let data = UserDefaults.standard.object(forKey: Keys.favoritesKey) as? Data,
           let decodable = try? JSONDecoder().decode(Set<EBook>.self, from: data) {
            favorites = decodable
        }
        return favorites
    }
    
    func updateFavorite(_ book: EBook) -> Set<EBook> {
        if favorites.contains(book) {
            favorites.remove(book)
        } else {
            favorites.insert(book)
        }
        
        if let encoded = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: Keys.favoritesKey)
        }
        
        return favorites
    }
}
