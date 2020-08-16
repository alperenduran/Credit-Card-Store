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
    private(set) lazy var cardNameTextField = with(TextField(maxCharacters: 20, name: "Card Name")) {
        $0.textField.autocorrectionType = .no
        $0.textField.autocapitalizationType = .none
    }
    
    private(set) lazy var cardSkeletonView = with(UIView()) {
        $0.backgroundColor = .appBlueColor
        $0.layer.cornerRadius = 30.0
    }
    
    private(set) lazy var cardNumberTextField = with(TextField(maxCharacters: 16, name: "Card Number")) {
        $0.textField.keyboardType = .numberPad
        $0.textField.autocorrectionType = .no
        $0.textField.autocapitalizationType = .none
    }
    
    private(set) lazy var cardholderTextField = with(TextField(maxCharacters: 40, name: "Cardholder's Name")) {
        $0.textField.autocorrectionType = .no
        $0.textField.autocapitalizationType = .none
    }
    
    private(set) lazy var expirationMonthTextField = with(TextField(maxCharacters: 2, name: "Month")) {
        $0.textField.placeholder = "MM"
        $0.textField.keyboardType = .numberPad
        $0.textField.autocorrectionType = .no
        $0.textField.autocapitalizationType = .none
    }
    
    private(set) lazy var expirationYearTextField = with(TextField(maxCharacters: 2, name: "Year")) {
        $0.textField.placeholder = "YY"
        $0.textField.keyboardType = .numberPad
        $0.textField.autocorrectionType = .no
        $0.textField.autocapitalizationType = .none
    }
    
    private(set) lazy var cvvTextField = with(TextField(maxCharacters: 3, name: "CVV")) {
        $0.textField.placeholder = "CVV"
        $0.textField.keyboardType = .numberPad
        $0.textField.autocorrectionType = .no
        $0.textField.autocapitalizationType = .none
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
        $0.backgroundColor = .lightishBlue
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .font(type: .bold, size: 14.0)
        $0.layer.cornerRadius = 15
    }
    
    private lazy var baseStackView = vStack(space: 13.0)(
        cardNameTextField,
        cardSkeletonView,
        cardNumberTextField,
        cardholderTextField,
        detailsStackView,
        saveButton,
        UIView()
    )
    
    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .systemBackground
        addSubview(baseStackView)
        var constraints = baseStackView.alignFitEdges(insetedBy: 25)
        [
            saveButton.alignHeight(55),
            cardSkeletonView.alignHeight(193.0),
            cardSkeletonView.alighWidth(200.0)
        ].forEach { constraints.append($0) }
        
        
        constraints.activate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
