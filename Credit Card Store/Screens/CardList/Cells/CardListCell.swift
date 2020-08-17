//
//  CardListCell.swift
//  Credit Card Store
//
//  Created by Alperen Duran on 8.08.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class CardListCell: UITableViewCell {
    // MARK: - Properties
    private lazy var cardBaseView = with(UIView()) {
        $0.layer.cornerRadius = 30.0
    }
    
    private lazy var maskImage = with(UIImageView()) {
        $0.image = UIImage(named: "mask")?.withTintColor(.black)
        $0.alpha = 0.6
    }
    
    private(set) lazy var cardNumberLabel = with(UILabel()) {
        $0.font = .font(type: .bold, size: 18.0)
        $0.numberOfLines = 1
        $0.textColor = .white
    }
    
    private lazy var expirationDateLabel = with(UILabel()) {
        $0.font = .font(type: .bold, size: 14.0)
        $0.numberOfLines = 1
        $0.textColor = .white
    }
    
    private lazy var cvvLabel = with(UILabel()) {
        $0.font = .font(type: .bold, size: 14.0)
        $0.numberOfLines = 1
        $0.textColor = .white
    }
    
    private lazy var cardholderLabel = with(UILabel()) {
        $0.font = .font(type: .bold, size: 14.0)
        $0.numberOfLines = 1
        $0.textColor = .white
    }
    
    private lazy var cardNameLabel = with(UILabel()) {
        $0.font = .font(type: .bold, size: 14.0)
        $0.numberOfLines = 1
        $0.textColor = .white
    }
    
    private lazy var cardTypeLogo = with(UIImageView()) {
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var detailsStack = hStack(space: 10.0)(
        expirationDateLabel,
        cvvLabel,
        UIView()
    )
    
    private lazy var credentialStack = vStack(space: 25.0)(
        cardNameLabel,
        cardNumberLabel,
        cardholderLabel,
        detailsStack
    )
    
    var bag = DisposeBag()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .appBgColor
        selectionStyle = .none
        
        arrangeViews()
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Reuse
    override func prepareForReuse() {
        bag = DisposeBag()
    }
}

private extension CardListCell {
    private func arrangeViews() {
        cardBaseView.addSubview(maskImage)
        cardBaseView.addSubview(credentialStack)
        cardBaseView.addSubview(cardTypeLogo)
        addSubview(cardBaseView)
        
        layer.masksToBounds = true
        layer.cornerRadius = 30.0
                
        cardBaseView.clipsToBounds = true
        cardBaseView.makeShadow(opacity: 0.6, radius: 3)
        cardBaseView.makeShadow(opacity: 0.4, radius: 5)
        cardBaseView.makeShadow(opacity: 0.2, radius: 7)
        
        var constraints = credentialStack.alignFitEdges(insetedBy: 25.0)
        cardBaseView.alignFitEdges(insetedBy:20.0).forEach{
            constraints.append($0)
        }
                
        [
            cardTypeLogo.alignWidth(100.0),
            cardTypeLogo.alignTrailing(to: cardBaseView, offset: -10.0),
            cardTypeLogo.alignBottom(to: cardBaseView, offset: -10.0),
            maskImage.alignTrailing(to: cardBaseView, offset: 10),
            maskImage.alignTop(to: cardBaseView),
            maskImage.alignBottom(to: cardBaseView)
        ].forEach { constraints.append($0) }
        
        constraints.activate()
    }
}

extension CardListCell {
    var populate: Binder<CardListCellDisplayDatasource> {
        Binder(self) { target, datasource in
            target.cardNameLabel.text = datasource.name
            target.cardNumberLabel.text = datasource.cardNumber
            target.cardholderLabel.text = datasource.cardholder
            target.expirationDateLabel.text = datasource.expirationDate
            target.cvvLabel.text = datasource.cvv
            target.cardBaseView.backgroundColor = datasource.color
        }
    }
}
