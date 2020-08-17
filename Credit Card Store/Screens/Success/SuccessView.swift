//
//  SuccessView.swift
//  Credit Card Store
//
//  Created by Alperen Duran on 17.08.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

import UIKit

final class SuccessView: UIView {
    
    // MARK: - Properties
    private lazy var successImageView = with(UIImageView()) {
        $0.image = UIImage(named: "success")
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var label = with(UILabel()) {
        $0.text = "Card Added"
        $0.font = .font(type: .bold, size: 13)
    }
    
    private(set) lazy var button = with(UIButton(type: .custom)) {
        $0.setTitle("Return to Wallet", for: .normal)
        $0.backgroundColor = .lightishBlue
        $0.titleLabel?.font = .font(type: .extraBold, size: 14)
        $0.layer.cornerRadius = 15
    }
    
    private lazy var stackView = vStack(alignment: .center, space: 20)(
        UIView(),
        successImageView,
        label,
        button,
        UIView()
    )
    
    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        
        addSubview(stackView)
        backgroundColor = .white
        
        var constraints = stackView.center(in: self)
        
        [
            button.alignHeight(55),
            button.alignHeight(55),
            button.alignWidth(UIScreen.main.bounds.width - 90)
        ].forEach { constraints.append($0) }
        
        constraints.activate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
