//
//  BookCollectionView.swift
//  AudiBookAppTV
//
//  Created by Nguyen Van Tinh on 9/10/20.
//  Copyright © 2020 Nguyen Van Tinh. All rights reserved.
//

import UIKit

class BookCollectionView: UICollectionViewCell {
    
    @IBOutlet weak var lblStar: UIImageView!
    
    @IBOutlet weak var lblLike: UILabel!
    
    @IBOutlet weak var lblBookTitle: UILabel!
    @IBOutlet weak var imgBook: UIImageView!
    @IBOutlet weak var lblAuthor: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.autoresizingMask.insert(.flexibleHeight)
        self.contentView.autoresizingMask.insert(.flexibleWidth)
        // Initialization code
       
    }
}
