//
//  Router.swift
//
//  Created by Mert Serin on 2021-05-24.
//

import Foundation
import Combine

protocol FakeRouter {
    var fakeStatusCode: Int { get }
    var fakeJSONPath: String? { get }
}

enum Router {
    static var agent: RealAPIManager {
        if ProcessInfo.processInfo.environment["IS_UNIT_TESTING"] == "YES" {
            return FakeAPIManager()
         }

        return APIManager()
    }
    static let base = URL(string: Config.baseURL)!
}

enum Endpoint {
    case getCreditScore

    var path: String {
        switch self {
        case .getCreditScore:
            return "prod/mockcredit/values"
        }
    }

    var httpMethod: String {
        switch self {
        case .getCreditScore:
            return "GET"
        }
    }

    func asURLRequest() -> URLRequest {
        var urlRequest = URLRequest(url: Router.base.appendingPathComponent(path))
        urlRequest.httpMethod = httpMethod
        return urlRequest
    }
}

extension Endpoint: FakeRouter {

    var fakeStatusCode: Int {
        switch self {
        case .getCreditScore:
            return 200
        }
    }

    var fakeJSONPath: String? {
        switch self {
        case .getCreditScore:
            return "GetCreditScoreResponse"
        }
    }
    
}

extension Router {

    static func getCreditScore() -> AnyPublisher<CreditScoreResponseModel, Error> {
        return run(Endpoint.getCreditScore)
    }

    static func run<T: Decodable>(_ request: Endpoint) -> AnyPublisher<T, Error> {
        return agent.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}

