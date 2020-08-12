//
//  CardListViewController.swift
//  Credit Card Store
//
//  Created by Alperen Duran on 8.08.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class CardListViewController: UIViewController {
    
    // MARK: - Properties
    fileprivate lazy var viewSource = with(CardListView()) {
        $0.tableView.dataSource = self
    }
    
    let bag = DisposeBag()
    let viewModel: CardListViewModel
    fileprivate var datasource: [CardListCellDisplayDatasource] = []
    let (deleteObserver, deleteObservable) = Observable<IndexPath>.pipe()
    
    // MARK: - Initialization
    init(with viewModel: @escaping CardListViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = viewSource
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Cards"
        
        bindViewModelInputs()
    }
}

extension CardListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = datasource[indexPath.row]
        let cell: CardListCell = tableView.deque(at: indexPath)
        cell.populate.onNext(cellData)
        return cell
    }
}


private extension CardListViewController {
    private func bindViewModelInputs() {
        let outputs = viewModel(inputs)
        
        bag.insert(
            outputs.datasource.drive(rx.bindDatasource),
            outputs.openAddScreen.drive(rx.showAddCard),
            outputs.cardDeleted.drive()
        )
    }
    
    private var inputs: CardListViewModelInput {
        CardListViewModelInput(
            cards: Current.keychain.cardsEvent,
            cardNumberTapped: .never(),
            cardSelected: .never(),
            deleteCard: viewSource.tableView.rx.itemDeleted.asObservable(),
            addButtonTapped: viewSource.addButton.rx.tap.asObservable()
        )
    }
}

extension Reactive where Base == CardListViewController {
    var bindDatasource: Binder<[CardListCellDisplayDatasource]> {
        Binder(base) { target, datasource in
            target.viewSource.backgroundView.isHidden = !datasource.isEmpty
            target.datasource = datasource
            target.viewSource.tableView.reloadData()
        }
    }
    
    var addCard: Binder<Void> {
        Binder(base) { target, _ in
            let card = Card(
                name: "My Garanti Card",
                cardNumber: "1234567812345678",
                cardholderName: "Hayrettin Alperen Duran",
                expirationMonth: "11",
                expirationYear: "2020",
                cvv: "123",
                cardType: .visa
            )
            Current.keychain.addCard(card)
        }
    }
}
