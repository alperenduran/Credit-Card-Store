//
//  AuthorizeViewModel.swift
//  Credit Card Store
//
//  Created by Alperen Duran on 17.08.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct AuthorizeViewModelInput {
    var openButtonTapped: Observable<Void> = .never()
    var authorized: Observable<Bool> = .never()
}

struct AuthorizeViewModelOutput {
    let showAuthorization: Driver<Void>
    let goToApp: Driver<Void>
}

typealias AuthorizeViewModel = (AuthorizeViewModelInput) -> AuthorizeViewModelOutput

func authorizeViewModel(
    _ inputs: AuthorizeViewModelInput
) -> AuthorizeViewModelOutput {
    return AuthorizeViewModelOutput(
        showAuthorization: inputs.openButtonTapped.asDriver(onErrorDriveWith: .never()),
        goToApp: getGoToAppOutput(inputs)
    )
}

private func getGoToAppOutput(
    _ inputs: AuthorizeViewModelInput
) -> Driver<Void> {
    inputs.authorized
        .filter { $0 }
        .map { _ in }
        .asDriver(onErrorDriveWith: .never())
}
