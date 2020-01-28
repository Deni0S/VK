//
//  AvatarViewCustom.swift
//  VK
//
//  Created by Денис Баринов on 26.1.20.
//  Copyright © 2020 Денис Баринов. All rights reserved.
//

import UIKit

@IBDesignable class AvatarViewCustom: UIView {
    @IBInspectable var radius: CGFloat = 100 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else {return}
        context.setShadow(offset: .zero, blur: 10, color: UIColor.systemGray.cgColor)
        context.fillEllipse(in: CGRect(x: rect.midX - radius, y: rect.midY - radius, width: radius * 2, height: radius * 2))
    }
    
    override func setNeedsDisplay() {
    }
}
