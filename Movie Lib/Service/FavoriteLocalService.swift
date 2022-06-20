//
//  FavoriteLocalService.swift
//  Movie Lib
//
//  Created by Ananthamoorthy Haniman on 2022-05-25.
//

import Foundation
import RealmSwift

// Realm - From my personal experience code balance can be managed with a minimal code base. When compares to the Core data, local storage handling this method is preferable because it is flexible.

class FavoriteLocalService{
    
    
    // MARK: - Retrieve all the favorite movies datas saved in the local database
    func getAllFavorites(completion: @escaping (Result<[MovieEntity], APIError>) -> Void) {
        do {
            let favorites = try Realm().objects(MovieEntity.self)
            completion(.success(Array(favorites)))
        } catch let error as NSError {
            completion(.failure(APIError.realmError(message: error.localizedDescription)))
        }
        
    }
    
    // MARK: - Adding favourite movie data to the Realm database
    func addFavorite(movie:MovieEntity, completion: @escaping (Result<Bool, APIError>) -> Void){
        do {
            let realm = try Realm()
            let object = try Realm().object(ofType: MovieEntity.self, forPrimaryKey: movie.trackId)
            try realm.write() {
                if object != nil {
                    realm.delete(object!)
                }else{
                    realm.add(movie,update: .all)
                }
                completion(.success(true))
            }
        } catch let error as NSError {
            completion(.failure(APIError.realmError(message: error.localizedDescription)))
        }
    }
    
    // MARK: -  Validate the movie data already added to the database
    func isExist(trackerID:Int) -> Bool{
        do {
            return try Realm().object(ofType: MovieEntity.self, forPrimaryKey: trackerID) != nil
        } catch let error as NSError {
            debugPrint(error)
           return false
        }
    }
    
    // MARK: - Validate the present of movie data and able to delete
    func delete(trackerID:Int,completion: @escaping (Result<Bool, APIError>) -> Void) {
        do {
            let realm = try Realm()
            let object = try Realm().object(ofType: MovieEntity.self, forPrimaryKey: trackerID)
            if object != nil {
                try realm.write{
                    realm.delete(object!)
                    completion(.success(true))
                }
            }else{
                completion(.success(false))
            }
            
        } catch let error as NSError {
            completion(.failure(APIError.realmError(message: error.localizedDescription)))
        }
    }
    
    
}
