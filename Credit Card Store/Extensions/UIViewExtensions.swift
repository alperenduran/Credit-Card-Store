//
//  UIViewExtensions.swift
//  Credit Card Store
//
//  Created by Alperen Duran on 8.08.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol ViewIdentifier: class {
    static var identifier: String { get }
}

extension ViewIdentifier {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIView: ViewIdentifier {}

extension UIView {
    func round(corners: UIRectCorner, radius: CGFloat) {
        let size = CGSize(width: radius, height: radius)
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: size
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

// MARK: - Shadow
extension UIView {
    func makeShadow(
        offSet: CGSize = .zero,
        color: UIColor = .black,
        opacity: Float,
        radius: CGFloat
    ) {
        
        layer.shadowOffset = offSet
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
}

// MARK: - Gesture + Rx
protocol GestureProtocol {}

extension GestureProtocol where Self: UIView {
    func addTapGesture() -> Observable<Void> {
        isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        addGestureRecognizer(tapGesture)
        return tapGesture.rx.event
            .asObservable()
            .map { _ in }
    }
    
    func addPinchGesture() -> Observable<UIPinchGestureRecognizer> {
        isUserInteractionEnabled = true
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: nil)
        addGestureRecognizer(pinchGesture)
        return pinchGesture.rx.event
            .asObservable()
    }
}

extension UIView: GestureProtocol {}

// MARK: - Animations
extension UIView {
    func rotateInfinetly(duration: CFTimeInterval = 1.5) {
        let animation = CAKeyframeAnimation(
            keyPath: "transform.rotation.z"
        )
        
        animation.duration = duration
        animation.fillMode = .forwards
        animation.repeatCount = .infinity
        
        let pi = Double.pi
        animation.values = [
            0,
            pi / 2,
            pi,
            pi * 3 / 2,
            pi * 2
        ]
        
        layer.add(
            animation,
            forKey: "rotate"
        )
    }
}
