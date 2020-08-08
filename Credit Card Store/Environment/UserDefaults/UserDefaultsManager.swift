//
//  UserDefaultsManager.swift
//  Credit Card Store
//
//  Created by Alperen Duran on 8.08.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

import Foundation
import RxSwift

struct UserDefaultsManager {
    private let instance = UserDefaults.standard
    
    func set(_ value: Any?, key: UserDefaultsKey) {
        instance.set(value, forKey: key.rawValue)
    }
    
    func sync() {
        instance.synchronize()
    }
    
    func object(key: UserDefaultsKey) -> Any? {
        instance.object(forKey: key.rawValue)
    }
    
    func remove(key: UserDefaultsKey) {
        instance.removeObject(forKey: key.rawValue)
    }
    
    func addCard(card: Card) {
        var cards = getCards()
        cards.append(card)
        try! instance.setObject(cards, forKey: UserDefaultsKey.savedCards.rawValue)
    }
    
    func getCards() -> [Card] {
        let cards = try? instance.getObject(forKey: UserDefaultsKey.savedCards.rawValue, castTo: [Card].self)
        return cards ?? []
    }
    
    func observe(key: UserDefaultsKey) -> Observable<Any?> {
        instance.rx.observe(Any.self, key.rawValue)
    }
}

