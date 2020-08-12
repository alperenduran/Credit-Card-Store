//
//  UITextFieldExtensions.swift
//  Credit Card Store
//
//  Created by Alperen Duran on 8.08.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

import UIKit
import RxSwift

final class TextField: UIView {
    
    lazy var textField = with(UITextField()) {
        $0.font = .font(type: .bold, size: 14.0)
        $0.textColor = .appLabelColor
    }
    var bag: DisposeBag
    
    init(maxCharacters: Int) {
        bag = DisposeBag()
        
        super.init(frame: .zero)
        
        observeTextField(for: maxCharacters)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func observeTextField(for maxCharCount: Int) {
        textField.rx.text.orEmpty
            .filter { $0.count > maxCharCount }
            .map { String($0.prefix(maxCharCount)) }
            .bind(to: textField.rx.text)
            .disposed(by: bag)
    }
    
    private func setup() {
        addSubview(textField)
        textField.alignFitEdges(insetedBy: 10.0).activate()
        layer.borderWidth = 2
        layer.borderColor = UIColor.appBgColor.cgColor
        layer.cornerRadius = 5
    }
}
