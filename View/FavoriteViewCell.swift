//
//  FavoriteViewCell.swift
//  AudiBookAppTV
//
//  Created by Nguyen Van Tinh on 9/11/20.
//  Copyright © 2020 Nguyen Van Tinh. All rights reserved.
//

import UIKit

class FavoriteViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblAuthor: UILabel!
    
    @IBOutlet weak var lblBookTitle: UILabel!
    @IBOutlet weak var imgBook: UIImageView!
    @IBOutlet weak var imgStar: UIImageView!
    @IBOutlet weak var lblLike: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
