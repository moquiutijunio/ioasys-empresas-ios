//
//  LoadingView.swift
//  ioasys
//
//  Created by Junio Moquiuti on 19/01/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import Cartography

class LoadingView: UIView {
    
    private lazy var hudView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .black
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.font = .textStyleRegular(size: 18)
        textLabel.textColor = .black
        textLabel.numberOfLines = 0
        return textLabel
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupView() {
        
        backgroundColor = UIColor(white: 0, alpha: 0.55)
        
        addSubview(hudView)
        addSubview(textLabel)
        addSubview(activityIndicatorView)
        
        constrain(self, hudView, textLabel, activityIndicatorView) { (view, hudView, label, indicator) in
            hudView.height == 150
            hudView.width == 150
            hudView.center == view.center
            
            label.top == indicator.bottom + 16
            label.centerX == view.centerX
            
            indicator.top == hudView.top + 40
            indicator.centerX == hudView.centerX
        }
    }
}

extension LoadingView {
    
    func presentOn(parentView: UIView, with viewModel: PlaceholderViewModel) {
    
        textLabel.text = viewModel.text
        
        parentView.addSubview(self)
        constrain(parentView, self) { (container, loading) in
            loading.edges == container.edges
        }
        
        self.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1
        }
    }
}
