//
//  BookServiceProviderMock.swift
//  LBOTests
//
//  Created by Noeline PAGESY on 09/02/2023.
//

import Combine
import Foundation

@testable import LBO

class BookServiceProviderMock: BookServiceProviderProtocol {
    var getBooksCalled = false
    
    var error: NetworkError = .failed
    var isError = false
    
    func getBooks(title: String, author: String?) -> AnyPublisher<LBO.Books, LBO.NetworkError> {
        getBooksCalled = true
        
        if isError {
            return Fail(error: error).eraseToAnyPublisher() }
        else {
            let books = Books(totalItems: 126, items: [Book(id: "mfgmfg",
                                                            volumeInfo: VolumeInfo(title: "title",
                                                                                   authors: ["author"],
                                                                                   description: "description",
                                                                                   imageLinks: Images(smallThumbnail: URL(string: "http://books.google.com/books/content?id=OgoGAwAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api")!, thumbnail: URL(string: "http://books.google.com/books/content?id=OgoGAwAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api")!),
                                                                                   infoLink: URL(string: "http://books.google.com/books?id=OgoGAwAAQBAJ&dq=Title+inauthor:Auteur&hl=&source=gbs_api")!))])
            return Just(books as LBO.Books)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        }
    }
}
