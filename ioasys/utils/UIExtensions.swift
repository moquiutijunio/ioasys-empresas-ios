//
//  UIExtensions.swift
//  ioasys
//
//  Created by Junio Moquiuti on 19/01/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit

// MARK: - UITextField
extension UITextField {
    
    func addToolBar(title: String) {
        let doneButton = UIBarButtonItem(title: title, style: .plain, target: nil, action: #selector(dimissKeyboard))
        doneButton.tintColor = self.traitCollection.userInterfaceStyle == .dark ? .white: .black
        
        let toolBar = UIToolbar(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: CGFloat(44))))
        toolBar.sizeToFit()
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.inputAccessoryView = toolBar
    }
    
    @objc func dimissKeyboard() {
        self.resignFirstResponder()
    }
}

// MARK: - String
extension String {
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}

// MARK: - UIImage
extension UIImage {
    
    static func fromColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return img
    }
    
    func imageWithColor(color1: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color1.setFill()

        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)

        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}

// MARK: - UIViewController
extension UIViewController {
    
    func removeDefinitely() {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}

// MARK: - UIApplication
extension UIApplication {
    
    var currentViewController: UIViewController? {
        connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first?.rootViewController
    }
}
