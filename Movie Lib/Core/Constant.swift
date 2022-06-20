//
//  Constant.swift
//  Movie Lib
//
//  Created by Ananthamoorthy Haniman on 2022-05-24.
//

import Foundation
import UIKit

struct Constant{
    
    static var backgroundColor:UIColor = {
        if #available(iOS 13.0, *) {
            return .systemBackground
        }
        return .black
    }()
    static let primaryTextColor:UIColor = {
        if #available(iOS 13.0, *) {
            return .label
        }
        return .white
    }()
    static let secounderyTextColor:UIColor = .gray
    static let primaryColor:UIColor = .systemRed
}
