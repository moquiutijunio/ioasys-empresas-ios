//
//  EnterpriseTableViewCell.swift
//  ioasys
//
//  Created by Junio Moquiuti on 20/01/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import UIKit
import Kingfisher

protocol EnterpriseViewModelProtocol {
    
    var photo: URL? { get }
    var name: String? { get }
    var country: String? { get }
    var typeName: String? { get }
}

final class EnterpriseTableViewCell: UITableViewCell {
    static let reuseId = "EnterpriseTableViewCell"
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeNameLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    private var viewModel: EnterpriseViewModelProtocol!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyAppearance()
    }
    
    private func applyAppearance() {
        backgroundColor = .white
        selectionStyle = .none
    
        nameLabel.textColor = UIColor(named: "dark_indigo")
        nameLabel.font = .textStyle9
        nameLabel.textAlignment = .left
        
        typeNameLabel.textColor = UIColor(named: "warm_grey")
        typeNameLabel.font = .textStyle8
        typeNameLabel.textAlignment = .left
        
        countryLabel.textColor = UIColor(named: "warm_grey")
        countryLabel.font = .textStyle8
        countryLabel.textAlignment = .left
        
        photoImageView.backgroundColor = UIColor(named: "warm_grey")
        photoImageView.contentMode = .scaleAspectFit
    }
    
    func bindIn(viewModel: EnterpriseViewModelProtocol) {
        
        nameLabel.text = viewModel.name
        typeNameLabel.text = viewModel.typeName
        countryLabel.text = viewModel.country
        photoImageView.kf.setImage(with: viewModel.photo)
        
        self.viewModel = viewModel
    }
}
