//
//  UIImageView+Extension.swift
//  reRE
//
//  Created by chihoooon on 2024/06/23.
//

import UIKit

extension UIImageView {
    func fillColor(with color: UIColor?, percentage: CGFloat) {
        guard let image = self.image else { return }
        guard let color = color else { return }
        
        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(in: rect)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setBlendMode(CGBlendMode.sourceIn)
        
        context.setFillColor(color.cgColor)
        
        let rectToFill = CGRect(x: 0,
                                y: 0,
                                width: image.size.width * percentage,
                                height: image.size.height)
        context.fill(rectToFill)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.image = newImage
    }
}
