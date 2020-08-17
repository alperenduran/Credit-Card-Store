//
//  CardListViewModel.swift
//  Credit Card Store
//
//  Created by Alperen Duran on 8.08.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

import RxSwift
import RxCocoa
import Foundation

struct CardListViewModelInput {
    var cards: Observable<[Card]> = .never()
    var cardSelected: Observable<IndexPath> = .never()
    var deleteCard: Observable<IndexPath> = .never()
    var addButtonTapped: Observable<Void> = .never()
}

struct CardListViewModelOutput {
    let datasource: Driver<[CardListCellDisplayDatasource]>
    let copyCardNumber: Driver<String>
    let cardDeleted: Driver<Void>
    let openAddScreen: Driver<Void>
}

typealias CardListViewModel = (CardListViewModelInput) -> CardListViewModelOutput

func cardListViewModel(
    _ inputs: CardListViewModelInput
) -> CardListViewModelOutput {
    return CardListViewModelOutput(
        datasource: getDatasourceOutput(inputs),
        copyCardNumber: getCopyCardOutput(inputs),
        cardDeleted: getCardDeleted(inputs),
        openAddScreen: getOpenAddScreenOutput(inputs)
    )
}

private func getDatasourceOutput(
    _ inputs: CardListViewModelInput
) -> Driver<[CardListCellDisplayDatasource]> {
    inputs.cards
        .map(convertToDatasource)
        .asDriver(onErrorDriveWith: .never())
}

private func getCopyCardOutput(
    _ inputs: CardListViewModelInput
) -> Driver<String> {
    inputs.cardSelected
        .withLatestFrom(inputs.cards) { ($0, $1)}
        .map { indexPath, cards -> String in
            let index = indexPath.row
            let card = cards[index]
            return card.cardNumber
        }
        .asDriver(onErrorDriveWith: .never())
}

private func getCardDeleted(
    _ inputs: CardListViewModelInput
) -> Driver<Void> {
    inputs.deleteCard
        .map { $0.row }
        .map(Current.keychain.removeCard)
        .asDriver(onErrorDriveWith: .never())
}

private func getOpenAddScreenOutput(
    _ inputs: CardListViewModelInput
) -> Driver<Void> {
    inputs.addButtonTapped
        .asDriver(onErrorDriveWith: .never())
}

private func convertToDatasource(
    _ cards: [Card]
) -> [CardListCellDisplayDatasource] {
    cards
        .map { card -> CardListCellDisplayDatasource in
            let formattedCardNumber = card.cardNumber.replacingOccurrences(
                of: "(\\d{4})(\\d{4})(\\d{4})(\\d{4})",
                with: "$1 $2 $3 $4",
                options: .regularExpression,
                range: nil
            )
            let expirationDate = "\(card.expirationMonth)/\(card.expirationYear)"
            
            return CardListCellDisplayDatasource(
                name: card.name,
                cardNumber: card.secureCardNumber,
                cardholder: card.cardholderName,
                expirationDate: expirationDate,
                cvv: card.cvv
        )
    }
}
