//
//  KeychainManager.swift
//  Credit Card Store
//
//  Created by Alperen Duran on 8.08.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

import Foundation
import KeychainSwift
import RxSwift

struct KeychainManager {
    let instance: KeychainSwift
    let (cardsObserver, cardsObservable) = Observable<[Card]>.sharedPipe()
    
    init() {
        instance = KeychainSwift()
        instance.synchronizable = true
        let cards = try? instance.getObject(forKey: UserDefaultsKey.savedCards.rawValue, castTo: [Card].self)
        if let cards = cards {
            cardsObserver.onNext(cards)
        }
    }
}

// MARK: - External Workers
extension KeychainManager {
    func save(value: String, key: KeychainKey) {
        instance.set(value, forKey: key.rawValue)
    }
    
    func delete(key: KeychainKey) {
        guard has(key: key) else { return }
        instance.delete(key.rawValue)
    }
    
    func get(key: KeychainKey) -> String? {
        instance.get(key.rawValue)
    }
    
    func has(key: KeychainKey) -> Bool {
        let value = instance.get(key.rawValue)
        return value != nil
    }
    
    func clear() {
        instance.clear()
    }
    
    func addCard(card: Card) {
        var cards = getCards()
        cards.insert(card, at: 0)
        cardsObserver.onNext(cards)
        try! instance.setObject(cards, forKey: UserDefaultsKey.savedCards.rawValue)
    }
    
    func getCards() -> [Card] {
        let cards = try? instance.getObject(
            forKey: UserDefaultsKey.savedCards.rawValue,
            castTo: [Card].self
        )
        if let cards = cards {
            cardsObserver.onNext(cards)
        }
        return cards ?? []
    }
    
    func deleteCard(at index: Int) {
        var cards = getCards()
        cards.remove(at: index)
        cardsObserver.onNext(cards)
        try! instance.setObject(
            cards,
            forKey: UserDefaultsKey.savedCards.rawValue
        )
    }
}
