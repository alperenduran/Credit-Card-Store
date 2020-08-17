//
//  AuthorizeView.swift
//  Credit Card Store
//
//  Created by Alperen Duran on 17.08.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

import UIKit

final class AuthorizeView: UIView {
    
    // MARK: - Properties
    private lazy var binaryImage = with(UIImageView()) {
        $0.image = UIImage(named: "binary")
        $0.contentMode = .scaleAspectFit
    }
    
    private(set) lazy var openSafeButton = with(UIButton(type: .custom)) {
        $0.setTitle("Open Safe", for: .normal)
        $0.backgroundColor = .appBlackColor
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .font(type: .bold, size: 14.0)
        $0.layer.cornerRadius = 15
    }
    
    private lazy var stackView = vStack(alignment: .center, space: 30)(
        UIView(),
        binaryImage,
        openSafeButton,
        UIView()
    )
    
    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        
        addSubview(stackView)
        
        var constraints = stackView.alignFitEdges()
        
        [
            openSafeButton.alignHeight(55),
            openSafeButton.alignLeading(to: stackView, offset: 45),
            openSafeButton.alignTrailing(to: stackView, offset: -45)
        ].forEach { constraints.append($0) }
        
        constraints.activate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
