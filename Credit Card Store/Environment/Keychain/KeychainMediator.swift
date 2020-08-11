//
//  KeychainMediator.swift
//  Credit Card Store
//
//  Created by Alperen Duran on 8.08.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

import Foundation

struct KeychainMediator {
    var save = Environment.keychainManager.save(value: key:)
    var delete = Environment.keychainManager.delete(key:)
    var get = Environment.keychainManager.get(key:)
    var has = Environment.keychainManager.has(key:)
    var clear = Environment.keychainManager.clear
    var addCard = Environment.keychainManager.addCard(card:)
    var getCards = Environment.keychainManager.getCards
    var cardsEvent = Environment.keychainManager.cardsObservable
    var removeCard = Environment.keychainManager.deleteCard(at:)
}
