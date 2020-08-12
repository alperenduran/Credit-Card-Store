//
//  AddCardView.swift
//  Credit Card Store
//
//  Created by Alperen Duran on 8.08.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

import UIKit
import RxSwift

final class AddCardView: UIView {
    
    // MARK: - Properties
    private(set) lazy var cardNameTextField = with(TextField(maxCharacters: 20)) {
        $0.textField.placeholder = "Give a name to your card"
        $0.textField.autocorrectionType = .no
        $0.textField.autocapitalizationType = .none
    }
    
    private(set) lazy var cardNumberTextField = with(TextField(maxCharacters: 16)) {
        $0.textField.placeholder = "Card number"
        $0.textField.keyboardType = .numberPad
        $0.textField.autocorrectionType = .no
        $0.textField.autocapitalizationType = .none
    }
    
    private(set) lazy var cardholderTextField = with(TextField(maxCharacters: 40)) {
        $0.textField.placeholder = "Cardholder's name"
        $0.textField.autocorrectionType = .no
        $0.textField.autocapitalizationType = .none
    }
    
    private(set) lazy var expirationMonthTextField = with(TextField(maxCharacters: 2)) {
        $0.textField.placeholder = "MM"
        $0.textField.keyboardType = .numberPad
        $0.textField.autocorrectionType = .no
        $0.textField.autocapitalizationType = .none
    }
    
    private(set) lazy var expirationYearTextField = with(TextField(maxCharacters: 2)) {
        $0.textField.placeholder = "YY"
        $0.textField.keyboardType = .numberPad
        $0.textField.autocorrectionType = .no
        $0.textField.autocapitalizationType = .none
    }
    
    private(set) lazy var cvvTextField = with(TextField(maxCharacters: 3)) {
        $0.textField.placeholder = "CVV"
        $0.textField.keyboardType = .numberPad
        $0.textField.autocorrectionType = .no
        $0.textField.autocapitalizationType = .none
    }
    
    private(set) lazy var cardTypePicker = with(UISegmentedControl()) { picker in
        let cardTypes = [
            "Other",
            "Visa",
            "Master",
            "Maestro",
            "Amex"
        ]
        cardTypes.forEach {
            picker.insertSegment(
                withTitle: $0,
                at: 0,
                animated: false
            )
        }
        picker.tintColor = .appLabelColor
        picker.backgroundColor = .appLabelColor
        picker.selectedSegmentTintColor = .appBgColor
        let titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.font(type: .bold, size: 12)
        ]
        picker.setTitleTextAttributes(titleTextAttributes, for: .normal)
        picker.setTitleTextAttributes(titleTextAttributes, for: .selected)
        
        picker.selectedSegmentIndex = 0
    }
    
    private lazy var detailsStackView = hStack(
        distribution: .fillEqually,
        space: 5
        )(
        expirationMonthTextField,
        expirationYearTextField,
        cvvTextField
    )
    
    private(set) lazy var saveButton = with(UIButton(type: .custom)) {
        $0.setTitle("Save", for: .normal)
        $0.backgroundColor = .appBgColor
        $0.setTitleColor(.appLabelColor, for: .normal)
        $0.titleLabel?.font = .font(type: .bold, size: 22)
        [
            $0.alignHeight(50)
        ].activate()
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.appLabelColor.cgColor
        $0.layer.cornerRadius = 10
    }
    
    private lazy var baseStackView = vStack(space: 5.0)(
        cardNameTextField,
        cardNumberTextField,
        cardholderTextField,
        detailsStackView,
        cardTypePicker,
        saveButton,
        UIView()
    )
    
    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .systemBackground
        addSubview(baseStackView)
        baseStackView.alignFitEdges(insetedBy: 10).activate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var selectedCardType: Observable<CardType> {
        let types: [CardType] = [
            .amex,
            .maestro,
            .masterCard,
            .visa,
            .other
        ]
        
        let index = cardTypePicker.rx.selectedSegmentIndex.asObservable()
        
        return index
            .map { index -> CardType in
                types[index]
        }
    }
}
