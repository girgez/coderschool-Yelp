//
//  ExtendCell.swift
//  Yelp
//
//  Created by Girge on 10/22/16.
//  Copyright © 2016 Girge. All rights reserved.
//

import UIKit

@objc protocol ExtendCellDelegate {
    func extendCell(cell: ExtendCell)
}

class ExtendCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!

    weak var delegate: ExtendCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            delegate.extendCell(cell: self)
        }
        // Configure the view for the selected state
    }
    
    
}
