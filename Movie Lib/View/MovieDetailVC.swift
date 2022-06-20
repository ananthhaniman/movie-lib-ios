//
//  MovieDetailVC.swift
//  Movie Lib
//
//  Created by Ananthamoorthy Haniman on 2022-05-24.
//

import UIKit
import Alamofire
import RxSwift
import RxCocoa

class MovieDetailVC: UIViewController {
    
    var delegate:MovieDelegate?
    
    private let mainStack:UIStackView = {
        let ms = UIStackView()
        ms.axis = .vertical
        ms.alignment = .fill
        ms.spacing = 15
        ms.translatesAutoresizingMaskIntoConstraints = false
        return ms
    }()
    
    private let infoStack:UIStackView = {
        let infoStack = UIStackView()
        infoStack.axis = .horizontal
        infoStack.alignment = .top
        infoStack.spacing = 15
        return infoStack
    }()
    
    private let infoContentStack:UIStackView = {
        let ics = UIStackView()
        ics.axis = .vertical
        ics.alignment = .top
        ics.spacing = 4
        return ics
    }()
    
    private let trackTitle:UILabel = {
        let tl = UILabel()
        tl.numberOfLines = 10
        tl.font = .systemFont(ofSize: 28, weight: .semibold)
        tl.textColor = Constant.primaryTextColor
        return tl
    }()
    
    private let trackGenre:UILabel = {
        let tg = UILabel()
        tg.font = .preferredFont(forTextStyle: .subheadline)
        tg.textColor = Constant.secounderyTextColor
        return tg
    }()
    
    private let trackLongDescription:UILabel = {
        let tld = UILabel()
        tld.font = .preferredFont(forTextStyle: .footnote)
        tld.textAlignment = .justified
        tld.textColor = Constant.secounderyTextColor
        tld.numberOfLines = 50
        return tld
    }()
    
    private let trackPrice:UILabel = {
        let tp = UILabel()
        tp.font = .systemFont(ofSize: 16, weight: .semibold)
        tp.textColor = Constant.primaryColor
        return tp
    }()
    
    
    private let movieImageView:UIImageView = {
        let miv = UIImageView(image: UIImage(named: "MoviePlaceHolder"))
        miv.frame = CGRect(x: 0, y: 0, width: 60, height: 230)
        miv.contentMode = .scaleToFill
        miv.layer.cornerRadius = 10
        miv.clipsToBounds = true
        miv.translatesAutoresizingMaskIntoConstraints = false
        return miv
    }()
    
    private let scrollView:UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private var currentMovie:Movie?
    
    private let disposeBag = DisposeBag()
    
    private let fevMenuButton:UIBarButtonItem = {
        let fmb = UIBarButtonItem(image: UIImage(named: "FavoriteIcon"),
                                  style: .plain,
                                  target: nil,
                                  action: nil)
        return fmb
    }()
    
    private let viewModel:FavoriteViewModel = FavoriteViewModel(favoriteService: FavoriteLocalService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constant.backgroundColor
        setupUI()
        setupConstrains()
    }
    
    func config(movie:Movie){
        trackPrice.text = "\(String(movie.trackPrice ?? 0)) \(movie.currency)"
        trackGenre.text = movie.primaryGenreName
        trackTitle.text = movie.trackName
        trackLongDescription.text = movie.longDescription ?? ""
        loadImage(url: movie.artworkUrl100)
        self.currentMovie = movie
        checkFevStatus()
        
    }
    
    private func checkFevStatus(){
        if self.viewModel.isFav(trackerId: self.currentMovie!.trackId){
            fevMenuButton.image = UIImage(named: "FavoriteFillIcon")
        }else{
            fevMenuButton.image = UIImage(named: "FavoriteIcon")
        }
    }
    
    
    private func setupUI(){
        scrollView.contentSize = CGSize(width: view.bounds.width, height: view.bounds.height)
        self.view.addSubview(scrollView)
        
        scrollView.addSubview(mainStack)
        
        infoStack.addArrangedSubview(movieImageView)
        infoStack.addArrangedSubview(infoContentStack)
        
        infoContentStack.addArrangedSubview(trackTitle)
        infoContentStack.addArrangedSubview(trackGenre)
        infoContentStack.addArrangedSubview(trackPrice)
        
        mainStack.addArrangedSubview(infoStack)
        mainStack.addArrangedSubview(trackLongDescription)
        
        self.navigationItem.rightBarButtonItem = fevMenuButton
        
        fevMenuButton
            .rx
            .tap
            .subscribe(onNext:{
                self.viewModel.addFavorite(movie: self.currentMovie!)
                self.checkFevStatus()
                self.delegate?.update()
            }).disposed(by: disposeBag)
        
        
    }
    
    private func setupConstrains(){
        let mainStackConstrains = [
            mainStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor,constant: -40),
            mainStack.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ]
        
        let scrollViewConstrains = [
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: 0),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        let movieImageConstrains = [
            movieImageView.widthAnchor.constraint(equalToConstant: view.frame.width/2.8)
        ]
        
        NSLayoutConstraint.activate(movieImageConstrains)
        NSLayoutConstraint.activate(mainStackConstrains)
        NSLayoutConstraint.activate(scrollViewConstrains)
    }
    
    private func loadImage(url:String){
        AF.request(url,method: .get).response{ response in
            
            switch response.result {
            case .success(let responseData):
                self.movieImageView.image = UIImage(data: responseData!)?.resized(to: CGSize(width: 150, height: 200))
            case .failure(_):
                self.movieImageView.image = UIImage(named: "MoviePlaceHolder")
            }
        }
    }
}
