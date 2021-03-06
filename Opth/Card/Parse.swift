//
//  Parse.swift
//  Opth
//
//  Created by Angie Ta on 2/20/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

import Foundation

class Parse{
    
    // Called in ContentsofTableViewController
    // handles special characters for formatting and strange excel -> txt behavior
    // passes each row in excel file to setData
    func csv(data: String) -> [String]{
        var parsedData:[String] = []
        do {
            let data = try NSString(contentsOfFile: data,
                                    encoding: String.Encoding.utf16.rawValue)
            let parsedCSV: [String] = data
                .components(separatedBy: "\r")
            
            // loop through rows of file, skip header row
            for row in parsedCSV.dropFirst(){
                var newRow = row.replacingOccurrences(of: "Õ", with: "'", options: .literal, range: nil)
                newRow = newRow.replacingOccurrences(of: "\"\"", with: "", options: .literal, range: nil)
                newRow = newRow.replacingOccurrences(of: "##", with: "      ◦", options: .literal, range: nil)
                newRow = newRow.replacingOccurrences(of: "Ó", with: "\"", options: .literal, range: nil)
                newRow = newRow.replacingOccurrences(of: "Ò", with: "\"", options: .literal, range: nil)
                newRow = newRow.replacingOccurrences(of: "Ô", with: "", options: .literal, range: nil)
                newRow = newRow.replacingOccurrences(of: "\"", with: "", options: .literal, range: nil)
                newRow = newRow.replacingOccurrences(of: "#", with: "•", options: .literal, range: nil)
                newRow = newRow.replacingOccurrences(of: "Ð", with: "-", options: .literal, range: nil)
                newRow = newRow.replacingOccurrences(of: "-->", with: "→", options: .literal, range: nil)
                
                
                //print(newRow)
                var rowSplit: [String] = newRow.components(separatedBy: "\t")
                rowSplit = rowSplit.filter(){$0 != ""}
                if(rowSplit.count > 6){
                   setData(row: rowSplit)
                }
            }
            parsedData = parsedCSV // if successful return this
        } catch {
            print(error);
        }
        return parsedData
    }
    
    
    // Seperates columns of each row and stores the data in status instance
    func setData(row:[String]){
        let slide_number:String = row[0]
        let category:String = row[1]
        let topic:String = row[2]
        let subtopic:String = row[3]
        let img:String = row[4]
        let imgCap:String = row[5]
        
        status.addCategory(category: category)
        status.addTopic(category: category, topic: topic)
        
        status.addSubtopic(category: category, topic: topic, subtopic: subtopic, img: img, imgCap: imgCap)
        
        // loop through remaining header/info pairs and store
        for i in 6...(row.count-1){
            if((i%2 == 0) ){
                if((i+1) <= (row.count-1)){ // has subtext
                    status.addCard(category: category, topic: topic, subtopic: subtopic, header: row[i], info: row[i+1])
                }
                else{
                    status.addCard(category: category, topic: topic, subtopic: subtopic, header: row[i], info: "")
                }
            }
        }
        
    }

    
}
