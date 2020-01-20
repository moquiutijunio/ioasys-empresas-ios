//
//  AlertViewModel.swift
//  ioasys
//
//  Created by Junio Moquiuti on 19/01/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit

struct AlertViewModel {
    
    var title: String?
    var message: String?
    var alertActions: [AlertActionViewModel]
    var preferredStyle: UIAlertController.Style
    
    init(title: String? = nil, message: String? = nil, preferredStyle: UIAlertController.Style = .alert, actions: [AlertActionViewModel] = []) {
        self.title = title
        self.message = message
        self.preferredStyle = preferredStyle
        self.alertActions = actions
    }
}

struct AlertActionViewModel {
    
    var title: String
    var actionType: UIAlertAction.Style
    var action: (() -> ())?
    
    init(title: String, actionType: UIAlertAction.Style = .`default`, action: (() -> ())? = nil) {
        self.title = title
        self.actionType = actionType
        self.action = action
    }
    
    func transform() -> UIAlertAction {
        return UIAlertAction(title: title, style: actionType, handler: { (_) in
            if let action = self.action {
                action()
            }
        })
    }
}
