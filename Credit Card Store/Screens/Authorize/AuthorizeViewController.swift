//
//  AuthorizeViewController.swift
//  Credit Card Store
//
//  Created by Alperen Duran on 17.08.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import LocalAuthentication

final class AuthorizeViewController: UIViewController {
    
    // MARK: - Properties
    lazy var viewSource = AuthorizeView()
    let bag = DisposeBag()
    let viewModel: AuthorizeViewModel
    let (authorizeObserver, authorizeObservable) = Observable<Bool>.pipe()
    
    // MARK: - Initialization
    init(with viewModel: @escaping AuthorizeViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = viewSource
        view.backgroundColor = .appBgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        bindViewModelInputs()
    }
}

private extension AuthorizeViewController {
    private func bindViewModelInputs() {
        let outputs = viewModel(inputs)
        
        bag.insert(
            outputs.showAuthorization.drive(rx.showAuthorization),
            outputs.goToApp.drive(rx.goToApp)
        )
    }
    
    var inputs: AuthorizeViewModelInput {
        AuthorizeViewModelInput(
            openButtonTapped: viewSource.openSafeButton.rx.tap.asObservable(),
            authorized: authorizeObservable
        )
    }
}

extension Reactive where Base == AuthorizeViewController {
    var showAuthorization: Binder<Void> {
        Binder(base) { target, _ in
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(
                .deviceOwnerAuthentication,
                error: &error
            ) {
                let reason = "Unlock the app"
                
                context.evaluatePolicy(
                    .deviceOwnerAuthentication,
                    localizedReason: reason
                ) {
                    [weak target] success, authenticationError in
                    
                    DispatchQueue.main.async {
                        if success {
                            target?.authorizeObserver.onNext(true)
                        } else {
                            print("failed")
                        }
                    }
                }
            } else {
                Current.authorization.authorizeObserver.onNext(true)
            }
        }
    }
    
    var goToApp: Binder<Void> {
        Binder(base) { target, _ in
            Current.authorization.authorize()
        }
    }
}
