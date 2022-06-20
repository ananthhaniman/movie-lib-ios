//
//  APIError.swift
//  Movie Lib
//
//  Created by Ananthamoorthy Haniman on 2022-05-24.
//

import Foundation

enum APIError: Error {
    
    case ServerError(message:String)
    case ResultNotFound
    case NetworkError(message:String)
    case realmError(message:String)
    case EmptyList
    
}
