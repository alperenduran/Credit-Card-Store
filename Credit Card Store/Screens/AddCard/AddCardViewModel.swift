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

struct AddCardViewModelInput {
    var cardName: Observable<String> = .never()
    var cardNumber: Observable<String> = .never()
    var cardholderName: Observable<String> = .never()
    var month: Observable<String> = .never()
    var year: Observable<String> = .never()
    var cvv: Observable<String> = .never()
    var cardType: Observable<CardType> = .never()
    var saveButtonTapped: Observable<Void> = .never()
}

struct AddCardViewModelOutput {
    let cardSaved: Driver<Void>
    let error: Driver<Error>
}

typealias AddCardViewModel = (AddCardViewModelInput) -> AddCardViewModelOutput

func addCardViewModel(
    _ inputs: AddCardViewModelInput
) -> AddCardViewModelOutput {
    return AddCardViewModelOutput(
        cardSaved: getCardSavedOutput(inputs),
        error: .never()
    )
}

private func getCardSavedOutput(
    _ inputs: AddCardViewModelInput
) -> Driver<Void> {
    let cardInputs = Observable
        .combineLatest(
            inputs.cardName.filter { !$0.isEmpty },
            inputs.cardNumber.filter { !$0.isEmpty },
            inputs.cardholderName.filter { !$0.isEmpty },
            inputs.month.filter { !$0.isEmpty },
            inputs.year.filter { !$0.isEmpty },
            inputs.cvv.filter { !$0.isEmpty },
            inputs.cardType
        )
    
    return inputs.saveButtonTapped
        .withLatestFrom(cardInputs)
        .map(createCard)
        .map(Current.keychain.addCard)
        .asDriver(onErrorDriveWith: .never())
}

private func createCard(
    name: String,
    number: String,
    holder: String,
    month: String,
    year: String,
    cvv: String,
    type: CardType
) -> Card {
    Card(
        name: name,
        cardNumber: number,
        cardholderName: holder,
        expirationMonth: month,
        expirationYear: year,
        cvv: cvv,
        cardType: type
    )
}
