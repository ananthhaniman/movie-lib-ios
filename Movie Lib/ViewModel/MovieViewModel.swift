//
//  MovieViewModel.swift
//  Movie Lib
//
//  Created by Ananthamoorthy Haniman on 2022-05-22.
//

import Foundation
import RxSwift
import RxCocoa

struct MovieViewModel{
    
    private let service:MovieRemoteService?
    
    /// I have declare observable variables, the type of observer is `PublishSubject`.
    /// The aim to use this is to  Starts with empty value and only emit new elements to subscribers
    let error:PublishSubject<APIError> = PublishSubject()
    let isLoading:PublishSubject<Bool> = PublishSubject()
    let movies:PublishSubject<[Movie]> = PublishSubject()
    
    init(movieService:MovieRemoteService){
        self.service = movieService
    }
    
    // MARK: - Get movies from specfic keyword.
    func search(for keyword:String){
        //  when the search function got triggered first it will emit a 'isloading' function with the value of true, later through the API Service request it retrieves the result, and if it the response is success it will emit movie datas else it got failure to emit error event with errors
        isLoading.onNext(true)
        service?.search(for: keyword, completion: { (result) in
            isLoading.onNext(false)
            switch result{
                case let .success(movieList):
                    self.movies.onNext(movieList)
                case let .failure(error):
                    self.error.onNext(error)
                    print(error)
            }
        })
    }
    
    
}
