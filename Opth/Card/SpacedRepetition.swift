//
//  SpacedRepetition.swift
//  Opth
//
//  Created by Angie Ta on 4/24/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

// EF':=EF+(0.1-(5-q)*(0.08+(5-q)*0.02))   q=0-5 response in our case 0-2
// generate set of cards ex.20
// review same 20 cards until all of them are easy
// by this i mean keep showing the same cards if the use responds hard or unsure
// must all be good (?)like Anki before completed screen shows

// ReviewList consists of 50% -RF5, 25% -RF4, 12.5%- RF3.. etc
import Foundation

// stores a list of subtopics based on review factor
class RepeatFactorList{
    var one:[Subtopic]
    var two:[Subtopic]
    var three:[Subtopic]
    var four:[Subtopic]
    var five:[Subtopic]
    
    init(){
        self.one = []
        self.two = []
        self.three = []
        self.four = []
        self.five = []
    }
}

class SpacedRepetition {
    var VCreference: ViewController?
    let max_score = 20;
    let min_score = 0;
    var max_list_size = 0;
    var curReviewIndex:Int
    var subtopics:[Subtopic]
    var topic:Topic
    var RFList:RepeatFactorList
    var reviewList:[Subtopic]
    var finished:Bool = false // review completed
    
    
    init(){
        self.curReviewIndex = 0
        self.subtopics = []
        self.topic = Topic(topic:"")
        self.RFList = RepeatFactorList()
        self.reviewList = []
        
    }
    
    func clear(){
        self.curReviewIndex = 0
        self.subtopics = []
        self.topic = Topic(topic:"")
        self.RFList = RepeatFactorList()
        self.reviewList = []
        RFList.one = []
        RFList.two = []
        RFList.three = []
        RFList.four = []
        RFList.five = []
    }
    
    // called ContentsOfTableVC when user clicks topic
    // stores topic object in SpacedRepetition class
    func setReviewTopic(topic:inout Topic){
        self.topic = topic
        self.subtopics = topic.subtopics
        print(topic.topicName)
        
        // first ReviewList
        self.max_list_size = self.subtopics.count
        print("MAX LIST SIZE" + String(self.max_list_size))
        generateReviewList(subtopics: self.subtopics)
        
    }
    
    // calculates repeat factor based on score
    // needs more work
    func calculateRepeatFactor(score:Int) -> Int{
        let repeatFactor = Double(score/4)
        return Int(round(repeatFactor))
    }
    
    // checks if all the cards eventually are mastered (RF = 1)
    // if mastered, clear the contents of SpacedRepetition class
    // if not mastered (some slides RF is not = 1), generate a new ReviewList
    func isReviewFinished() -> Bool{
        
        var size = self.reviewList.filter{$0.repeat_factor != 1}
        self.max_list_size = size.count
        print(max_list_size)
        for item in reviewList{
            print(item.subtopicName)
            print(item.repeat_factor)
        }
        
        if(self.max_list_size > 0)
        {
            generateReviewList(subtopics: self.subtopics)
            return false // stay on topic
        }
        else{
            clear()
            return true // leave topic
        }
    }
    
    // updates the slide's score and repeat factor if user pressed EASY
    // when review is finished, chnage the exit card.
    func easyPressed(){
        print("curReview index in easy button " + String(curReviewIndex-1))
        if(curReviewIndex-1 == self.reviewList.count-1){ // all cards in current list are seen, check if some cards are not mastered
            if(isReviewFinished() == true){
                finished = true
                
            }
        }
        if(curReviewIndex < self.reviewList.count){
            if(reviewList[curReviewIndex-1].score+5 <= max_score){
                reviewList[curReviewIndex-1].score = reviewList[curReviewIndex-1].score+5
                //print(reviewList[curReviewIndex].repeat_factor)
            }
            reviewList[curReviewIndex-1].repeat_factor = 1
        }
        else if (finished == true){
            // change card
            if(VCreference != nil){
               VCreference?.exitCardChange()
            }
        }
    }
    
