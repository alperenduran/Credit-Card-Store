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
            
            
            datasource.closeEvent.observable
                .subscribe(onNext: { [weak target] in
                    guard let target = target else { return }
                    target.navigationController?.popViewController(animated: true)
                })
                .disposed(by: controller.bag)
            
            target.show(controller, sender: nil)
        }
    }
}
