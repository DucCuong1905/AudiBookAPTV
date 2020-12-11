//
//  ChapterViewCell.swift
//  AudiBookAppTV
//
//  Created by Nguyen Van Tinh on 9/11/20.
//  Copyright © 2020 Nguyen Van Tinh. All rights reserved.
//

import UIKit

class ChapterViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lblpart: UILabel!
    
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
