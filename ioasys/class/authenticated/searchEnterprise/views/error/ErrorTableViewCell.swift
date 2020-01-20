//
//  ErrorTableViewCell.swift
//  ioasys
//
//  Created by Junio Moquiuti on 20/01/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit

final class ErrorTableViewCell: UITableViewCell {
    static let reuseId = "ErrorTableViewCell"
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       applyAppearance()
    }
    
    private func applyAppearance() {
        backgroundColor = .clear
        selectionStyle = .none
               
        errorLabel.font = .textStyle8
        errorLabel.textColor = .black
        errorLabel.numberOfLines = 0
    }
    
    func bindIn(error: String) {
        errorLabel.text = error
    }
}
