//
//  Environment.swift
//  Credit Card Store
//
//  Created by Alperen Duran on 8.08.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

import Foundation

struct Environment {
    var keychain = KeychainMediator()
    
    static var keychainManager: KeychainManager!
}

var Current: Environment!
