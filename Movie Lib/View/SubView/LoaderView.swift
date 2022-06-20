//
//  LoaderView.swift
//  Movie Lib
//
//  Created by Ananthamoorthy Haniman on 2022-05-24.
//

import UIKit

class LoaderView:UIView{
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI(){
        let loaderView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        loaderView.color = Constant.secounderyTextColor
        loaderView.center = self.center
        loaderView.hidesWhenStopped = true
        loaderView.startAnimating()
        addSubview(loaderView)
    }
    
}
