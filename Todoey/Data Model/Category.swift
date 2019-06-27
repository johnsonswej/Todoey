//
//  Category.swift
//  Todoey
//
//  Created by Samuel Johnson on 25/06/2019.
//  Copyright © 2019 Samuel Johnson. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name : String = ""
    
    let items = List<Item>()
    
    
}
