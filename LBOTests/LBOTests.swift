//
//  LBOTests.swift
//  LBOTests
//
//  Created by Noeline PAGESY on 06/02/2023.
//

import Combine
import XCTest

@testable import LBO

final class LBOTests: XCTestCase {
    private var storage = Set<AnyCancellable>()
    
    func test_init() {
        // Given
        let serviceProvider = BookServiceProviderMock()
        let storage = StorageMock()
        
        // When
        let viewModel = MainViewModel(serviceProvider: serviceProvider, storage: storage)
        
        // Then
        XCTAssertTrue(storage.getOldSearchTitleTermCalled)
        XCTAssertTrue(storage.getOldSearchAuthorTermCalled)
        XCTAssertTrue(viewModel.searchBookTitle.isEmpty)
        XCTAssertTrue(viewModel.searchBookAuthor.isEmpty)
    }
    
    func test_init_withHistoric() {
        // Given
        let serviceProvider = BookServiceProviderMock()
        let storage = StorageMock()
        let title = "title"
        let author = "author"
        storage.saveSearchTitleTerm(title)
        storage.saveSearchAuthorTerm(author)
        
        // When
        let viewModel = MainViewModel(serviceProvider: serviceProvider, storage: storage)
        
        // Then
        XCTAssertTrue(storage.getOldSearchTitleTermCalled)
        XCTAssertTrue(storage.getOldSearchAuthorTermCalled)
        XCTAssertEqual(viewModel.searchBookTitle, title)
        XCTAssertEqual(viewModel.searchBookAuthor, author)
    }
    
//    func test_search() {
//        // Given
//        let serviceProvider = BookServiceProviderMock()
//        var storage = StorageMock()
//        let title = "title"
//        storage.saveSearchTitleTerm(title)
//        let viewModel = MainViewModel(serviceProvider: serviceProvider, storage: storage)
//
//        let expectation = XCTestExpectation()
//
//        // When
//        viewModel.search()
//
//        // Then
//        viewModel.$filteredEbook
//            .dropFirst()
//            .sink { _ in
//                expectation.fulfill()
//            }
//            .store(in: &storage)
//
//        wait(for: [expectation], timeout: 1)
//
//        XCTAssertTrue(serviceProvider.getBooksCalled)
//        XCTAssertFalse(viewModel.books.isEmpty)
//        XCTAssertEqual(viewModel.filteredEbook, viewModel.books)
//        XCTAssertTrue(storage.saveSearchTitleTermCalled)
//        XCTAssertTrue(storage.saveSearchAuthorTermCalled)
//        XCTAssertEqual(viewModel.viewState, .success)
//    }
    
    func test_initLibrary() {
        // Given
        let serviceProvider = BookServiceProviderMock()
        let storage = StorageMock()
        let viewModel = MainViewModel(serviceProvider: serviceProvider, storage: storage)
        
        // When
        viewModel.initLibrary()
        
        // Then
        XCTAssertTrue(storage.getFavoritesCalled)
    }
    
    func test_updateFavorite() {
        // Given
        
        // When
        
        // Then
    }
}
