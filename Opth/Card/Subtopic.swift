//
//  Subtopics.swift
//  Opth
//
//  Created by Angie Ta on 3/12/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

import Foundation
class Subtopic{ // aka Slide
    var subtopicCategory:String
    var subtopicTopic:String
    var subtopicName:String
    var cards:[Card]
    var img_list:[String]
    var img_caption:[String]
    var score:Int
    var repeat_factor:Int
    var hasNotes: Bool
    // add variables for spaced rep

    init(subtopic: String, topic: String, category: String){
        self.subtopicCategory = category
        self.subtopicTopic = topic
        self.subtopicName = subtopic
        self.cards = []
        self.img_list = []
        self.img_caption = []
        self.score = 20
        self.repeat_factor = 5
        self.hasNotes = false
    }
    
    func updateRepeatFactor(rf:Int){
        self.repeat_factor = rf
    }
    
    // add functions for spaced rep
}
