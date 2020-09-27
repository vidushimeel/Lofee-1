//
//  Set.swift
//  Design
//
//  Created by 65,115,114,105,116,104,98 on 8/12/20.
//  Copyright © 2020 Asritha Bodepudi. All rights reserved.
//

import Foundation
import RealmSwift

class Set: Object{
    @objc dynamic var name: String = ""
    @objc dynamic var colorNumber: Int = 0
    let notecards = List<Notecard>()
}
