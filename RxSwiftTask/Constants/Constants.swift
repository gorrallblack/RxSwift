//
//  Constants.swift
//  RxSwiftTask
//

import Foundation

enum Server {
    static let ResturantURL = "https://gateway-dev.shisheo.com/social/api/web/post/arina/test"
}

enum SearchError: Error {
    case underlyingError(Error)
    case notFound
    case unkowned
}
