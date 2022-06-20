//
//  ResultEntity.swift
//  Movie Lib
//
//  Created by Ananthamoorthy Haniman on 2022-05-24.
//

import Foundation

struct ResultEntity:Codable {
    let resultCount:Int
    let results:[Movie]
}
