//
//  RequestResponse.swift
//  ioasys
//
//  Created by Junio Moquiuti on 20/01/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

enum RequestResponse<T> {
    
    case new
    case loading
    case success(T)
    case failure(String)
}
