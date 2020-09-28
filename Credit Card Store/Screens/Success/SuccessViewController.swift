//
//  SuccessViewController.swift
//  Credit Card Store
//
//  Created by Alperen Duran on 17.08.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Hero

final class SuccessViewController: UIViewController {
    
    // MARK: - Properties
    lazy var viewSource = SuccessView()
    let bag = DisposeBag()
    let viewModel: SuccessViewModel
    let (closeObserver, closeObservable) = Observable<Void>.pipe()
    
    // MARK: - Initialization
    init(with viewModel: @escaping SuccessViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = viewSource
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        bindViewModelInputs()
        
        self.hero.isEnabled = true
    }
}

private extension SuccessViewController {
    private func bindViewModelInputs() {
        let outputs = viewModel(inputs)
        
        bag.insert(
            outputs.returnToWallet.drive(closeBinder)
        )
    }
    
    var inputs: SuccessViewModelInput {
        SuccessViewModelInput(
            returnButtonTapped: viewSource.button.rx.tap.asObservable()
        )
    }
    
    var closeBinder: Binder<Void> {
        Binder(self) { target, _ in
            target.closeObserver.onNext(())
        }
    }
}
