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
    
    var color: UIColor {
        getColor()
    }
}

private func getColor() -> UIColor {
    let colors: [UIColor] = [
        .lightishBlue,
        .darkGreyBlue,
        .pumpkinOrange,
        .appBlackColor
    ]
    if let color = colors.randomElement() {
        return color
    } else {
        return .appBlueColor
    }
}
