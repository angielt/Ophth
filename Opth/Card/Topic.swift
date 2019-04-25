//
//  Topic.swift
//  Opth
//
//  Created by Angie Ta on 3/12/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

import Foundation
internal class Topic{
    var topicName:String
    var subtopics:[Subtopic]
    var opened:Bool
    
    init(topic:String){
        self.topicName = topic
        self.subtopics = []
        self.opened = false
    }
}
