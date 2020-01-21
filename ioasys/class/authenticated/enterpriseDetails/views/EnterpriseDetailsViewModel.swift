//
//  EnterpriseDetailsViewModel.swift
//  ioasys
//
//  Created by Junio Moquiuti on 20/01/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import Foundation

final class EnterpriseDetailsViewModel: NSObject, EnterpriseDetailsViewModelProtocol {
    
    let photo: URL?
    let details: String?
    
    init(enterprise: Enterprise) {
        self.photo = enterprise.photo
        self.details = enterprise.description
    }
}
