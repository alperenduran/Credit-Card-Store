//
//  KeyboardHelper.swift
//  Credit Card Store
//
//  Created by Alperen Duran on 17.08.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

import RxSwift
import UIKit

final class KeyboardHelper: NSObject {
    
    // MARK: - Properties
    struct KeyboardInfo {
        let frame: CGRect
        let animationDuration: CGFloat
        let animationCurve: UIView.AnimationOptions
        let isShowing: Bool
    }
    
    private(set) var bag: DisposeBag
    private(set) lazy var keyboardChange = PublishSubject<KeyboardInfo>()
    private var willShow: NSObjectProtocol?
    private var willHide: NSObjectProtocol?
    
    // MARK: - Initialization
    override init() {
        bag = DisposeBag()
        
        super.init()
        
        let showKeyboardObservable = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
        let hideKeyboardObservable = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
        
        Observable.of(showKeyboardObservable, hideKeyboardObservable)
            .merge()
            .subscribe(onNext: { [weak self] notification in
                guard let self = self else { return }
                self.handle(notification: notification)
            }).disposed(by: bag)
    }
}

// MARK: - Handle Keyboard notification
private extension KeyboardHelper {
    private func handle(notification: Notification) {
        let frame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt ?? 0
        guard let _frame = frame, let _animationDuration = animationDuration else { return }
        let isShowing = notification.name == UIResponder.keyboardWillShowNotification
        let keyboardInfo = KeyboardInfo(
            frame: _frame,
            animationDuration: CGFloat(_animationDuration),
            animationCurve: UIView.AnimationOptions(rawValue: curve << 16),
            isShowing: isShowing
        )
        keyboardChange.onNext(keyboardInfo)
    }
}

