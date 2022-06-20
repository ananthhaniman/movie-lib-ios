//
//  MovieRemoteService.swift
//  Movie Lib
//
//  Created by Ananthamoorthy Haniman on 2022-05-23.
//

import Foundation
import Alamofire

// Alamofire - I have used Alamofire for the clean code and easy network request handling. for all the API requests (POST/GET/PUT) will be easier and an understandable manner. Optimise common networks task for easy implementation and execption handling.


class MovieRemoteService {
    
    private let baseURL = "https://itunes.apple.com"
    
    // MARK: API request call method for a movie search. This method will return movies or API error as Response
    /// `completion` - implemented completion handler for API call. it will pass the evaluation as success or failure.
    /// To handle errors and result this method is the best way.
    func search(for keyword:String, completion: @escaping (Result<[Movie],APIError>) -> Void) {
        let parameters: Parameters = [
            "term": keyword,
            "country": "au",
            "media": "movie"
        ]
        let APIUrl = "\(baseURL)/search"
        let request = AF.request(APIUrl,parameters: parameters)
            .validate()
        
        request.responseDecodable(of:ResultEntity.self) { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    if result.resultCount > 0 {
                        completion(.success(result.results))
                    }else{
                        completion(.failure(APIError.ResultNotFound))
                    }
                }
            case let .failure(error):
                debugPrint(error)
                completion(
                    .failure(
                        APIError.ServerError(
                            message: error.localizedDescription
                        )
                    )
                )
            }
        }
        
    }
    
    
    
    
}
