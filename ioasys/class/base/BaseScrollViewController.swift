//
//  BaseScrollViewController.swift
//  ioasys
//
//  Created by Junio Moquiuti on 19/01/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import Cartography

class BaseScrollViewController: BaseViewController {
    
    private var scrollViewConstraintGroup = ConstraintGroup()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.alwaysBounceVertical = false
        view.keyboardDismissMode = .onDrag
        return view
    }()
        
    override func loadView() {
        super.loadView()
        
        addScrollView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listenToKeyboard()
    }
    
    private func addScrollView() {
        
        view.addSubview(scrollView)
        updateScrollViewConstraints()
    }
    
    private func updateScrollViewConstraints() {
        
        constrain(view, scrollView, replace: scrollViewConstraintGroup) { (view, scroll) in
            scroll.left == view.left
            scroll.right == view.right
            scroll.top == view.safeAreaLayoutGuide.top
            scroll.bottom == view.safeAreaLayoutGuide.bottom
        }
    }
    
    internal func addChildViewToScrollView(childView: UIView) {
        
        scrollView.addSubview(childView)
        constrain(scrollView, childView) { (scroll, subView) in
            subView.left == scroll.left
            subView.right == scroll.right
            subView.top == scroll.top
            subView.bottom == scroll.bottom
            subView.width == scroll.width
            subView.height == scroll.height
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Keyboard Notifications
extension BaseScrollViewController {
    
    private func listenToKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(sender:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(sender:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        guard let keyboardValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardFrameCG = keyboardValue.cgRectValue
        let keyboarFrame = view.convert(keyboardFrameCG, from: view.window)

        scrollView.contentInset.bottom = keyboarFrame.height - view.safeAreaInsets.bottom + 30
        scrollView.scrollIndicatorInsets = scrollView.contentInset
        scrollView.layoutIfNeeded()
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = scrollView.contentInset
        scrollView.layoutIfNeeded()
    }
}
