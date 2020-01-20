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

enum LoadingViewType {
    case hud
    case full
}

struct PlaceholderViewModel {
    
    var text: String?
    var action: (() -> ())?
    var type: LoadingViewType
    var showOnNavigation: Bool
    
    init(text: String? = nil, type: LoadingViewType = .hud, showOnNavigation: Bool = true, action: (() -> ())? = nil) {
        self.text = text
        self.type = type
        self.action = action
        self.showOnNavigation = showOnNavigation
    }
}
