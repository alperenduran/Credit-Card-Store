//
//  AddCardViewModel.swift
//  Credit Card Store
//
//  Created by Alperen Duran on 8.08.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

import RxSwift
import RxCocoa
import Foundation
import Intents

struct AddCardViewModelInput {
    var cardName: Observable<String> = .never()
    var cardNumber: Observable<String> = .never()
    var cardholderName: Observable<String> = .never()
    var month: Observable<String> = .never()
    var year: Observable<String> = .never()
    var cvv: Observable<String> = .never()
    var saveButtonTapped: Observable<Void> = .never()
}

struct AddCardViewModelOutput {
    let cardSaved: Driver<Void>
    let error: Driver<ErrorObject>
}

typealias AddCardViewModel = (AddCardViewModelInput) -> AddCardViewModelOutput

func addCardViewModel(
    _ inputs: AddCardViewModelInput
) -> AddCardViewModelOutput {
    
    let cardInputs = Observable
        .combineLatest(
            inputs.cardName.startWith(""),
            inputs.cardNumber.startWith(""),
            inputs.cardholderName.startWith(""),
            inputs.month.startWith(""),
            inputs.year.startWith(""),
            inputs.cvv.startWith("")
        )
        .map(createCard)
    
    let validationResult = inputs.saveButtonTapped
        .withLatestFrom(cardInputs)
        .flatMapLatest { validate($0).materialize() }
    
    let validationSuccess = validationResult
        .elements()
    
    let validationError = validationResult
        .errors()
        .asDriver(onErrorDriveWith: .never())
    
    return AddCardViewModelOutput(
        cardSaved: getCardSavedOutput(inputs, validationSuccess),
        error: combineErrors(validationError)
    )
}

private func getCardSavedOutput(
    _ inputs: AddCardViewModelInput,
    _ validatedCard: Observable<Card>
) -> Driver<Void> {
    validatedCard
        .map(Current.keychain.addCard)
        .asDriver(onErrorDriveWith: .never())
}

private func createCard(
    name: String,
    number: String,
    holder: String,
    month: String,
    year: String,
    cvv: String
) -> Card {
    let card = Card(
        name: name,
        cardNumber: number,
        cardholderName: holder,
        expirationMonth: month,
        expirationYear: year,
        cvv: cvv
    )
    let interaction = INInteraction(intent: card.intent, response: nil)
    interaction.identifier = "Add New Card"
    
    interaction.donate { (error) in
        if let error = error {
            print("fail olduk alposh")
        }
    }
    
    return card
}

// MARK: - Validation
/// Validates all required input fields to make api call.
private func validate(
    _ card: Card
) -> Observable<Card> {
    let cardName = validateField(
        value: card.name,
        errorMessage: "Card name should not be empty."
    )
    let cardNumber = validateField(
        value: card.cardNumber,
        errorMessage: "Card number should not be empty."
    )
    let cardholder = validateField(
        value: card.cardholderName,
        errorMessage: "Cardholder should not be empty."
    )
    let month = validateField(
        value: card.expirationMonth,
        errorMessage: "Expiration month should not be empty."
    )
    let year = validateField(
        value: card.expirationYear,
        errorMessage: "Expiration year should not be empty."
    )
    let cvv = validateField(
        value: card.cvv,
        errorMessage: "CVV should not be empty."
    )
    
    
    let inputs = [
        cardName,
        cardNumber,
        cardholder,
        month,
        year,
        cvv
    ]
    
    return Observable.combineLatest(inputs)
        .map { $0.reduce(true, { $0 && $1 }) }
        .filter { $0 }
        .map { _ in card }
}

/// Validates given string is valid for the given test.
private func validateField(
    value: String,
    errorMessage: String,
    test: @escaping (String) -> Bool = Validations.isNotEmpty
) -> Observable<Bool> {
    Observable.just(value)
        .map(Validator.validate(
                errorMessage: errorMessage,
                test: test
            )
        )
        .map { _ in true }
}

func x() {
    Observable.just(123)
        
}
