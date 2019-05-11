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
        parse.csv(data: "/Users/Angie/Desktop/test/temp.txt")
        
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
        
        //filteredSubtopics = subtopicAr.filter({(subtopics: Subtopic) -> Bool in return subtopics.subtopicName.lowercased().prefix(searchText.count).contains(searchText.lowercased())})
        filteredSubtopics = subtopicAr.filter({
            (subtopics: Subtopic) -> Bool in return
            subtopics.subtopicName.range(of: searchText, options: .caseInsensitive) != nil
        })
        
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
        if (searchActive) {
            return 1
        }
        else {
            return status.CategoryList.count
        }
    }
    
    // in here is where it goes wrong, everything before in filteredSubtopics array it is correct
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filteredSubtopics.count
        }
        else if status.CategoryList[section].opened == true {
            return status.CategoryList[section].topics.count + 1
        }
        else {
            return 1
        }
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchActive {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                return UITableViewCell()}
            print("filtered: ", filteredSubtopics[indexPath.row].subtopicName)
            cell.textLabel?.text = filteredSubtopics[indexPath.row].subtopicName
            cell.textLabel?.textColor = UIColor.white
            return cell
        }
        else {
            if indexPath.row == 0 {  //Categories
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                    return UITableViewCell()}
                let trimmedCategory = status.CategoryList[indexPath.section].categoryName.replacingOccurrences(of: "\n", with: "")
                cell.textLabel?.text = trimmedCategory
                cell.textLabel?.textColor = UIColor.white
                return cell
            }
            else {  //Topics
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                    return UITableViewCell()}
                
                cell.textLabel?.text = "\t" + status.CategoryList[indexPath.section].topics[indexPath.row - 1].topicName
                cell.textLabel?.textColor = UIColor.white
                return cell
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchActive {
            performSegue(withIdentifier: "fromSearchSegue", sender: self)
        }
        if indexPath.row == 0 {  //Categories
            if status.CategoryList[indexPath.section].opened == true {
                status.CategoryList[indexPath.section].opened = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
            else {  //Open to topics
                status.CategoryList[indexPath.section].opened = true
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
        }
        else {
            rowIndex = indexPath.row - 1
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
        else if(segue.identifier == "fromSearchSegue"){
            let _ = segue.destination as? SearchToCardViewController
        }
        
        //bug here
        spacedRep.setReviewTopic(topic: &(status.CategoryList[sectionIndex].topics[rowIndex]))
    }
}
