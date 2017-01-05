//
//  CustomCell.swift
//  ContractTouch
//
//  Created by SDG1 on 10/10/16.
//  Copyright © 2016 GoonanCo. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var nameTxt: UILabel!    
    @IBOutlet weak var resultTxt: UILabel!
    @IBOutlet weak var dateTxt: UILabel!
}
