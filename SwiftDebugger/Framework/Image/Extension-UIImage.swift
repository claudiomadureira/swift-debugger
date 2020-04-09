//
//  Extension-UIImage.swift
//
//  Created by Claudio Madureira on 11/12/19.
//  Copyright © 2019. All rights reserved.
//

import UIKit

public extension UIImage {
    
    // MARK: - Size
    
    func resize(toWidth newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        return self.resize(to: .init(width: newWidth, height: newHeight))
    }
    
    func resize(to targetSize: CGSize) -> UIImage {
        if #available(iOS 10.0, *) {
            return UIGraphicsImageRenderer(size: targetSize).image { _ in
                self.draw(in: CGRect(origin: .zero, size: targetSize))
            }
        } else {
            return self.resizeImage(maxSize: targetSize.width)
        }
    }
    
    func resizeImage(maxSize: CGFloat) -> UIImage {
        var newWidth = size.width
        var newHeight = size.height
        
        if size.width >= maxSize {
            newWidth = min(maxSize, size.width)
            newHeight = maxSize * size.height / size.width
        } else if size.height >= maxSize {
            newHeight = min(maxSize, size.height)
            newWidth = maxSize * size.width / size.height
        }
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }

    /**
     Tint Picto to color

     - parameter fillColor: UIColor

     - returns: UIImage
     */
    func tintPicto(_ fillColor: UIColor) -> UIImage {

        return modifiedImage { context, rect in
            // draw tint color
            context.setBlendMode(.normal)
            fillColor.setFill()
            context.fill(rect)

            // mask by alpha values of original image
            context.setBlendMode(.destinationIn)
            context.draw(cgImage!, in: rect)
        }
    }

    /**
     Modified Image Context, apply modification on image

     - parameter draw: (CGContext, CGRect) -> ())

     - returns: UIImage
     */
    fileprivate func modifiedImage(_ draw: (CGContext, CGRect) -> ()) -> UIImage {

        // using scale correctly preserves retina images
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context: CGContext! = UIGraphicsGetCurrentContext()
        assert(context != nil)

        // correctly rotate image
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)

        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)

        draw(context, rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

}

