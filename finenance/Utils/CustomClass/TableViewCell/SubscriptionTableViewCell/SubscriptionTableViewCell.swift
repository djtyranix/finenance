//
//  SubscriptionTableViewCell.swift
//  finenance
//
//  Created by Michael Ricky on 01/10/22.
//

import UIKit

class SubscriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var subsPrice: UILabel!
    @IBOutlet weak var subsTitle: UILabel!
    @IBOutlet weak var subsNextOn: UILabel!
    @IBOutlet weak var subsImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        subsTitle.adjustsFontSizeToFitWidth = false
        subsTitle.lineBreakMode = .byTruncatingTail
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
