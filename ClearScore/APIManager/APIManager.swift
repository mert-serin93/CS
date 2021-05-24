//
//  APIManager.swift
//
//  Created by Mert Serin on 2021-05-24.
//

import Combine
import Foundation

struct Response<T> {
    let value: T
    let response: URLResponse
}

protocol RealAPIManager {
    var session: URLSession { get }

    func run<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<Response<T>, Error>
}


struct APIManager: RealAPIManager {
    var session: URLSession = URLSession.shared

    func run<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<Response<T>, Error> {
        let decoder = JSONDecoder()
        
        return URLSession.shared
            .dataTaskPublisher(for: endpoint.asURLRequest())
            .tryMap { result -> Response<T> in
                let value = try decoder.decode(T.self, from: result.data)
                return Response(value: value, response: result.response)
            }
            .mapError({ error in
                return error
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

struct FakeAPIManager: RealAPIManager {
    var session: URLSession = URLSession.shared

    func run<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<Response<T>, Error> {
        guard let bundlePath = Bundle.main.path(forResource: endpoint.fakeJSONPath, ofType: "json"),
              let data = try? String(contentsOfFile: bundlePath).data(using: .utf8) else {
            return Empty().eraseToAnyPublisher()
        }

        let decoder = JSONDecoder()

        let response = HTTPURLResponse(url: URL(string: bundlePath)!, statusCode: endpoint.fakeStatusCode, httpVersion: nil, headerFields: nil)!
        let value = try! decoder.decode(T.self, from: data)
        
        return Just(Response(value: value, response: response))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
