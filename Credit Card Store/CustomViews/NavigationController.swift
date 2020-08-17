//
//  NavigationController.swift
//  Credit Card Store
//
//  Created by Alperen Duran on 8.08.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

import UIKit
import RxSwift

final class NavigationController: UINavigationController, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    private(set) var bag = DisposeBag()
    private(set) lazy var barButtonAction = PublishSubject<Void>()
    
    // MARK: - Initialization
    init(
        root: UIViewController,
        bgColor: UIColor = .appBgColor,
        tintColor: UIColor = .white,
        titleFont: UIFont = .font(type: .medium, size: 21.0)
    ) {
        
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .appBgColor
        
        setViewControllers([root], animated: true)
        
        setup(
            bgColor: bgColor,
            tintColor: tintColor,
            titleFont: titleFont
        )
        
        if viewControllers.count == 1 && shouldAddCloseButton {
            setRightBarButton(for: viewControllers.first)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactivePopGestureRecognizer?.delegate = self
    }
}

// MARK: - GestureRecognizer Should Begin
extension NavigationController {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == interactivePopGestureRecognizer {
            return viewControllers.count > 1
        }
        return true
    }
}

// MARK: - Push ViewController
extension NavigationController {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        
        if viewControllers.count > 1 {
            setLeftBarButton(for: viewController)
        } else if shouldAddCloseButton {
            setRightBarButton(for: viewController)
        }
    }
}

// MARK: - Set UINavigationBarButtons
private extension NavigationController {
    func setLeftBarButton(for controller: UIViewController) {
        controller.navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    func setRightBarButton(for controller: UIViewController?) {
        controller?.navigationItem.leftBarButtonItem = closeBarButtonItem
    }
}

// MARK: - Internal Workers
private extension NavigationController {
    func setup(
        bgColor: UIColor = .appBgColor,
        tintColor: UIColor = .white,
        titleFont: UIFont = .font(type: .medium, size: 21.0)
    ) {
        
        navigationBar.barTintColor = bgColor
        navigationBar.backgroundColor = bgColor
        navigationBar.tintColor = tintColor
        
        let emptyImage = UIImage()
        navigationBar.shadowImage = emptyImage
        
        navigationBar.setBackgroundImage(
            emptyImage,
            for: .default
        )
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: tintColor,
            NSAttributedString.Key.font: titleFont
        ]
        navigationBar.titleTextAttributes = attributes
        navigationBar.isTranslucent = false
    }
    
    var shouldAddCloseButton: Bool {
        rootController is AddCardViewController
    }
    
    var closeBarButtonItem: UIBarButtonItem {
        let closeButton = UIBarButtonItem(
            image: UIImage(named: "close"),
            style: .plain,
            target: nil,
            action: nil
        )
        
        closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.barButtonAction.onNext(())
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: bag)
        
        return closeButton
    }
    
    var backBarButtonItem: UIBarButtonItem {
        let backButton = UIBarButtonItem(
            image: UIImage(named: "back"),
            style: .plain,
            target: nil,
            action: nil
        )
        
        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.barButtonAction.onNext(())
                self.popViewController(animated: true)
            })
            .disposed(by: bag)
        
        return backButton
    }
}

// MARK: - External Workers
extension NavigationController {
    var rootController: UIViewController? {
        return viewControllers.first
    }
}

