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
        $0.font = .font(type: .bold, size: 15.0)
        $0.textColor = .black
    }
    
    lazy var container = with(UIView()) {
        $0.backgroundColor = .paleGray
        $0.layer.cornerRadius = 20.0
        $0.addSubview(textField)
    }
    
    lazy var label = with(UILabel()) {
        $0.font = .font(type: .bold, size: 13.0)
        $0.textColor = .lightGreyBlue
    }
    
    lazy var stackView = vStack(space: 7.0)(label, container)
    
    var bag: DisposeBag
    
    init(
        maxCharacters: Int,
        name: String
    ) {
        bag = DisposeBag()
        
        super.init(frame: .zero)
        
        label.text = name
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
        addSubview(stackView)
        
        var constraints = stackView.alignFitEdges()
        [
            container.alignHeight(55.0),
            label.alignLeading(to: container)
        ].forEach { constraints.append($0) }
        
        textField.alignFitEdges(insetedBy: 16.0)
            .forEach { constraints.append($0) }
        constraints.activate()
    }
}
