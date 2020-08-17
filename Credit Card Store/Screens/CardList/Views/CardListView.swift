//
//  CardListView.swift
//  Credit Card Store
//
//  Created by Alperen Duran on 8.08.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

import UIKit

final class CardListView: UIView {
    
    // MARK: - Properties
    private(set) lazy var tableView = with(UITableView()) {
        $0.register(CardListCell.self, forCellReuseIdentifier: CardListCell.identifier)
        $0.backgroundColor = .appBgColor
        $0.separatorStyle = .none
    }
    
    private(set) lazy var backgroundView = CardListEmptyStateView()
    
    private(set) lazy var addButton = with(UIButton(type: .custom)) {
        $0.setBackgroundImage(UIImage(named: "addButton"), for: .normal)
    }
    
    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        
        addSubview(backgroundView)
        addSubview(tableView)
        addSubview(addButton)
        
        var constraints = tableView.alignFitEdges()
        addButton.alignSize(width: 45, height: 45)
            .forEach { constraints.append($0) }

        backgroundView.alignFitEdges()
            .forEach { constraints.append($0) }
        
        [
            addButton.centerX(in: self),
            addButton.alignBottom(to: self, offset: -UIApplication.safeAreaBottomInset + -15)
        ].forEach { constraints.append($0) }
        constraints.activate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
