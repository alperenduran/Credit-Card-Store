//
//  UIViewControllerExtensions.swift
//  Credit Card Store
//
//  Created by Alperen Duran on 8.08.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

import UIKit

// MARK: - Child View Controller
extension UIViewController {
    func addChildController<T: UIViewController>(_ controller: T, viewHandler: (UIView) -> Void) {
        addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        viewHandler(controller.view)
        controller.didMove(toParent: self)
    }
}

