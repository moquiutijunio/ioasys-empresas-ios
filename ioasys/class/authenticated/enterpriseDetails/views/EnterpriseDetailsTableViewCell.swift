//
//  EnterpriseDetailsTableViewCell.swift
//  ioasys
//
//  Created by Junio Moquiuti on 20/01/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import Kingfisher

protocol EnterpriseDetailsViewModelProtocol {
    
    var photo: URL? { get }
    var details: String? { get }
}

final class EnterpriseDetailsTableViewCell: UITableViewCell {
    static let reuseId = "EnterpriseDetailsTableViewCell"
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var detailsLabel: UILabel!
    
    private var viewModel: EnterpriseDetailsViewModelProtocol!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyAppearance()
    }
    
    private func applyAppearance() {
        backgroundColor = .clear
        selectionStyle = .none
    
        detailsLabel.textColor = UIColor(named: "dark_indigo")
        detailsLabel.font = .textStyle5
        detailsLabel.textAlignment = .left
        detailsLabel.numberOfLines = 0
        
        photoImageView.backgroundColor = UIColor(named: "warm_grey")
        photoImageView.contentMode = .scaleAspectFit
    }
    
    func bindIn(viewModel: EnterpriseDetailsViewModelProtocol) {
        
        detailsLabel.text = viewModel.details
        photoImageView.kf.setImage(with: viewModel.photo)
        
        self.viewModel = viewModel
    }
}
