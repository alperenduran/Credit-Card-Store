//
//  UIApplicationExtension.swift
//  Credit Card Store
//
//  Created by Alperen Duran on 8.08.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

import UIKit

// MARK: - Safe Area
extension UIApplication {
    static var safeAreaInset: UIEdgeInsets {
        return keyWindow?.safeAreaInsets ?? .zero
    }
    
    static var safeAreaBottomInset: CGFloat {
        return safeAreaInset.bottom
    }
    
    static var safeAreaTopInset: CGFloat {
        return safeAreaInset.top
    }
}

// MARK: - Window Frame
extension UIApplication {
    static var keyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .map { $0 as? UIWindowScene }
                .compactMap { $0 }
                .first?.windows
                .filter { $0.isKeyWindow }
                .first
        } else {
            return UIApplication.shared.windows
                .filter {$0.isKeyWindow}.first
        }
    }
    
    static var windowFrame: CGRect {
        return keyWindow?.frame ?? .zero
    }
    
    static var windowWidth: CGFloat {
        return windowFrame.size.width
    }
    
    static var windowHeight: CGFloat {
        return windowFrame.size.height
    }
}

