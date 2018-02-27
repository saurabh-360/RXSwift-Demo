//
//  UIView+Extensions.swift
//  RXSwift1.1
//
//  Created by Saurabh Yadav on 27/02/18.
//  Copyright © 2018 Saurabh Yadav. All rights reserved.
//

import UIKit

extension UIView {
    
    func dropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 1, height: 0.5)
        self.layer.shadowRadius = 1
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        
        self.layer.rasterizationScale = UIScreen.main.scale
        
    }
    
    func addShadowView(width:CGFloat=0.0, height:CGFloat=1.0,radius:CGFloat=4.0, Opacidade:Float=0.2, maskToBounds:Bool=false) {
        
        var shadowLayer: CAShapeLayer!
        
        shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 12).cgPath
        shadowLayer.fillColor = UIColor.clear.cgColor
        
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        shadowLayer.shadowOpacity = 0.1
        shadowLayer.shadowRadius = 2
        
        self.layer.insertSublayer(shadowLayer, at: 0)
        self.layer.masksToBounds = true
        self.layer.borderWidth = 0.5
        
        
    }
    
    func setGradientWithColors(bottomColor : UIColor?, topColor : UIColor?){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        
        let updatedFrame = self.bounds
        gradientLayer.frame = updatedFrame
        
        gradientLayer.colors = [bottomColor?.cgColor ?? UIColor.blue,topColor?.cgColor ?? UIColor.gray]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
