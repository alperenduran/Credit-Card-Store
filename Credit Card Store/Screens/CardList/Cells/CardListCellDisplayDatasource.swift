//
//  CardListCellDisplayDatasource.swift
//  Credit Card Store
//
//  Created by Alperen Duran on 8.08.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

import Foundation
import UIKit

struct CardListCellDisplayDatasource {
    let name: String
    let cardNumber: String
    let cardholder: String
    let expirationDate: String
    let cvv: String
    let cardType: CardType
}

extension CardListCellDisplayDatasource {
    var cardTypeLogo: String {
        switch cardType {
        case .masterCard:
            return "masterCardLogo"
        case .visa:
            return "visaLogo"
        case .amex:
            return "amexLogo"
        case .maestro:
            return "maestroLogo"
        case .other:
            return "otherLogo"
        }
    }
    
    var backgroundColor: UIColor {
        switch cardType {
        case .masterCard:
            return .masterCardColor
        case .visa:
            return .visaColor
        case .amex:
            return .amexColor
        case .maestro:
            return .maestroColor
        case .other:
            return . otherCardColor
        }
    }
}
