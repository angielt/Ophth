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
    
    // user clicks topic
    func setReviewTopic(topic:inout Topic){
        self.topic = topic
        self.subtopics = topic.subtopics
        print(topic.topicName)
        
        // first ReviewList
        self.max_list_size = self.subtopics.count
        print("MAX LIST SIZE" + String(self.max_list_size))
        generateReviewList(subtopics: self.subtopics)
        
//        print(curReviewIndex)
//        print(self.reviewList.count)
//        print(self.reviewList[curReviewIndex].subtopicName)
    }
    
    // updates subtopic score based on user input
    func calculateRepeatFactor(score:Int) -> Int{
        let repeatFactor = Double(score/4)
        return Int(round(repeatFactor))
    }
    
    // checks if all the cards eventually are mastered (RF = 1)
    func isReviewFinished() -> Bool{
        self.max_list_size = RFList.five.count+RFList.four.count+RFList.three.count+RFList.two.count
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
    
    func easyPressed(){
        if(curReviewIndex == self.reviewList.count){ // all cards in current list are seen, check if some cards are not mastered
            if(isReviewFinished() == true){
                finished = true
            }
        }
        else{
            if(reviewList[curReviewIndex].score+5 <= max_score){
                reviewList[curReviewIndex].score = reviewList[curReviewIndex].score+5
                reviewList[curReviewIndex].repeat_factor = calculateRepeatFactor(score: reviewList[curReviewIndex].score)
                //print(reviewList[curReviewIndex].repeat_factor)
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
            for _ in 1...Int(round(Double(max_list_size)*(0.50))){ // RF 5
                let pop = RFList.five.popLast()
                if (pop != nil){
                    reviewList.append(pop!)
                }
            }
            for _ in 1...Int(round(Double(max_list_size)*(0.25))){ // RF 4
                let pop = RFList.four.popLast()
                if (pop != nil){
                    reviewList.append(pop!)
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
