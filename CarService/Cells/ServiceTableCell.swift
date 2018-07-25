//
//  ServiceTableCell.swift
//  CarService
//
//  Created by Максим Белугин on 24.07.2018.
//  Copyright © 2018 Максим Белугин. All rights reserved.
//

import UIKit

class ServiceTableCell: UITableViewCell {

    var delegate: ServiceTableCellDelegate?
    var selfIndex: Int!
    
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var price: UILabel!
    
    @IBAction func infoAction(_ sender: Any) {
        delegate?.openPopupWithIndex(selfIndex)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
