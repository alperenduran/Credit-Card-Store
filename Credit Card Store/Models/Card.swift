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
//    let cardType: CardType
}

//extension Card {
//    var isAmex: Bool {
//        let cardNumberPrefix = cardNumber.prefix(2)
//        let isAmex = cardNumberPrefix == "34" || cardNumberPrefix == "37"
//        return isAmex
//    }
//    
//    var cardTypeLogo: String {
//        switch cardType {
//        case .masterCard:
//            return "masterCardLogo"
//        case .visa:
//            return "visaLogo"
//        case .amex:
//            return "amexLogo"
//        case .maestro:
//            return "maestroLogo"
//        case .other:
//            return "otherLogo"
//        }
//    }
//}

enum CardType: String {
    case masterCard = "MasterCard"
    case visa = "Visa"
    case amex = "American Express"
    case maestro = "Maestro"
    case other = "Other"
}
