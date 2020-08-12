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
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var label = with(UILabel()) {
        $0.text = "You don't have any card"
        $0.font = .font(type: .black, size: 30)
        $0.textColor = .appLabelColor
        $0.numberOfLines = 0
    }
//
//    private lazy var stackView = vStack(
//        distribution: .fill,
//        alignment: .center
//    )(imageView, label, UIView())
//
    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        
//        addSubview(stackView)
//        var constraints = stackView.alignFitEdges()
        addSubview(imageView)
        addSubview(label)
        [
            imageView.alignTop(to: self),
            imageView.alignLeading(to: self, offset: 15),
            imageView.alignTrailing(to: self, offset: -15),
            label.alignLeading(to: self, offset: 15),
            label.alignTrailing(to: self, offset: -15),
            label.alignTop(to: imageView)
        ].activate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
