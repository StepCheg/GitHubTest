//
//  CommitCell.swift
//  GitTest
//
//  Created by Stepan Chegrenev on 11/12/2018.
//  Copyright © 2018 Stepan Chegrenev. All rights reserved.
//

import UIKit

class CommitCell: UITableViewCell {

    @IBOutlet weak var authorLsbel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var shaLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
