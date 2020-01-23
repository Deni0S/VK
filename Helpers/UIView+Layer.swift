//
//  UIView+Layer.swift
//  VK
//
//  Created by Денис Баринов on 14.1.20.
//  Copyright © 2020 Денис Баринов. All rights reserved.
//

import UIKit

// MARK: - Добавим в storyboard используя @IBInspectable.
extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderWigth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}
