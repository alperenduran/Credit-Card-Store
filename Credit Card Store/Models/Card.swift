//
//  Card.swift
//  Credit Card Store
//
//  Created by Alperen Duran on 8.08.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

import Foundation

struct Card: Codable {
    let name: String
    let cardNumber: String
    let cardholderName: String
    let expirationMonth: String
    let expirationYear: String
    let cvv: String
    
    var secureCardNumber: String {
        "••••   ••••   ••••   \(cardNumber.suffix(4))"
    }
}
