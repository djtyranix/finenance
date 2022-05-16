//
//  ExpensesTableViewCell.swift
//  finenance
//
//  Created by Michael Ricky on 28/04/22.
//

import UIKit

class ExpensesTableViewCell: UITableViewCell {

    @IBOutlet weak var expenseImageView: UIImageView!
    @IBOutlet weak var expenseNameLabel: UILabel!
    @IBOutlet weak var expenseAmountLabel: UILabel!
    @IBOutlet weak var expenseCategoryLabel: UILabel!
    @IBOutlet weak var expenseDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        expenseNameLabel.adjustsFontSizeToFitWidth = false
        expenseNameLabel.lineBreakMode = .byTruncatingTail
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
