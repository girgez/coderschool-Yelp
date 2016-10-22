//
//  CheckCell.swift
//  Yelp
//
//  Created by Girge on 10/20/16.
//  Copyright © 2016 Girge. All rights reserved.
//

import UIKit

@objc protocol CheckCellDelegate {
    func checkCell(cell: CheckCell)
}

class CheckCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkView: UIImageView!
    
    weak var delegate: CheckCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            delegate.checkCell(cell: self)
        }
    }
}
