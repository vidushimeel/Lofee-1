//
//  Notecard.swift
//  Design
//
//  Created by 65,115,114,105,116,104,98 on 8/12/20.
//  Copyright © 2020 Asritha Bodepudi. All rights reserved.
//
import Foundation
import RealmSwift

class Notecard: Object{
    @objc dynamic var question: String = ""
    @objc dynamic var answer: String = ""
    @objc dynamic var timesGotItRight: Int = 0
    @objc dynamic var dateCreated: Date?

    var parentCategory = LinkingObjects(fromType: Set.self, property: "notecards")
}

