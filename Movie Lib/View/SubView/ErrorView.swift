//
//  ErrorView.swift
//  Movie Lib
//
//  Created by Ananthamoorthy Haniman on 2022-05-24.
//

import UIKit

class ErrorView: UIView{
    
    let contentStack:UIStackView = {
        let cs = UIStackView()
        cs.axis = .vertical
        cs.alignment = .center
        cs.spacing = 5
        cs.translatesAutoresizingMaskIntoConstraints = false
        return cs
    }()
    
    
    let errorImageView:UIImageView = {
        let eiv = UIImageView(image: UIImage(named: "SearchMovie")?.resized(to: CGSize(width: 70, height: 70)).withRenderingMode(.alwaysTemplate))
        eiv.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        eiv.contentMode = .scaleAspectFit
        eiv.tintColor = Constant.primaryTextColor
        eiv.clipsToBounds = true
        return eiv
    }()
    
    let contentTitle:UILabel = {
        let ct = UILabel()
        ct.text = "Search Movies"
        ct.font = .preferredFont(forTextStyle: .headline)
        ct.textColor = Constant.primaryTextColor
        return ct
    }()
    
    let contentDescription:UILabel = {
        let cd = UILabel()
        cd.text = "Search some movies and get details about it"
        cd.font = .preferredFont(forTextStyle: .body)
        cd.textAlignment = .center
        cd.numberOfLines = 20
        cd.textColor = Constant.secounderyTextColor
        return cd
    }()
    
    // MARK: - assign error info based on Error Type
    func config(error:APIError){
        switch error {
        case .ServerError(let message):
            contentTitle.text = "Server Error"
            contentDescription.text = message
            errorImageView.image = UIImage(named: "Error")?.resized(to: CGSize(width: 70, height: 70)).withRenderingMode(.alwaysTemplate)
        case .ResultNotFound:
            contentTitle.text = "Sorry! No results found"
            contentDescription.text = "We couldn't find what you're looking for"
            errorImageView.image = UIImage(named: "NotFound")?.resized(to: CGSize(width: 70, height: 70)).withRenderingMode(.alwaysTemplate)
        case .NetworkError(let message):
            contentTitle.text = "Network error"
            contentDescription.text = message
            errorImageView.image = UIImage(named: "Error")?.resized(to: CGSize(width: 70, height: 70)).withRenderingMode(.alwaysTemplate)
        case .realmError(message: let message):
            contentTitle.text = "Something went wrong"
            contentDescription.text = message
            errorImageView.image = UIImage(named: "Error")?.resized(to: CGSize(width: 70, height: 70)).withRenderingMode(.alwaysTemplate)
        case .EmptyList:
            contentTitle.text = "No Favorites Yet!"
            contentDescription.text = "Save your favorite movies and find them here later"
            errorImageView.image = UIImage(named: "EmptyFav")?.resized(to: CGSize(width: 70, height: 70)).withRenderingMode(.alwaysTemplate)
        }
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    private func setupUI(){
        contentStack.addArrangedSubview(errorImageView)
        contentStack.addArrangedSubview(contentTitle)
        contentStack.addArrangedSubview(contentDescription)
        
        self.addSubview(contentStack)
        
        let contentStackConstrains = [
            contentStack.widthAnchor.constraint(equalTo: self.widthAnchor,constant: -150),
            contentStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            contentStack.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(contentStackConstrains)
        
    }
}

