//
//  PlaceholderViewModel.swift
//  ioasys
//
//  Created by Junio Moquiuti on 19/01/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit

enum PlaceholderType {
    case loading
    case error
}

struct PlaceholderViewModel {
    
    var text: String
    var action: (() -> ())?
    
    init(text: String, action: (() -> ())? = nil) {
        self.text = text
        self.action = action
    }
}
