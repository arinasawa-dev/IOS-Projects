//
//  Notebook+Extensions.swift
//  Mooskine
//
//  Created by Arin Asawa on 11/25/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import CoreData

extension Notebook{
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.creationDate = Date()
    }
    
    
}
