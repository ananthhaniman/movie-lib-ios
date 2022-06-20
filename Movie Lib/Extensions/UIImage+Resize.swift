//
//  UIImage+Resize.swift
//  Movie Lib
//
//  Created by Ananthamoorthy Haniman on 2022-05-23.
//

import Foundation
import UIKit

extension UIImage {
    
    // MARK: - Compont from UiImage and extent the class and achived image resize funtionalities.(there is no defalult image resize funtionality for resizing image)
    /// `resized()` source from https://stackoverflow.com/questions/31314412/how-to-resize-image-in-swift
    func resized(to newSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: newSize).image { _ in
            let hScale = newSize.height / size.height
            let vScale = newSize.width / size.width
            let scale = max(hScale, vScale) // scaleToFill
            let resizeSize = CGSize(width: size.width*scale, height: size.height*scale)
            var middle = CGPoint.zero
            if resizeSize.width > newSize.width {
                middle.x -= (resizeSize.width-newSize.width)/2.0
            }
            if resizeSize.height > newSize.height {
                middle.y -= (resizeSize.height-newSize.height)/2.0
            }
            
            draw(in: CGRect(origin: middle, size: resizeSize))
        }
    }
}
