//
//  ViewState.swift
//  ioasys
//
//  Created by Junio Moquiuti on 19/01/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

enum ViewState {
    
    case normal
    case loading(PlaceholderViewModel)
    case failure(AlertViewModel)
}
