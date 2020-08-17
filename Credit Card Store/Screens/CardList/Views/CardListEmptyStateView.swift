//
//  CardListEmptyStateView.swift
//  Credit Card Store
//
//  Created by Alperen Duran on 11.08.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

import UIKit

final class CardListEmptyStateView: UIView {
    
    // MARK: - Properties
    private lazy var imageView = with(UIImageView()) {
        $0.image = UIImage(named: "emptyState")?.withTintColor(.paleGray)
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var label = with(UILabel()) {
        $0.text = "You don't have any card"
        $0.font = .font(type: .bold, size: 20)
        $0.textColor = .paleGray
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }

    private lazy var stackView = vStack(space: 30.0)(imageView, label, UIView())

    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        
        addSubview(stackView)
        var constraints = stackView.center(in: self)
        
        imageView.alignSize(width: 150, height: 150)
            .forEach { constraints.append($0) }
        
//        stackView.center(in: self)
//            .forEach { constraints.append($0) }
        
        constraints.activate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
