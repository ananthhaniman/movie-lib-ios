//
//  FavoriteCellView.swift
//  Movie Lib
//
//  Created by Ananthamoorthy Haniman on 2022-05-25.
//

import Foundation
import Alamofire
import UIKit
import RxSwift
import RxCocoa

class FavoriteCellView: UITableViewCell{
    
    static let indentifier = "favoriteCell"
    
    private let infoStack:UIStackView = {
        let infoStack = UIStackView()
        infoStack.axis = .horizontal
        infoStack.alignment = .top
        infoStack.spacing = 15
        infoStack.translatesAutoresizingMaskIntoConstraints = false
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
        tl.font = .preferredFont(forTextStyle: .headline)
        tl.textColor = Constant.primaryTextColor
        return tl
    }()
    
    private let trackGenre:UILabel = {
        let tg = UILabel()
        tg.font = .preferredFont(forTextStyle: .subheadline)
        tg.textColor = Constant.secounderyTextColor
        return tg
    }()
    
    private let trackPrice:UILabel = {
        let tp = UILabel()
        tp.font = .systemFont(ofSize: 14, weight: .semibold)
        tp.textColor = Constant.primaryColor
        return tp
    }()
    
    var movie:MovieEntity?
    
    
    private let movieImageView:UIImageView = {
        let miv = UIImageView(image: UIImage(named: "MoviePlaceHolder")?.resized(to: CGSize(width: 100, height: 150)))
        miv.frame = CGRect(x: 0, y: 0, width: 60, height: 230)
        miv.contentMode = .scaleToFill
        miv.layer.cornerRadius = 10
        miv.clipsToBounds = true
        miv.translatesAutoresizingMaskIntoConstraints = false
        return miv
    }()
    
    private var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        applyConstrains()
    }
    
    func config(movie:MovieEntity){
        trackPrice.text = "\(String(movie.trackPrice)) \(movie.currency)"
        trackGenre.text = movie.primaryGenreName
        trackTitle.text = movie.trackName
        self.movie = movie
        loadImage(url: movie.artworkUrl100)
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    
    private func setupUI(){
        
        infoStack.addArrangedSubview(movieImageView)
        infoStack.addArrangedSubview(infoContentStack)
        
        infoContentStack.addArrangedSubview(trackTitle)
        infoContentStack.addArrangedSubview(trackGenre)
        infoContentStack.addArrangedSubview(trackPrice)
        
        contentView.addSubview(infoStack)
    }
    
    private func applyConstrains(){
        let infoStackConstrains = [
            infoStack.widthAnchor.constraint(equalTo: contentView.widthAnchor,constant: -40),
            infoStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            infoStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        NSLayoutConstraint.activate(infoStackConstrains)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    private func loadImage(url:String){
        AF.request(url,method: .get).response{ response in
            
            switch response.result {
            case .success(let responseData):
                self.movieImageView.image = UIImage(data: responseData!)?.resized(to: CGSize(width: 100, height: 150))
            case .failure(_):
                self.movieImageView.image = UIImage(named: "MoviePlaceHolder")?.resized(to: CGSize(width: 100, height: 150))
            }
        }
    }
}
