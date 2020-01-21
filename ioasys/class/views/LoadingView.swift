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
    
    init(type: LoadingViewType) {
        super.init(frame: .zero)
        setupView(type: type)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupView(type: LoadingViewType) {
        
        switch type {
        case .hud:
            backgroundColor = UIColor(white: 0, alpha: 0.55)
            
            addSubview(hudView)
            addSubview(activityIndicatorView)
            
            constrain(self, hudView, activityIndicatorView) { (view, hudView, indicator) in
                hudView.height == 150
                hudView.width == 150
                
                hudView.center == view.center
                
                indicator.top == hudView.top + 40
                indicator.centerX == hudView.centerX
            }
            
        case .full:
            backgroundColor = UIColor(named: "beige")
            
            addSubview(activityIndicatorView)
            
            constrain(self, activityIndicatorView) { (view, indicator) in
                indicator.center == view.center
            }
        }
    }
    
    private func addTextLabel() {
        self.addSubview(textLabel)
        
        constrain(self, activityIndicatorView, textLabel) { (view, indicator, label) in
            label.top == indicator.bottom + 16
            label.centerX == view.centerX
        }
    }
}

extension LoadingView {
    
    func presentOn(parentView: UIView, with viewModel: PlaceholderViewModel) {
        if let text = viewModel.text {
            addTextLabel()
            textLabel.text = text
        } else {
            textLabel.removeFromSuperview()
        }
        
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
