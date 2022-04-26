//
//  ExpenseTableViewCell.swift
//  finenance
//
//  Created by Michael Ricky on 26/04/22.
//

import UIKit

class ExpenseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var expenseImageView: UIImageView!
    @IBOutlet weak var expenseNameLabel: UILabel!
    @IBOutlet weak var expenseAmountLabel: UILabel!
    @IBOutlet weak var expenseCategoryLabel: UILabel!
    @IBOutlet weak var expenseDateLabel: UILabel!
    @IBOutlet weak var categoryOuter: CategoryLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}