//
//  Subtopics.swift
//  Opth
//
//  Created by Angie Ta on 3/12/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

import Foundation
class Subtopic{ // aka Slide
    var subtopicName:String
    var cards:[Card]
    var img_list:[String]
    var img_caption:[String]
    var score:Int
    var repeat_factor:Int
    // add variables for spaced rep

    init(subtopic: String){
        self.subtopicName = subtopic
        self.cards = []
        self.img_list = []
        self.img_caption = []
        self.score = 20
        self.repeat_factor = 5
    }
    
    func addImg(img: String){
        self.img_list.append(img)
    }
    
    func addCaption(imgCap: String){
        self.img_caption.append(imgCap)
    }
    
    func updateRepeatFactor(rf:Int){
        self.repeat_factor = rf
    }
    
    // add functions for spaced rep
}
