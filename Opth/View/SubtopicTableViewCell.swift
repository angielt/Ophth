//
//  SubtopicTableViewCell.swift
//  Opth
//
//  Created by Angie Ta on 4/2/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

import UIKit

class SubtopicTableViewCell: UITableViewCell {
    
    @IBOutlet weak var Header: UILabel!
    @IBOutlet weak var Info: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
