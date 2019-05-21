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
// TO DO:
// - add maureen's equation to spaced rep
// - check if rf values actually stored
// - work on spaced rep for all subtopics
// - debug occlusion
// -make buttons show up only if occusion is finished
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
    // main/topics spaced repetition
    var VCreference: ViewController?
    let max_score = 20;
    let min_score = 0;
    var max_list_size = 0;
    var curReviewIndex:Int
    var subtopics:[Subtopic]
    var topic:Topic?
    var RFList:RepeatFactorList
    var reviewList:[Subtopic] // list space rep cycles through
    var finished:Bool = false // review completed
    
    // all topics spaced repetition
    var all_subtopics:[Subtopic]
    var all_active:Bool = false
    var all_curReviewIndex = 0
    
    init(){
        self.curReviewIndex = 0
        self.subtopics = []
        self.RFList = RepeatFactorList()
        self.reviewList = []
        self.topic = nil
        self.all_subtopics = []
        
    }
    
    func clear(){
        self.curReviewIndex = 0
        self.subtopics = []
        self.RFList = RepeatFactorList()
        self.reviewList = []
        RFList.one = []
        RFList.two = []
        RFList.three = []
        RFList.four = []
        RFList.five = []
        self.topic = nil
    }
    
    // For spaced repetition with specific topic clicked from table of contents
    // called ContentsOfTableVC when user clicks topic
    // stores topic object in SpacedRepetition class
    func setReviewTopic(topic:inout Topic){
        print("Review Topic")
        print(topic.topicName)
        print(topic.subtopics.count)
        self.topic = topic
        self.subtopics = topic.subtopics
        //print(topic.topicName)
        
        // first ReviewList
        self.max_list_size = self.subtopics.count
        //print("MAX LIST SIZE" + String(self.max_list_size))
        generateReviewList(subtopics: self.subtopics)
        
    }
    
    
    // For mass subtopics spaced repetition (all subtopics)
    // called when tab switch
    func setReviewTopics(category_list:inout [Category]){
        var flattenedArray = category_list.flatMap { category in
            return category.topics.map { topics in
                return topics.subtopics.map {
                    subtopics in
                    return subtopics
                }
            }
        }
        
        self.all_subtopics = flattenedArray.flatMap({$0})
        self.reviewList = self.all_subtopics.shuffled()
        print("review list set")
    }
    
    // calculates repeat factor based on score, implemented last for ease of debugging for now
    //    func calculateRepeatFactor(new_score:Double, difficulty: Int, old_rf:Int) -> Int{
    //        //let add = 0.7(5.0-0.5(new_score)) + 0.3(0.2(11(difficulty)^2-20(difficulty)+11)-5)
    ////        let repeat_factor = add + old_rf
    ////        return repeat_factor
    //    }
    
    // checks if all the cards eventually are mastered (RF = 1)
    // if mastered, clear the contents of SpacedRepetition class
    // if not mastered (some slides RF is not = 1), generate a new ReviewList
    func isReviewFinished() -> Bool{
        
        var size = self.reviewList.filter{$0.repeat_factor != 1}
        self.max_list_size = size.count

        
        if(self.max_list_size > 0)
        {
            generateReviewList(subtopics: self.subtopics) // generate new list

            self.curReviewIndex = 0 // reset count
            if(VCreference != nil){
                VCreference?.newListCardChange()
            }
            
            return false // stay on topic
        }
        else{
            return true // leave topic
        }
    }
    
    // updates the slide's score and repeat factor if user pressed EASY
    // when review is finished, chnage the exit card.
    // plz dont cahnge anything in this function logically
    func easyPressed(){
        if(curReviewIndex-1 <= self.reviewList.count-1){
            if(reviewList[curReviewIndex-1].score+5 <= max_score){
                reviewList[curReviewIndex-1].score = reviewList[curReviewIndex-1].score+5
                //print(reviewList[curReviewIndex].repeat_factor)
            }
            reviewList[curReviewIndex-1].repeat_factor = 1
            //            reviewList[curReviewIndex-1].repeat_factor = calculateRepeatFactor(new_score: reviewList[curReviewIndex-1].score, difficulty: 2, old_rf: reviewList[curReviewIndex-1].repeat_factor)
            
        }
        if(curReviewIndex-1 == self.reviewList.count-1){ // all cards in current list are seen, check if some cards are not mastered
            if(isReviewFinished() == true){
                finished = true
                if(VCreference != nil){
                    VCreference?.exitCardChange()
                    clear()
                }
            }
        }
    }
    
    func unsurePressed(){
        if(curReviewIndex-1 <= self.reviewList.count-1){
            if(reviewList[curReviewIndex-1].score+5 <= max_score){
                reviewList[curReviewIndex-1].score = reviewList[curReviewIndex-1].score+5
                //print(reviewList[curReviewIndex].repeat_factor)
            }
            reviewList[curReviewIndex-1].repeat_factor = 3
            //            reviewList[curReviewIndex-1].repeat_factor = calculateRepeatFactor(new_score: reviewList[curReviewIndex-1].score, difficulty: 2, old_rf: reviewList[curReviewIndex-1].repeat_factor)
            
        }
        if(curReviewIndex-1 == self.reviewList.count-1){ // all cards in current list are seen, check if some cards are not mastered
            if(isReviewFinished() == true){
                finished = true
                if(VCreference != nil){
                    VCreference?.exitCardChange()
                    clear()
                }
            }
        }
        
    }
    
    func hardPressed(){
        if(curReviewIndex-1 <= self.reviewList.count-1){
            if(reviewList[curReviewIndex-1].score+5 <= max_score){
                reviewList[curReviewIndex-1].score = reviewList[curReviewIndex-1].score+5
                //print(reviewList[curReviewIndex].repeat_factor)
            }
            reviewList[curReviewIndex-1].repeat_factor = 5
            //            reviewList[curReviewIndex-1].repeat_factor = calculateRepeatFactor(new_score: reviewList[curReviewIndex-1].score, difficulty: 2, old_rf: reviewList[curReviewIndex-1].repeat_factor)
            
        }
        if(curReviewIndex-1 == self.reviewList.count-1){ // all cards in current list are seen, check if some cards are not mastered
            if(isReviewFinished() == true){
                finished = true
                if(VCreference != nil){
                    VCreference?.exitCardChange()
                    clear()
                }
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
        // generate initial list
        if(topic?.opened == false){
            for _ in 1...Int(round(Double(max_list_size))){ // RF 5
                let pop = RFList.five.popLast()
                if (pop != nil){
                    reviewList.append(pop!)
                }
            }
            topic?.opened = true
            print(self.reviewList)
        }
        else{
            if(RFList.five.count > 0){
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
            if(RFList.four.count > 0){
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
                for _ in 1...max{ // RF 3
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
                for _ in 1...max{ // RF 2
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
                for _ in 1...max{ // RF 1
                    let pop = RFList.one.popLast()
                    if (pop != nil){
                        reviewList.append(pop!)
                    }
                }
            }
            //print(self.reviewList)
        }
    }
}
var spacedRep = SpacedRepetition()
