//
//  LabelCell.swift
//  Yelp
//
//  Created by Girge on 10/23/16.
//  Copyright © 2016 Girge. All rights reserved.
//

import UIKit

protocol LabelCellDelagate {
    func labelCell(cell: LabelCell)
}

class LabelCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    
    var delegate: LabelCellDelagate!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            delegate.labelCell(cell: self)
        }
    }

}
