//
//  AddCardViewController.swift
//  Credit Card Store
//
//  Created by Alperen Duran on 8.08.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class AddCardViewController: UIViewController {
    
    // MARK: - Properties
    lazy var viewSource = AddCardView()
    let bag = DisposeBag()
    let datasource: AddCardNavigationDatasource
    
    // MARK: - Initialization
    init(with datasource: AddCardNavigationDatasource) {
        self.datasource = datasource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = viewSource
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Add Card"
        
        bindViewModelInputs()
    }
}

private extension AddCardViewController {
    private func bindViewModelInputs() {
        let outputs = datasource.viewModel(inputs)
        
        bag.insert(
            outputs.cardSaved.drive(datasource.closeEvent.observer)
        )
    }
    
    private var inputs: AddCardViewModelInput {
        AddCardViewModelInput(
            cardName: viewSource.cardNameTextField.textField.rx.text.orEmpty.asObservable(),
            cardNumber: viewSource.cardNumberTextField.textField.rx.text.orEmpty.asObservable(),
            cardholderName: viewSource.cardholderTextField.textField.rx.text.orEmpty.asObservable(),
            month: viewSource.expirationMonthTextField.textField.rx.text.orEmpty.asObservable(),
            year: viewSource.expirationYearTextField.textField.rx.text.orEmpty.asObservable(),
            cvv: viewSource.cvvTextField.textField.rx.text.orEmpty.asObservable(),
            cardType: viewSource.selectedCardType,
            saveButtonTapped: viewSource.saveButton.rx.tap.asObservable()
        )
    }
}
