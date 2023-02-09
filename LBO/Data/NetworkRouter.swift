//
//  NetworkRouter.swift
//  LBO
//
//  Created by Noeline PAGESY on 08/02/2023.
//
import Foundation

enum NetworkError: String, Error {
    case decodeError = "Erreur au decodage des données"
    case failed = "Une erreur est survenue"
    case invalidURL = "Erreur: URL invalide"
    case networkError = "Erreur réseau"
    case notFound = "Erreur 404"
}

protocol NetworkRouterProtocol {
    var urlString: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
}

extension NetworkRouterProtocol {
    // Default method for build request, usely with queryItems & method variables
    func asURLRequest() throws -> URLRequest {
        guard var urlComponents = URLComponents(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        if !path.isEmpty { urlComponents.path += path }
        urlComponents.queryItems = queryItems
        if let url = urlComponents.url {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET" // Set GET by default for this app, usely i use a variable method
            
            return urlRequest
        } else {
            throw NetworkError.invalidURL
        }
    }
}

//https://www.gooqleapis.com/books/v1/volumes?q=titreDuLivre+inauthor:auteurDuLivre
enum BookRouter: NetworkRouterProtocol {
    case getBook(title: String, author: String?)
    
    var urlString: String { "https://www.googleapis.com/" }
    
    var path: String { "books/v1/volumes" }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getBook(let title, let author):
            var queryItemValue: String = title
            
            if let author = author { queryItemValue.append("+inauthor:\(author)")}
            
            return [ URLQueryItem(name: "q", value: queryItemValue) ]
        }
    }
}


