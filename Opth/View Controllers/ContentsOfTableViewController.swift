//
//  ContentsOfTableViewController.swift
//  Opth
//
//  Created by Itzel Hernandez on 4/1/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

import UIKit
import Foundation

class ContentsOfTableViewController: UITableViewController {
    var sectionIndex = 0
    var rowIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parse.csv(data: "/Users/cathyhsieh/Desktop/temp.txt")
        //parse.csv(data:"/Users/cathyhsieh/Documents/GitHub/Opth/Opth/Information/biggerdata.txt")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return status.CategoryList.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let categoryCount = status.CategoryList.count
        let topicCount = status.CategoryList[section].topics.count
        
        if status.CategoryList[section].opened == true {
            return topicCount + categoryCount
        }
        else {
            return categoryCount
        }
    }
    
    //need to take a look here
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let categoryCount = status.CategoryList.count
        
        //need to fix "indexPath.row == 0"
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                return UITableViewCell()}
            let trimmedCategory = status.CategoryList[indexPath.section].categoryName.replacingOccurrences(of: "\n", with: "")
            cell.textLabel?.text = trimmedCategory
            cell.textLabel?.textColor = UIColor.white
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                return UITableViewCell()}
            
            cell.textLabel?.text = "\t" + status.CategoryList[indexPath.section].topics[indexPath.row - categoryCount].topicName
            cell.textLabel?.textColor = UIColor.white
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        let categoryCount = status.CategoryList.count
        
        //need to fix "indexPath.row == 0"
        if indexPath.row == 0 {
            if status.CategoryList[indexPath.section].opened == true {
                status.CategoryList[indexPath.section].opened = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
            else {
                status.CategoryList[indexPath.section].opened = true
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
        }
        else {
            rowIndex = indexPath.row - categoryCount
            sectionIndex = indexPath.section
            performSegue(withIdentifier: "subCell", sender: self)
        }
    }
    
    //pass in the topic index into SubTableViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "subCell") {
            let subTableView = segue.destination as! SubTableViewController
            subTableView.topic = status.CategoryList[sectionIndex].topics[rowIndex]
            subTableView.topicIndex = rowIndex
        }
    }
}
