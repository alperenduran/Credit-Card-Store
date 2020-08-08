//
//  UserDefaultsMediator.swift
//  Credit Card Store
//
//  Created by Alperen Duran on 8.08.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

import Foundation

struct UserDefaultsMediator {
    var set = Environment.userDefaultsManager.set(_: key:)
    var sync = Environment.userDefaultsManager.sync
    var object = Environment.userDefaultsManager.object(key:)
    var remove = Environment.userDefaultsManager.remove(key:)
    var addCard = Environment.userDefaultsManager.addCard(card:)
    var getCards = Environment.userDefaultsManager.getCards
    var observe = Environment.userDefaultsManager.observe(key:)
}
