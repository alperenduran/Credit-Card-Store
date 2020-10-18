//
//  IntentHandler.swift
//  PelicanSiri
//
//  Created by Alperen Duran on 18.10.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

import Intents

class IntentHandler: INExtension, AddNewCardIntentIntentHandling {
    func handle(
        intent: AddNewCardIntentIntent,
        completion: @escaping (AddNewCardIntentIntentResponse) -> Void) {
        completion(AddNewCardIntentIntentResponse(
            code: .continueInApp,
            userActivity: nil
            )
        )
    }
    
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
}
