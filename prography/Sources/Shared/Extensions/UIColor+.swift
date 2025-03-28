//
//  UIColor+.swift
//  prography
//
//  Created by kangChangHyeok on 17/02/2025.
//

import UIKit

extension UIColor {
    /// hexString값을 사용하여 색상을 생성한다. alpha 기본값 = 1.0
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha)
    }
    
    static let main = UIColor(hex: "D81D45")
    static let prograhpyGray = UIColor(hex: "48454e")
    static let placeholderText = UIColor(hex: "b3b3b3")
    static let movieImageBackground = UIColor(hex: "6F4F56")
    
}
