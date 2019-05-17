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
    var CategoryList:[Category]
    
    init(){
        self.CategoryList = []
    }

    func addCategory(category:String){
        var matchExists:Bool = false
        for item in CategoryList{
            if(item.categoryName == category){
                matchExists = true
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
                    }
                }
            }
        }
        if(matchExists == false){
            let test = String(category.filter { !" \n\t\r".contains($0) })
            let newTopic = Topic(topic: topic, category: test)
            topicCategory.topics.append(newTopic)
        }
        
    }
    
    func addSubtopic(category:String, topic:String, subtopic: String, img: String?, imgCap: String?){
        var matchExists:Bool = false
        var topicCategory:Category = Category(name: "null")
        var subtopicTopic:Topic = Topic(topic: "null", category: "null")
        for item in CategoryList{
            if(item.categoryName == category){
                topicCategory = item
                for top in item.topics{
                    if(top.topicName == topic){
                        subtopicTopic = top
                        for sub in top.subtopics{
                            if(sub.subtopicName == subtopic){
                                matchExists = true
                                if img != "nil"{
                                    sub.img_list.append(img!)
                                    sub.img_caption.append(imgCap!)
                                }
                            }
                        }
                    }
                }
            }
        }
        
        if(matchExists == false){
            let topic = String(topic.filter { !" \n\t\r".contains($0) })
            let category = String(category.filter { !" \n\t\r".contains($0) })
            let newSubtopic = Subtopic(subtopic: subtopic, topic: topic, category: category)
            for i in img!.components(separatedBy: ","){
                let removedQ = i.replacingOccurrences(of: "\"", with: "")
                let removedW = removedQ.replacingOccurrences(of: " ", with: "")
                newSubtopic.img_list.append(removedW)
                
            }
            for i in imgCap!.components(separatedBy: "*"){
                let removedQ = i.replacingOccurrences(of: "\"", with: "")
                newSubtopic.img_caption.append(removedQ)
            }
            subtopicTopic.subtopics.append(newSubtopic)
        }
        
    }
    
    func addCard(category:String, topic:String, subtopic: String, header:String, info:String){
        var matchExists:Bool = false
        var topicCategory:Category = Category(name: "null")
        var subtopicTopic:Topic = Topic(topic: "null", category: "null")
        var cardSubtopic:Subtopic = Subtopic(subtopic: "null", topic: "null", category: "nill")
        
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
            var information = info
            if(info == "nil"){
                information = ""
            }
            let category = String(category.filter { !"\n\t\r".contains($0) })
            let topic = String(topic.filter { !"\n\t\r".contains($0) })
            let subtopic = String(subtopic.filter { !"\n\t\r".contains($0) })
            let newCard = Card(header: header, info: information, category: category, topic: topic, subtopic: subtopic)
            cardSubtopic.cards.append(newCard)
        }
        
    }
    
    
}

var status = Status()
var parse =  Parse()
