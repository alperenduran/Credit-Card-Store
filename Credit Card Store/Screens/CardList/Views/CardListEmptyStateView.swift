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
        $0.image = UIImage(named: "emptyState")
        $0.contentMode = .center
        $0.setContentHuggingPriority(
            .required,
            for: .vertical
        )
    }
    
    private lazy var label = with(UILabel()) {
        $0.text = "You don't have any card"
        $0.font = .font(type: .bold, size: 20)
        $0.textColor = .appLabelColor
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }

    private lazy var stackView = vStack(space: 20.0)(imageView, label, UIView())

    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        
        addSubview(stackView)
        let constraints = stackView.alignEdges(
            leading: 15,
            trailing: -15,
            top: 30,
            bottom: -30
        )
        constraints.activate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
