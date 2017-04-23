//
//  ProductTableViewCell.swift
//  ComprasUSA
//
//  Created by Ricardo Tourinho on 16/04/17.
//  Copyright © 2017 Ricardo Tourinho. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    
    @IBOutlet weak var ivPicture: UIImageView!
    
    @IBOutlet weak var lbProduct: UILabel!
    
    @IBOutlet weak var lbState: UILabel!
    
    @IBOutlet weak var lbPrice: UILabel!
    
    @IBOutlet weak var lbCreditCard: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
