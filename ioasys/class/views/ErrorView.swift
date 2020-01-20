//
//  ErrorView.swift
//  ioasys
//
//  Created by Junio Moquiuti on 19/01/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import Cartography

class ErrorView: UIView {
    
    private var actionBlock: (() -> ())?
    
    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.textColor = .white
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemFont(ofSize: 20)
        return textLabel
    }()
    
    private lazy var tryAgainButton: UIButton = {
        let button = UIButton()
        button.applyAppearance(appearance: .main, title: NSLocalizedString("try.again", comment: "").uppercased(), cornerRadius: 6)
        
        _ = button.rx.tap
            .takeUntil(rx.deallocated)
            .bind {[weak self] in
                guard let self = self else { return }
                if let action = self.actionBlock {
                    action()
                }
        }
        
        return button
    }()
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupView() {
        
        backgroundColor = UIColor(white: 0, alpha: 0.85)
        addSubview(textLabel)
        addSubview(tryAgainButton)
        constrain(self, textLabel, tryAgainButton) { (view, label, button) in
            label.center == view.center
            label.right >= view.right - 30
            label.left >= view.left + 30
            
            button.top == label.bottom + 16
            button.left == view.left + 30
            button.right == view.right - 30
            button.height == 44
        }
    }
}

extension ErrorView {
    
    func presentOn(parentView: UIView, with viewModel: PlaceholderViewModel) {
        textLabel.text = viewModel.text
        actionBlock = viewModel.action
        
        parentView.addSubview(self)
        constrain(parentView, self) { (container, loading) in
            loading.edges == container.edges
        }
        
        alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 1
        })
    }
}