    func unsurePressed(){
        if(curReviewIndex == self.reviewList.count){ // all cards in current list are seen, check if some cards are not mastered
            if(isReviewFinished() == true){
                finished = true
            }
        }
        else{
            if(reviewList[curReviewIndex].score-1 >= min_score){
                reviewList[curReviewIndex].score = reviewList[curReviewIndex].score-1
                reviewList[curReviewIndex].repeat_factor = calculateRepeatFactor(score: reviewList[curReviewIndex].score)
            }
        }
    }
    
    func hardPressed(){
        if(curReviewIndex == self.reviewList.count){ // all cards in current list are seen, check if some cards are not mastered
            if(isReviewFinished() == true){
                finished = true
            }
        }
        else{
            if(reviewList[curReviewIndex].score-5 >= min_score){
                reviewList[curReviewIndex].score = reviewList[curReviewIndex].score-5
                reviewList[curReviewIndex].repeat_factor = calculateRepeatFactor(score: reviewList[curReviewIndex].score)
            }
        }
    }
    
    // generate Review Factor List from subtopic review factors
    func generateReviewList(subtopics:[Subtopic]){
        let st = subtopics
        
        // sort subtopics by repeat factors
        let five = st.filter{$0.repeat_factor==5}
        let four = st.filter{$0.repeat_factor==4}
        let three = st.filter{$0.repeat_factor==3}
        let two = st.filter{$0.repeat_factor==2}
        let one = st.filter{$0.repeat_factor==1}
        
//        print(RFList.five.count)
//        print(RFList.four.count)
//        print(RFList.three.count)
//        print(RFList.two.count)
//        print(RFList.one.count)
        
        // store
        RFList.five = five
        RFList.four = four
        RFList.three = three
        RFList.two = two
        RFList.one = one
        
        // reset ReviewList
        if(reviewList.count != 0){
            reviewList = []
        }
        // generate list
        if(topic.opened == false){
            for _ in 1...Int(round(Double(max_list_size))){ // RF 5
                let pop = RFList.five.popLast()
                if (pop != nil){
                    reviewList.append(pop!)
                }
            }
            topic.opened = true
            print(self.reviewList)
        }
        else{
            if(RFList.three.count > 0){
                var max = Int(round(Double(max_list_size)*(0.50)))
                if(max < 1){
                    max = 1
                }
                for _ in 1...max{ // RF 4
                    let pop = RFList.five.popLast()
                    if (pop != nil){
                        reviewList.append(pop!)
                    }
                }
            }
            if(RFList.three.count > 0){
                var max = Int(round(Double(max_list_size)*(0.25)))
                if(max < 1){
                    max = 1
                }
                for _ in 1...max{ // RF 4
                    let pop = RFList.four.popLast()
                    if (pop != nil){
                        reviewList.append(pop!)
                    }
                }
            }
            if(RFList.three.count > 0){
                var max = Int(round(Double(max_list_size)*(0.125)))
                if(max < 1){
                    max = 1
                }
                for _ in 1...max{ // RF 4
                    let pop = RFList.three.popLast()
                    if (pop != nil){
                        reviewList.append(pop!)
                    }
                }
            }
            else if(RFList.two.count > 0){
                var max = Int(round(Double(max_list_size)*(0.125)))
                if(max < 1){
                    max = 1
                }
                for _ in 1...max{ // RF 4
                    let pop = RFList.two.popLast()
                    if (pop != nil){
                        reviewList.append(pop!)
                    }
                }
            }
            else if(RFList.one.count > 0){
                var max = Int(round(Double(max_list_size)*(0.125)))
                if(max < 1){
                    max = 1
                }
                for _ in 1...max{ // RF 4
                    let pop = RFList.one.popLast()
                    if (pop != nil){
                        reviewList.append(pop!)
                    }
                }
            }
            print(self.reviewList)
        }
    }
}
var spacedRep = SpacedRepetition()
