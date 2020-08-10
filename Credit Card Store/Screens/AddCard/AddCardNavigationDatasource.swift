//
//  AddCardNavigationDatasource.swift
//  Credit Card Store
//
//  Created by Alperen Duran on 10.08.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

import Foundation
import RxSwift

struct AddCardNavigationDatasource {
    let viewModel: AddCardViewModel
    let closeEvent = Observable<Void>.pipe()
}
