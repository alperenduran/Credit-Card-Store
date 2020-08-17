//
//  SuccessViewModel.swift
//  Credit Card Store
//
//  Created by Alperen Duran on 17.08.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct SuccessViewModelInput {
    var returnButtonTapped: Observable<Void> = .never()
}

struct SuccessViewModelOutput {
    let returnToWallet: Driver<Void>
}

typealias SuccessViewModel = (SuccessViewModelInput) -> SuccessViewModelOutput

func successViewModel(
    _ inputs: SuccessViewModelInput
) -> SuccessViewModelOutput {
    return SuccessViewModelOutput(
        returnToWallet: inputs.returnButtonTapped.asDriver(onErrorDriveWith: .never())
    )
}
