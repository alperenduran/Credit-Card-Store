//
//  UIViewControllerExtensions.swift
//  Credit Card Store
//
//  Created by Alperen Duran on 8.08.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - Child View Controller
extension UIViewController {
    func addChildController<T: UIViewController>(_ controller: T, viewHandler: (UIView) -> Void) {
        addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        viewHandler(controller.view)
        controller.didMove(toParent: self)
    }
    
    func showAlert(with title: String? = "Success",
                   message: String?,
                   buttonTitle: String? = "Tamam"
    ) -> Single<Void> {
        return Single.create(subscribe: { [weak self] single -> Disposable in
            guard let self = self else { return Disposables.create() }

            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okButtonAction = UIAlertAction(title: buttonTitle, style: .default) { _ in
                single(.success(()))
            }
            alertController.addAction(okButtonAction)

            self.present(alertController, animated: true, completion: nil)
            return Disposables.create {
                alertController.dismiss(animated: false, completion: nil)
            }
        })
    }
    
    func showErrorAlert(_ errorObject: ErrorObject) {
        let message = errorObject.description

        let alertController = UIAlertController(
            title: errorObject.title,
            message: message,
            preferredStyle: .alert
        )

        alertController.addAction(UIAlertAction(title: "OK", style: .default))

        self.present(alertController, animated: true, completion: nil)
    }
}

extension Reactive where Base: UIViewController {
    var showAlert: Binder<String> {
        Binder(base) { target, message in
            _ = target.showAlert(message: message).subscribe()
        }
    }
    
    var displayError: Binder<ErrorObject> {
        Binder(base) { (target, error) in
            target.showErrorAlert(error)
        }
    }
}
