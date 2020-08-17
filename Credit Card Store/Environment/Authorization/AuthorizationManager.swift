//
//  AuthorizationManager.swift
//  Credit Card Store
//
//  Created by Alperen Duran on 17.08.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

import Foundation
import RxSwift

struct AuthorizationManager {
    let (authorizationObserver, authorizationObservable) = Observable<Bool>.pipe()
    
    func authorize() {
        authorizationObserver.onNext(true)
    }
}
