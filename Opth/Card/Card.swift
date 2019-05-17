//
//  Card.swift
//  Opth
//
//  Created by Angie Ta on 3/12/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

import Foundation
class Card{
    var cardCategory:String
    var cardTopic:String
    var cardSubtopic:String
    var header:String
    var info:String
    
    init(header:String, info:String, category:String, topic:String, subtopic:String){
        self.header = header
        self.info = info
        self.cardCategory = category
        self.cardTopic = topic
        self.cardSubtopic = subtopic
    }
}
