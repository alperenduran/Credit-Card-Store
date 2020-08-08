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
        $0.backgroundColor = .systemBackground
        $0.separatorStyle = .none
    }
    
    private(set) lazy var addButton = with(
        UIBarButtonItem(
            barButtonSystemItem: .add,
            target: nil,
            action: nil
        )
    ) { $0.tintColor = .appLabelColor }
    
    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        
        addSubview(tableView)
        tableView.alignFitEdges().activate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
