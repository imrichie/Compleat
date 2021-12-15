//
//  CustomCell.swift
//  TheList
//
//  Created by Richie Flores on 11/27/21.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
  @IBOutlet weak var photo: UIImageView!
  @IBOutlet weak var label: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
