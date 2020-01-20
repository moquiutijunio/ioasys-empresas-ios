//
//  EnterpriseViewModel.swift
//  ioasys
//
//  Created by Junio Moquiuti on 20/01/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import Foundation

final class EnterpriseViewModel: NSObject, EnterpriseViewModelProtocol {
    
    let photo: URL?
    let name: String?
    let country: String?
    let typeName: String?
    
    init(enterprise: Enterprise) {
        self.photo = enterprise.photo
        self.name = enterprise.name
        self.typeName = enterprise.typeName
        self.country = enterprise.country
    }
}
