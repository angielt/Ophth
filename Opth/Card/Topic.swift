//
//  Topic.swift
//  Opth
//
//  Created by Angie Ta on 3/12/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

import Foundation
internal class Topic{
    var topicCategory:String
    var topicName:String
    var subtopics:[Subtopic]
    var opened:Bool
    var repeat_factor:Int
    
    init(topic:String, category: String){
        self.topicCategory = category
        self.topicName = topic
        self.subtopics = []
        self.opened = false
        self.repeat_factor = 5
    }
}
