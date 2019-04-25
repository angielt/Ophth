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
    var score:Int
    // add variables for spaced rep

    init(subtopic: String){
        self.subtopicName = subtopic
        self.cards = []
        self.img_list = []
        self.score = 0
    }
    
    func addImg(img: String){
        self.img_list.append(img)
    }
    
    // add functions for spaced rep
}
