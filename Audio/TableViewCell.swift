//
//  TableViewCell.swift
//  Audio
//
//  Created by User1 on 7/10/17.
//  Copyright © 2017 User1. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var name: UILabel!
    
    
    @IBOutlet weak var StartStop: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
