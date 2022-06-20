//
//  MovieEntity.swift
//  Movie Lib
//
//  Created by Ananthamoorthy Haniman on 2022-05-25.
//

import Foundation
import RealmSwift

class MovieEntity: Object{
    @Persisted(primaryKey: true) dynamic var trackId:Int = 0
    @Persisted() dynamic var trackName:String = ""
    @Persisted() dynamic var primaryGenreName:String = ""
    @Persisted() dynamic var currency:String = ""
    @Persisted() dynamic var longDescription:String = ""
    @Persisted() dynamic var trackPrice:Double = 0
    @Persisted() dynamic var trackViewUrl:String = ""
    @Persisted() dynamic var artworkUrl100:String = ""
    @Persisted() dynamic var isFavorite:Bool = false
    
    
}
