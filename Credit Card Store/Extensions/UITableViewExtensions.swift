//
//  UITableViewExtensions.swift
//  Credit Card Store
//
//  Created by Alperen Duran on 8.08.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

import UIKit

// MARK: - UITableView deque
extension UITableView {
    func deque<T: ViewIdentifier>(at indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("can not deque cell with identifier \(T.identifier) from tableView \(self)")
        }
        return cell
    }
}
