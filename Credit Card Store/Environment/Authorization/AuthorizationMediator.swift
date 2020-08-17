//
//  AuthorizationMediator.swift
//  Credit Card Store
//
//  Created by Alperen Duran on 17.08.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

import Foundation

struct AuthorizationMediator {
    var authorize = Environment.authorizationManager.authorize
    var authorizeObservable = Environment.authorizationManager.authorizationObservable
    var authorizeObserver = Environment.authorizationManager.authorizationObserver
}
