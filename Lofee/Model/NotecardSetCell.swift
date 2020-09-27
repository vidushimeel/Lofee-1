//
//  NotecardSetCell.swift
//  Design
//
//  Created by 65,115,114,105,116,104,98 on 8/23/20.
//  Copyright © 2020 Asritha Bodepudi. All rights reserved.
//

import UIKit
import RealmSwift

class NotecardSetCell: UITableViewCell, UITableViewDelegate {
   
    @IBOutlet weak var notecardSetNameLabel: UILabel!
    @IBOutlet weak var notecardSetImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
