//
//  TableViewCell.swift
//  ProyekUTS
//
//  Created by Kelvin Sidharta Sie on 04/10/23.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var logoKurir: UIImageView!
    @IBOutlet weak var namaLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var estimasiLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
