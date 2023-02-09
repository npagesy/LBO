//
//  ServiceProvider.swift
//  LBO
//
//  Created by Noeline PAGESY on 08/02/2023.
//
import Combine
import Foundation

protocol ServiceProviderProtocol {
    func execute<T: Codable>(route: NetworkRouterProtocol) -> AnyPublisher<T, NetworkError>
}

extension ServiceProviderProtocol {
    func execute<T: Codable>(route: NetworkRouterProtocol) -> AnyPublisher<T, NetworkError> {
        guard let request = try? route.asURLRequest() else { return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher() }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw NetworkError.failed
                }
                
                if httpResponse.statusCode == 404 {
                    throw NetworkError.notFound
                }
                
                do {
                    return try JSONDecoder().decode(T.self, from: data)
                } catch {
                    throw NetworkError.decodeError
                }
            }
            .mapError { error -> NetworkError in
                switch error {
                case let error as NetworkError:
                    print(error.localizedDescription)
                    return error
                case is Swift.DecodingError:
                    print(error.localizedDescription)
                    return NetworkError.decodeError
                default:
                    print(error.localizedDescription)
                    return NetworkError.networkError
                }
            }
            .eraseToAnyPublisher()
    }
}


protocol BookServiceProviderProtocol: ServiceProviderProtocol {
    func getBooks(title: String, author: String?) -> AnyPublisher<Books, NetworkError>
}

class BookServiceProvider: BookServiceProviderProtocol {
    func getBooks(title: String, author: String?) -> AnyPublisher<Books, NetworkError> {
        execute(route: BookRouter.getBook(title: title, author: author))
    }
}
