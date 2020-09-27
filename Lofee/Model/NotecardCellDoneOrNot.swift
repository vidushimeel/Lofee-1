//
//  NotecardCellDoneOrNot.swift
//  Design
//
//  Created by 65,115,114,105,116,104,98 on 8/26/20.
//  Copyright © 2020 Asritha Bodepudi. All rights reserved.
//

import UIKit

class NotecardCellDoneOrNot: UITableViewCell {
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var notecardBackgroundView: UIView!
    @IBOutlet weak var imageIcon: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 1.00, alpha: 1.00)
        notecardBackgroundView.layer.cornerRadius = 18
        
        questionTextView.selectedTextRange = questionTextView.textRange(from: questionTextView.beginningOfDocument, to: questionTextView.beginningOfDocument)
        answerTextView.selectedTextRange = answerTextView.textRange(from: answerTextView.beginningOfDocument, to: answerTextView.beginningOfDocument)
        
    }
    
}
