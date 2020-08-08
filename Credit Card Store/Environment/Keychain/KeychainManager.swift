//
//  KeychainManager.swift
//  Credit Card Store
//
//  Created by Alperen Duran on 8.08.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

import Foundation
import KeychainSwift

struct KeychainManager {
    let instance: KeychainSwift
    
    init() {
        instance = KeychainSwift()
        instance.synchronizable = true
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
    
    func getCards() -> [Card] {
        let data = instance.getData(KeychainKey.creditCards.rawValue) ?? .init()
        let decodedData = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Card] ?? []
        return decodedData
    }
    
    func addCard(card: Card) {
        var cards = getCards()
        cards.append(card)
        let encodedData = try! NSKeyedArchiver.archivedData(
            withRootObject: cards,
            requiringSecureCoding: false
        )
        instance.set(encodedData, forKey: KeychainKey.creditCards.rawValue)
    }
}
