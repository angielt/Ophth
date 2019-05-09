//
//  Category.swift
//  Opth
//
//  Created by Angie Ta on 3/12/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

import Foundation
internal class Category{
    var categoryName:String
    var topics:[Topic]
    var opened:Bool

    init(name:String){
        self.categoryName = name
        self.topics = []
        self.opened = false
    }
}
