//
//  With.swift
//  Credit Card Store
//
//  Created by Alperen Duran on 8.08.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

@discardableResult
@inlinable
func with<T>(_ subject: T, _ transform: (_ subject: inout T) throws -> Void) rethrows -> T {
    var subject = subject
    try transform(&subject)
    return subject
}
