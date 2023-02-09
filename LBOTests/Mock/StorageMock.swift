//
//  StorageMock.swift
//  LBOTests
//
//  Created by Noeline PAGESY on 09/02/2023.
//

import Foundation

@testable import LBO

class StorageMock: StorageProtocol {
    typealias SubSequence = Set<EBook>
    
    var saveSearchTitleTermCalled = false
    var saveSearchAuthorTermCalled = false
    var getOldSearchTitleTermCalled = false
    var getOldSearchAuthorTermCalled = false
    var getFavoritesCalled = false
    var updateFavoritesCalled = false
    
    var title: String? = nil
    var author: String? = nil
    
    func saveSearchTitleTerm(_ title: String) {
        saveSearchTitleTermCalled = true
        self.title = title
    }
    
    func saveSearchAuthorTerm(_ author: String) {
        saveSearchAuthorTermCalled = true
        self.author = author
    }
    
    func getOldSearchTitleTerm() -> String? {
        getOldSearchTitleTermCalled = true
        return title
    }
    
    func getOldSearchAuthorTerm() -> String? {
        getOldSearchAuthorTermCalled = true
        return author
    }
    
    func getFavorites() -> Set<LBO.EBook> {
        getFavoritesCalled = true
        return Set<EBook>()
    }
    
    func updateFavorite(_ book: LBO.EBook) -> Set<LBO.EBook> {
        updateFavoritesCalled = true
        return Set<EBook>()
    }
}
