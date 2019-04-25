//
//  Parse.swift
//  Opth
//
//  Created by Angie Ta on 2/20/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

import Foundation

class Parse{
    
    // NOTES / CONCERNS
    // excel file:
    // if you remove information from excel, then convert it to txt the cells still have information in them
    // that parsing does not handle. however many rows you delete will be "\n\t\t\t\t\t\t\t\t" entries in the parsed string list of rows
    // instead of no entry. If you have 10 rows in excel and you delete 3. The size of the parsed row array will still be 10 instead of 7.
    
    // INFO
    // parse file and store into app data structure
    // to do: make it less hard coded and use header line to index instead
    //        store in database later
    //         IDEALLY: run code to pre store everything into the database, then have app query needed cards from database
    func csv(data: String) -> [String]{
        var parsedData:[String] = []
        do {
            let data = try NSString(contentsOfFile: data,
                                    encoding: String.Encoding.ascii.rawValue)
            let parsedCSV: [String] = data
                .components(separatedBy: "\r")
            
            // loop through rows of file, skip header row
            for row in parsedCSV.dropFirst(){
                var rowSplit: [String] = row.components(separatedBy: "\t")
                rowSplit = rowSplit.filter(){$0 != "nil"}
                rowSplit = rowSplit.filter(){$0 != ""}
                if(rowSplit.count > 5){
                   setData(row: rowSplit)
                }
                //print(rowSplit)
            }
            parsedData = parsedCSV // if successful return this
        } catch {
            print(error);
        }
        return parsedData
    }
    
    func setData(row:[String]){
        let category:String = row[0]
        let topic:String = row[1]
        let subtopic:String = row[2]
        var img:String = ""
        status.addCategory(category: category)
        status.addTopic(category: category, topic: topic)
        
        let ifImg = [".jpg",".png"]
        if(ifImg.contains(where: row[3].contains)){
            img = row[3]
        }
        else{
            img = "no image"
        }
        status.addSubtopic(category: category, topic: topic, subtopic: subtopic, img: img)
        // loop through remaining header/info pairs and store
   
        for i in 4...(row.count-1){
            if((i%2==0) ){
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
