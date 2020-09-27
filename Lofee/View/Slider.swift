//
//  Slider.swift
//  Design
//
//  Created by 65,115,114,105,116,104,98 on 8/23/20.
//  Copyright © 2020 Asritha Bodepudi. All rights reserved.
//

import UIKit

//customize slider appearnace
class Slider: UISlider {
var thumbTextLabel: UILabel = UILabel()

private var thumbFrame: CGRect {
    return thumbRect(forBounds: bounds, trackRect: trackRect(forBounds: bounds), value: value)
}

override func layoutSubviews() {
    super.layoutSubviews()

    thumbTextLabel.frame = thumbFrame
    thumbTextLabel.text = String(Int(value))
    thumbTextLabel.textAlignment = .center
    thumbTextLabel.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Heavy", size: 15), size: 15)
    thumbTextLabel.textColor =  #colorLiteral(red: 0.04131617397, green: 0.1428282261, blue: 0.4267548025, alpha: 1)
    
}

override func awakeFromNib() {
    super.awakeFromNib()
    addSubview(thumbTextLabel)
    thumbTextLabel.textAlignment = .center
    thumbTextLabel.layer.zPosition = layer.zPosition + 1
}
}
