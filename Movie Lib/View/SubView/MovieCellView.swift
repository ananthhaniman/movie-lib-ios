//
//  MovieCellView.swift
//  Movie Lib
//
//  Created by Ananthamoorthy Haniman on 2022-05-23.
//

import Foundation
import Alamofire
import UIKit
import RxSwift
import RxCocoa

class MovieCellView: UICollectionViewCell{
    
    static let indentifier = "movieCell"
    
    private let trackNameLabel:UILabel = {
        let tnl = UILabel()
        tnl.font = .preferredFont(forTextStyle: .headline)
        tnl.textColor = Constant.primaryTextColor
        return tnl
    }()
    
    private let genreLabel:UILabel = {
        let tnl = UILabel()
        tnl.font = .preferredFont(forTextStyle: .subheadline)
        tnl.textColor = Constant.secounderyTextColor
        return tnl
    }()
    
    private let priceLabel:UILabel = {
        let tnl = UILabel()
        tnl.font = .systemFont(ofSize: 14, weight: .semibold)
        tnl.textColor = Constant.primaryColor
        return tnl
    }()
    
    private let contentStack:UIStackView = {
        let cs = UIStackView()
        cs.axis = .vertical
        cs.spacing = 0
        cs.distribution = .fillProportionally
        cs.alignment = .leading
        return cs
    }()
    
    private let mainStack:UIStackView = {
        let ms = UIStackView()
        ms.axis = .vertical
        ms.spacing = 10
        ms.distribution = .fillProportionally
        ms.alignment = .top
        ms.translatesAutoresizingMaskIntoConstraints = false
        return ms
    }()
    
    private let movieImageView:UIImageView = {
        let miv = UIImageView(image: UIImage(named: "MoviePlaceHolder"))
        miv.contentMode = .scaleToFill
        miv.layer.cornerRadius = 10
        miv.clipsToBounds = true
        return miv
    }()
    
    let fevButton:UIButton = {
        let fb = UIButton()
        fb.setImage(UIImage(named: "FavoriteIcon")?.withRenderingMode(.alwaysTemplate) , for: .normal)
        fb.setImage(UIImage(named: "FavoriteFillIcon")?.withRenderingMode(.alwaysTemplate), for: .selected)
        fb.layer.cornerRadius = 20.0
        fb.imageView?.contentMode = .scaleAspectFit
        /// `fb.imageView?.layer.transform` source from - https://stackoverflow.com/questions/10576593/how-to-adjust-an-uibuttons-imagesize
        fb.imageView?.layer.transform = CATransform3DMakeScale(0.7, 0.7, 0.7) // to adjust image size of Menu item button
        fb.clipsToBounds = true
        fb.tintColor = Constant.primaryColor
        fb.backgroundColor = Constant.backgroundColor
        fb.translatesAutoresizingMaskIntoConstraints = false
        return fb
    }()
    
    var viewModel:FavoriteViewModel = FavoriteViewModel(
        favoriteService: FavoriteLocalService()
    )
    var movie:Movie?
    
    // avoid memory leaks
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        applyConstrains()
        
    }
    
    
    func config(data:Movie){
        self.trackNameLabel.text = data.trackName
        self.genreLabel.text = data.primaryGenreName
        self.priceLabel.text = "\(String(data.trackPrice ?? 0)) \(data.currency)"
        self.movieImageView.image = UIImage(named: "MoviePlaceHolder")
        self.loadImage(url: data.artworkUrl100)
        self.movie = data
        setupBindings()
        checkFevStatus()
    }
    
    private func checkFevStatus(){
        fevButton.isSelected = false
        if self.viewModel.isFav(trackerId: movie!.trackId){ // check movie favorite status using TrackID
            fevButton.isSelected = true
        }else{
            fevButton.isSelected = false
        }
    }
    
    private func setupUI(){
        mainStack.addArrangedSubview(movieImageView)
        mainStack.addArrangedSubview(contentStack)
        
        contentStack.addArrangedSubview(trackNameLabel)
        contentStack.addArrangedSubview(genreLabel)
        contentStack.addArrangedSubview(priceLabel)
        
        contentView.addSubview(mainStack)
        contentView.addSubview(fevButton)
    }
    
    private func setupBindings(){
        self.fevButton.rx
            .tap
            .bind { [weak self] _ in
                if self?.movie != nil {
                    
                    self?.viewModel.addFavorite(movie: (self?.movie!)!) // call function to add favorite
                    self?.checkFevStatus() // recall this method to validate favorite button status
                }
            }.disposed(by: self.disposeBag)
        
    }
    
    private func applyConstrains(){
        let mainStackConstrains = [
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        let movieImageViewConstrains = [
            movieImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            movieImageView.heightAnchor.constraint(equalToConstant: 210)
        ]
        
        let fevButtonConstrains = [
            fevButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -3),
            fevButton.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10),
            fevButton.heightAnchor.constraint(equalToConstant: 40),
            fevButton.widthAnchor.constraint(equalToConstant: 40)
        ]
        
        
        NSLayoutConstraint.activate(mainStackConstrains)
        NSLayoutConstraint.activate(movieImageViewConstrains)
        NSLayoutConstraint.activate(fevButtonConstrains)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag() // dispose all current subscribed Rx events to avoid memory leaks
    }
    
    // MARK: - Download & Load image from URL
    private func loadImage(url:String){
        // I have used Alamofire to download image from URL,
        AF.request(url,method: .get).response{ response in
            
            switch response.result {
            case .success(let responseData):
                // resize and assign movie image from downloaded image source
                self.movieImageView.image = UIImage(data: responseData!)?.resized(to: CGSize(width: 150, height: 200))
                
            case .failure(_):
                // assign placeholder image
                self.movieImageView.image = UIImage(named: "MoviePlaceHolder")
            }
            
        }
        
    }
}
