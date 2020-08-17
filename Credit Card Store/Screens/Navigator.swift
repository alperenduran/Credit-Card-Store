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

extension Reactive where Base: UIViewController {
    var showAddCard: Binder<Void> {
        Binder(base) { target, _ in
            let datasource = AddCardNavigationDatasource(viewModel: addCardViewModel)
            let controller = AddCardViewController(with: datasource)
            let navigationController = NavigationController(root: controller)
            
            navigationController.modalPresentationStyle = .fullScreen
            target.present(navigationController, animated: true)
        }
    }
}
