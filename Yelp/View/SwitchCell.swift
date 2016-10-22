//
//  SwitchCell.swift
//  Yelp
//
//  Created by Girge on 10/20/16.
//  Copyright © 2016 Girge. All rights reserved.
//

import UIKit

protocol SwitchCellDelegate {
    func switchCell(_ value: Any, identifier: String)
}

class SwitchCell: UITableViewCell {
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var nameLabel: UILabel!

    var delegate: SwitchCellDelegate!
    var identifier: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    @IBAction func switchChanged(_ sender: UISwitch) {
        delegate.switchCell(sender.isOn, identifier: identifier)
    }
}
