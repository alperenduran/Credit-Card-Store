//
//  UIFontExtensions.swift
//  Credit Card Store
//
//  Created by Alperen Duran on 8.08.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

import UIKit

extension UIFont {
    // MARK: - Create
    static func font(
        family: FontFamily = .airbnbCereal,
        type: FontType,
        size: CGFloat
    ) -> UIFont {
        
        let fontName = "\(family.rawValue)-\(type.rawValue)"
        let font = UIFont(name: fontName, size: size) ?? .boldSystemFont(ofSize: size)
        return font
    }
}

// MARK: - Enums
enum FontType: String {
    case black = "Black"
    case bold = "Bold"
    case book = "Book"
    case extraBold = "ExtraBold"
    case light = "Light"
    case medium = "Medium"
}

enum FontFamily: String {
    case airbnbCereal = "AirbnbCerealApp"
}

