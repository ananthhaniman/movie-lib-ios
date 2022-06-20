//
//  EmptySearchView.swift
//  Movie Lib
//
//  Created by Ananthamoorthy Haniman on 2022-05-24.
//

import UIKit


class EmptySearchView: UIView{
    
    let titleLabel:UILabel = {
        let tl = UILabel()
        tl.textColor = Constant.primaryTextColor
        tl.font = .systemFont(ofSize: 28, weight: .semibold)
        return tl
    }()
    
    let descriptionLabel:UILabel = {
        let dl = UILabel()
        dl.text = "Last Active \(AppLog.shared.getLastAccess() ?? "")" // get user last accessed date and bind it in Label text
        dl.textColor = Constant.secounderyTextColor
        dl.alpha = AppLog.shared.getLastAccess() != nil ? 1 : 0
        dl.font = .preferredFont(forTextStyle: .subheadline)
        return dl
    }()
    
    let headerStack:UIStackView = {
        let hs = UIStackView()
        hs.spacing = 0
        hs.axis = .vertical
        hs.alignment = .top
        hs.translatesAutoresizingMaskIntoConstraints = false
        return hs
    }()
    
    let contentStack:UIStackView = {
        let cs = UIStackView()
        cs.axis = .vertical
        cs.alignment = .center
        cs.spacing = 5
        cs.translatesAutoresizingMaskIntoConstraints = false
        return cs
    }()
    
    
    let searchImageView:UIImageView = {
        let siv = UIImageView(image: UIImage(named: "SearchMovie")?.resized(to: CGSize(width: 70, height: 70)).withRenderingMode(.alwaysTemplate))
        siv.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        siv.contentMode = .scaleAspectFit
        siv.tintColor = Constant.primaryTextColor
        siv.clipsToBounds = true
        return siv
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
        cd.text = "Find your favorite movies and get to know about it"
        cd.font = .preferredFont(forTextStyle: .body)
        cd.textAlignment = .center
        cd.numberOfLines = 20
        cd.textColor = Constant.secounderyTextColor
        return cd
    }()
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Display greetings based on Day hours range
    private func greeting() -> String{
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 0..<12:
            return "Good morning"
        case 12..<16:
            return "Good afternoon"
        case 16..<20:
            return "Good evening"
        case 20..<24:
            return "Good night"
        default:
            return "Hello"
        }
    }
    
    private func setupUI(){
        contentStack.addArrangedSubview(searchImageView)
        contentStack.addArrangedSubview(contentTitle)
        contentStack.addArrangedSubview(contentDescription)
        
        headerStack.addArrangedSubview(titleLabel)
        headerStack.addArrangedSubview(descriptionLabel)
        
        titleLabel.text = greeting()
        
        self.addSubview(contentStack)
        self.addSubview(headerStack)
        
        let contentStackConstrains = [
            contentStack.widthAnchor.constraint(equalTo: self.widthAnchor,constant: -150),
            contentStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            contentStack.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        
        var headerStackConstrains = [
            headerStack.widthAnchor.constraint(equalTo: self.widthAnchor,constant: -40),
            headerStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            headerStack.topAnchor.constraint(equalTo: self.topAnchor,constant: 60)
        ]
        if #available(iOS 11.0, *) {
            headerStackConstrains = [
                headerStack.widthAnchor.constraint(equalTo: self.widthAnchor,constant: -40),
                headerStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                headerStack.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor,constant: 10)
            ]
        }
        
        
        NSLayoutConstraint.activate(headerStackConstrains)
        NSLayoutConstraint.activate(contentStackConstrains)
        
    }
}
