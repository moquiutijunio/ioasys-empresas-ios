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
    
    private let loadingConstraintGroup = ConstraintGroup()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .black
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.font = .textStyle3
        textLabel.textColor = .black
        textLabel.numberOfLines = 0
        return textLabel
    }()
    
    init(type: LoadingViewType) {
        super.init(frame: .zero)
        createScreen(type: type)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func createScreen(type: LoadingViewType) {
        
        switch type {
        case .hud:
            backgroundColor = UIColor(white: 0, alpha: 0.55)
            
            let hudView = UIView()
            hudView.layer.cornerRadius = 15
            hudView.backgroundColor = .white
            
            addSubview(hudView)
            addSubview(activityIndicatorView)
            
            constrain(self, hudView, activityIndicatorView, replace: loadingConstraintGroup) { (view, hudView, indicator) in
                hudView.height == 150
                hudView.width == 150
                
                hudView.center == view.center
                
                indicator.top == hudView.top + 40
                indicator.centerX == hudView.centerX
            }
            
        case .full:
            backgroundColor = UIColor(named: "beige")
            
            addSubview(activityIndicatorView)
            
            constrain(self, activityIndicatorView, replace: loadingConstraintGroup) { (view, indicator) in
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
