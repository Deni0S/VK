//
//  UIColor+Extension.swift
//  VK
//
//  Created by Денис Баринов on 20.5.20.
//  Copyright © 2020 Денис Баринов. All rights reserved.
//

import UIKit

extension UIColor {
    private static var colorsCache: [String: UIColor] = [:]
    
    public static func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, a: CGFloat) -> UIColor {
        let key = "\(r)\(g)\(b)\(a)"
        if let cashedColor = self.colorsCache[key] {
            return cashedColor
        }
        self.clearColorsCasheIfNeeded()
        let color = UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
        self.colorsCache[key] = color
        return color
    }
    
    public static func clearColorsCasheIfNeeded() {
        let maxObjectsCount = 100
        guard self.colorsCache.count >= maxObjectsCount else { return }
        colorsCache = [:]
    }
}
