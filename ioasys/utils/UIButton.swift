//
//  UIButton.swift
//  ioasys
//
//  Created by Junio Moquiuti on 19/01/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit

enum ButtonAppearance {
    
    case main
}

extension UIButton {
    
    func applyAppearance(appearance: ButtonAppearance, title: String, cornerRadius: CGFloat? = nil) {
     
        setTitle(title, for: .normal)
        
        if let cornerRadius = cornerRadius {
            layer.cornerRadius = cornerRadius
        }
        
        switch appearance {
        case .main:
            setTitleColor(.white, for: .normal)
            backgroundColor = UIColor(named: "greeny_blue")
            titleLabel?.font = .textStyle2
            setBackgroundImage(UIImage.fromColor(color: UIColor(white: 0.88, alpha: 0.46)), for: .disabled)
        }
    }
}
