//
//  Movie.swift
//  Movie Lib
//
//  Created by Ananthamoorthy Haniman on 2022-05-23.
//

import Foundation

struct Movie:Codable {
    let trackId:Int
    let trackName:String
    let primaryGenreName:String
    let currency:String
    let longDescription:String?
    let trackPrice:Double?
    let trackViewUrl:String
    let artworkUrl100:String
    var isFavorite:Bool? = false
}
