import UIKit

// MARK: -

extension UIColor {
    
    // MARK: Colors in cache
    
    private static var colorsInCache: [String: UIColor] = [:]
    static func rgbaCache(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1.0) -> UIColor {
        let key = "\(r)\(g)\(b)\(a)"
        guard let cashedColor = colorsInCache[key] else {
            if colorsInCache.count > 100 {
                colorsInCache = [:]
            }
            let color = UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
            colorsInCache[key] = color
            return color
        }
        return cashedColor
    }
}

// MARK: -

extension UIView {
    
    // MARK: Storyboard Properties
    
    // Добавляем в storyboard используя @IBInspectable
    @IBInspectable var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    @IBInspectable var borderWigth: CGFloat {
        get { layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get { UIColor(cgColor: layer.borderColor!) }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    @IBInspectable var shadowWigth: CGFloat {
        get { layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get { UIColor(cgColor: layer.shadowColor!) }
        set { layer.shadowColor = newValue?.cgColor }
    }
    
    @IBInspectable var shadowOpacity: CGFloat {
        get { CGFloat(layer.shadowOpacity) }
        set { layer.shadowOpacity = Float(newValue) }
    }
    
}
