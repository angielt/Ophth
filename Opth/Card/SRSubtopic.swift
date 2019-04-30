//
//  ReviewList.swift
//  Opth
//
//  Created by Angie Ta on 4/28/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

import Foundation
class SRSubtopic{
    var name:String
    var repeat_factor:Int
    var score:Int

    init(n:String, rf:Int){
        self.name = n
        self.repeat_factor = rf
        self.score = 0
    }
    
    func updateRF(rf:Int){
        self.repeat_factor = rf
    }
    
    func updateScore(s:Int){
        self.score = s
    }
    
    func getRF() -> Int{
        return self.repeat_factor
    }
    
    func getScore() -> Int{
        return self.score
    }
    
    
}
