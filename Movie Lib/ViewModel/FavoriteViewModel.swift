//
//  FavoriteViewModel.swift
//  Movie Lib
//
//  Created by Ananthamoorthy Haniman on 2022-05-25.
//

import Foundation
import RxSwift
import RxCocoa

struct FavoriteViewModel{
    
    private let service:FavoriteLocalService?
    
    let error:PublishSubject<APIError> = PublishSubject()
    let isLoading:PublishSubject<Bool> = PublishSubject()
    let movies:BehaviorSubject<[MovieEntity]> = BehaviorSubject(value: [])
    var isCurrentMovieFavorite:PublishSubject<Bool> = PublishSubject()
    
    
    // MARK: - Dependencies initialization
    init(favoriteService: FavoriteLocalService){
        self.service = favoriteService
    }
    
    // MARK: -  Retrive all saved favorite movies
    func getFavorites(){
        isLoading.onNext(true)
        service?.getAllFavorites(completion: { (result) in
            switch result {
            case let .success(movieList):
                if movieList.isEmpty{
                    error.onNext(APIError.EmptyList)
                }else{
                    movies.onNext(movieList.reversed())
                }
                
            case let .failure(dbError):
                error.onNext(dbError)
            }
        })
    }
    
    // MARK: - Save Movie to Local DB
    func addFavorite(movie:Movie) {
        let movieEntity = MovieEntity()
        movieEntity.trackName = movie.trackName
        movieEntity.trackId = movie.trackId
        movieEntity.artworkUrl100 = movie.artworkUrl100
        movieEntity.currency = movie.currency
        movieEntity.primaryGenreName = movie.primaryGenreName
        movieEntity.longDescription = movie.longDescription ?? ""
        movieEntity.trackPrice = movie.trackPrice ?? 0
        movieEntity.trackViewUrl = movie.trackViewUrl
        movieEntity.isFavorite = movie.isFavorite ?? false
        self.isCurrentMovieFavorite.onNext(true)
        
        service?.addFavorite(movie:movieEntity,completion: { (result) in
            switch result {
            case let .success(status):
                print(status)
            case let .failure(dbError):
                error.onNext(dbError)
            }
        })
    }
    
    // MARK: - Check if this movie is exists on Local DB
    func isFav(trackerId:Int) -> Bool{
        return service!.isExist(trackerID: trackerId)
    }
    
    // MARK: - Delete a movie record from local DB
    func deleteFavorite(trackerId:Int, at indexPath: IndexPath) {
        service?.delete(trackerID: trackerId, completion: { (result) in
            switch result {
            case let .failure(dbError):
                error.onNext(dbError)
            case .success(_):
                getFavorites()
            }
        })
    }
    
}
