//
//  MainViewModel.swift
//  LBO
//
//  Created by Noeline PAGESY on 08/02/2023.
//

import Combine
import Foundation

enum ViewState: Equatable {
    case success
    case error
    case loading
}

protocol MainViewModelProtocol: ObservableObject {
    var viewState: ViewState { get set }
    var isSearching: Bool { get set }
    var books: [EBook] { get set }
    var myLybrary: [EBook] { get set }
    var searchBookTitle: String { get set }
    var searchBookAuthor: String { get set }
    var searchText: String {  get set }
    var filteredEbook: [EBook] { get set }
    var filteredLibrary: [EBook] { get set }
    
    func search()
    func initLibrary()
    func updateFavorite(_ book: EBook)
}

final class MainViewModel: MainViewModelProtocol {
    @Published var viewState: ViewState = .success
    
    @Published var searchBookTitle: String = ""
    @Published var searchBookAuthor: String = ""
    
    @Published var isSearching = false {
        didSet {
            if !isSearching { viewState = .success }
        }
    }
    
    var books: [EBook] = []
    var myLybrary: [EBook] = []
    
    @Published var searchText = "" {
        didSet {
            if searchText.isEmpty {
                filteredEbook = books
                filteredLibrary = myLybrary
            } else {
                filteredEbook = books.filter {
                    $0.title.localizedCaseInsensitiveContains(searchText) ||
                    $0.description?.localizedCaseInsensitiveContains(searchText) ?? false ||
                    $0.authors?.localizedCaseInsensitiveContains(searchText) ?? false
                }
                
                filteredLibrary = myLybrary.filter {
                    $0.title.localizedCaseInsensitiveContains(searchText) ||
                    $0.description?.localizedCaseInsensitiveContains(searchText) ?? false ||
                    $0.authors?.localizedCaseInsensitiveContains(searchText) ?? false
                }
            }
        }
    }
    
    @Published var filteredEbook: [EBook] = []
    @Published var filteredLibrary: [EBook] = []
    
    private let serviceProvider: BookServiceProviderProtocol
    private let storage: StorageProtocol
    private var subscription = Set<AnyCancellable>()
    
    init(serviceProvider: BookServiceProviderProtocol, storage: StorageProtocol) {
        self.serviceProvider = serviceProvider
        self.storage = storage
        
        searchBookTitle = storage.getOldSearchTitleTerm() ?? ""
        searchBookAuthor = storage.getOldSearchAuthorTerm() ?? ""
    }
    
    func search() {
        viewState = .loading
        serviceProvider.getBooks(title: searchBookTitle, author: searchBookAuthor.isEmpty ? nil : searchBookAuthor)
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: onReceive(_:),
                receiveValue: { [weak self] books in
                    guard let self = self else { return }

                    self.books = books.items.map { book in
                        let favorites = self.storage.getFavorites()
                        return EBook(book, isFavorite: !(favorites.first { $0.id == book.id } == nil))
                    }
                    self.filteredEbook = self.books
                    
                    self.storage.saveSearchTitleTerm(self.searchBookTitle)
                    self.storage.saveSearchAuthorTerm(self.searchBookAuthor)
                    
                    self.viewState = .success
                }
            )
            .store(in: &subscription)
    }

    func initLibrary() {
        myLybrary = Array(storage.getFavorites())
        filteredLibrary = myLybrary
    }
    
    func updateFavorite(_ book: EBook) {
        book.isFavorite.toggle()
        if isSearching {
            books = books.map { eBook in
                if book == eBook {
                    eBook.isFavorite = book.isFavorite
                }
                return eBook
            }
        }
        myLybrary = Array(storage.updateFavorite(book))
    }
}

private extension MainViewModel {
    func onReceive(_ completion: Subscribers.Completion<NetworkError>) {
        switch completion {
        case .finished: break
        case.failure(let error):
            print("<<<<<<<<<<<<< \(error)")
            viewState = .error
        }
    }
}
