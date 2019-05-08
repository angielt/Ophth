//
//  ContentsOfTableViewController.swift
//  Opth
//
//  Created by Itzel Hernandez on 4/1/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

import UIKit
import Foundation

class ContentsOfTableViewController: UITableViewController, UISearchBarDelegate {
    var sectionIndex = 0
    var rowIndex = 0
    
    // search
    @IBOutlet weak var searchBar: UISearchBar!
    var searchActive = false
    var subtopicAr = [Subtopic]()
    var filteredSubtopics: [Subtopic] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parse.csv(data: "/Users/cathyhsieh/Desktop/temp.txt")
        //parse.csv(data:"/Users/cathyhsieh/Documents/GitHub/Opth/Opth/Information/biggerdata.txt")
        
        //setup delegate
        searchBar.delegate = self
        //gets all subtopics into subtopicAr
        for item in status.CategoryList {
            for item2 in item.topics {
                subtopicAr += item2.subtopics.map{$0}
            }
        }
    }
    
    // MARK: search function
    func searchBarTextDidBeginEditing(_searchBar: UISearchBar) {
        searchActive = true
    }
    func searchBarTextDidEndEditing(_searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(_searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredSubtopics = subtopicAr.filter({(subtopics: Subtopic) -> Bool in return subtopics.subtopicName.lowercased().prefix(searchText.count).contains(searchText.lowercased())})
        
        // checks
        if (searchBar.text == "") {
            searchActive = false;
        }
        else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // dispose of any resources that can be recreated
    }
    
    
    // MARK: table of contents
    override func numberOfSections(in tableView: UITableView) -> Int {
        return status.CategoryList.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let categoryCount = status.CategoryList.count
        let topicCount = status.CategoryList[section].topics.count
        
        if (searchActive) {
            return filteredSubtopics.count
        }
        else if status.CategoryList[section].opened == true {
            return topicCount + categoryCount
        }
        else {
            return categoryCount
        }
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let categoryCount = status.CategoryList.count
        
        if searchActive {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                return UITableViewCell()}
            cell.textLabel?.text = filteredSubtopics[indexPath.row].subtopicName
            cell.textLabel?.textColor = UIColor.white
            return cell
        }
        else {
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
        
        //bug here
        spacedRep.setReviewTopic(topic: &(status.CategoryList[sectionIndex].topics[rowIndex]))
    }
}
