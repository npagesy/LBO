//
//  NetworkRouterTests.swift
//  LBOTests
//
//  Created by Noeline PAGESY on 08/02/2023.
//

import XCTest

@testable import LBO

final class NetworkRouterTests: XCTestCase {
    func test_buildUrlRequest() throws {
        // Given
        let router = BookRouter.getBook(title: "title", author: "author")

        // When
        let request = try router.asURLRequest().url?.absoluteString

        // Then
        XCTAssertEqual(router.path, "books/v1/volumes")
        XCTAssertEqual(request, "https://www.googleapis.com/books/v1/volumes?q=title+inauthor:author")
    }
}
