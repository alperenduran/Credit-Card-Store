//
//  Navigator.swift
//  Credit Card Store
//
//  Created by Alperen Duran on 10.08.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit
import IntentsUI

extension Reactive where Base: UIViewController {
    var showAddCard: Binder<Void> {
        Binder(base) { target, _ in
            let datasource = AddCardNavigationDatasource(viewModel: addCardViewModel)
            let controller = AddCardViewController(with: datasource)
            let navigationController = NavigationController(root: controller)
            
            datasource.closeEvent.observable
                .subscribe(onNext: {
                    controller.dismiss(animated: true)
                }).disposed(by: controller.bag)
            
            navigationController.modalPresentationStyle = .fullScreen
            target.present(navigationController, animated: true)
        }
    }
    
    var showAddSiri: Binder<Void> {
        Binder(base) { target, _ in
            guard let shortcut = INShortcut(intent: AddNewCardIntentIntent()) else { return }
            let siriViewController = INUIAddVoiceShortcutViewController(shortcut: shortcut)
            target.present(siriViewController, animated: true)
        }
    }
}

extension Reactive where Base == AddCardViewController {
    var showSuccess: Binder<Void> {
        Binder(base) { target, _ in
            let controller = SuccessViewController(with: successViewModel)
            
            controller.closeObservable
                .subscribe(onNext: { [weak target] in
                    controller.dismiss(animated: true) {
                        target?.datasource.closeEvent.observer.onNext(())
                    }
                }).disposed(by: controller.bag)
            
            controller.modalPresentationStyle = .fullScreen
            target.present(controller, animated: true)
        }
    }
}
