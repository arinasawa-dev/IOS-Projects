//
//  Note+Extensions.swift
//  Mooskine
//
//  Created by Arin Asawa on 11/25/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import CoreData

extension Note{
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.attributedText = NSAttributedString(string: "New Note")
        self.creationDate = Date()
    }
}

