//
//  Status.swift
//  Opth
//
//  Created by Angie Ta on 2/18/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

import Foundation
// handles all interactions with altering the data
// when database is decided, this will handle all interactions with the database
class Status{
    var curReviewIndex:Int
    var ReviewList:[Subtopic] // list of subtopics/slides to for review/spaced rep
    var CategoryList:[Category]
    
    init(){
        self.curReviewIndex = 0
        self.ReviewList = []
        self.CategoryList = []
    }
    
    func setCurReviewIndex(index: Int){
        self.curReviewIndex = index
    }
    
    // to be edited by space rep forumla later
    func calculateReviewList(){
        self.ReviewList = CategoryList[0].topics[0].subtopics;
        //print(self.ReviewList)
    }
    
    
    // these functions are really inefficent but its 3am, will fix later
    func addCategory(category:String){
        var matchExists:Bool = false
        for item in CategoryList{
            if(item.categoryName == category){
                matchExists = true
                //print("category already exists")
            }
        }
        if(matchExists == false){
            let newCategory = Category(name: category)
            self.CategoryList.append(newCategory)
        }
    }
    
    func addTopic(category:String, topic:String){
        var matchExists:Bool = false
        var topicCategory:Category = Category(name: "null")
        for item in CategoryList{
            if(item.categoryName == category){
                topicCategory = item
                for top in item.topics{
                    if(top.topicName == topic){
                        matchExists = true
                       // print("topic already exists")
                    }
                }
            }
        }
        if(matchExists == false){
            let newTopic = Topic(topic: topic)
            topicCategory.topics.append(newTopic)
        }
        
    }
    
    // im sorry this is ugly, will find better way
    func addSubtopic(category:String, topic:String, subtopic: String, img: String?){
        var matchExists:Bool = false
        var topicCategory:Category = Category(name: "null")
        var subtopicTopic:Topic = Topic(topic: "null")
        for item in CategoryList{
            if(item.categoryName == category){
                topicCategory = item
                for top in item.topics{
                    if(top.topicName == topic){
                        subtopicTopic = top
                        for sub in top.subtopics{
                            if(sub.subtopicName == subtopic){
                                matchExists = true
                               // print("subtopic already exists")
                            }
                        }
                    }
                }
            }
        }
        if(matchExists == false){
            let newSubtopic = Subtopic(subtopic: subtopic)
            if(img != nil){
                newSubtopic.addImg(img: img!)
            }
            subtopicTopic.subtopics.append(newSubtopic)
        }
        
    }
    
    // IM SORRY THIS IS SO DISGUSTINGLY UGLY
    func addCard(category:String, topic:String, subtopic: String, header:String, info:String){
        var matchExists:Bool = false
        var topicCategory:Category = Category(name: "null")
        var subtopicTopic:Topic = Topic(topic: "null")
        var cardSubtopic:Subtopic = Subtopic(subtopic: "null")
        
        for item in CategoryList{
            if(item.categoryName == category){
                topicCategory = item
                for top in item.topics{
                    if(top.topicName == topic){
                        subtopicTopic = top
                        for sub in top.subtopics{
                            if(sub.subtopicName == subtopic){
                                cardSubtopic = sub
                                for c in sub.cards{
                                    if(c.header == header){
                                        matchExists = true
                                        //print("card already exists")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        if(matchExists == false && header != "nil"){
            let newCard = Card(header: header, info: info)
            cardSubtopic.cards.append(newCard)
        }
        
    }
    
    func addImg(img: String, subtopic: Subtopic){
        subtopic.img_list.append(img)
    }
    
//    func printContents(){
//        for category in CategoryList{
//            print(category.categoryName)
//            for topic in category.topics{
//              //  print("\t" + topic.topicName)
//                for subtopic in topic.subtopics{
//                  //  print("\t\t" + subtopic.subtopicName)
//                    for card in subtopic.cards{
//                       // print("\t\t\t Header: " + card.header)
//                       // print("\t\t\t Info: " + card.info)
//                    }
//                }
//            }
//        }
//    }
    
    
}

var status = Status()
var parse =  Parse()
