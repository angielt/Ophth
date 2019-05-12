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
    
    var subtopicIndex = 0
    var headerIndex = 0
    var infoIndex = 0
    
    // search
    @IBOutlet weak var searchBar: UISearchBar!
    var searchActive = false
    var subtopicAr = [Subtopic]()
    var headerInfoAr = [Card]()
    var topicAr = [Topic]()
    var filteredInfo: [Card] = []
    var filteredHeaders: [Card] = []
    var filteredSubtopics: [Subtopic] = []
    var filteredTopics: [Topic] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let filepath = Bundle.main.path(forResource: "temp", ofType: "txt") {
                parse.csv(data: filepath)
        } else {
            print("data file could not be found")
        }
        //setup delegate
        searchBar.delegate = self
        
        for item in status.CategoryList {
            topicAr += item.topics.map{$0} // puts all topics in topicAr
            for item2 in item.topics {
                subtopicAr += item2.subtopics.map{$0} //puts all subtopics in subtopicAr
                for item3 in item2.subtopics {
                    headerInfoAr += item3.cards.map{$0} // gets all headers and info into array
                }
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
        
        filteredTopics = topicAr.filter({
            (topics: Topic) -> Bool in return
            topics.topicName.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        filteredSubtopics = subtopicAr.filter({
            (subtopics: Subtopic) -> Bool in return
            subtopics.subtopicName.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        filteredHeaders = headerInfoAr.filter({
            (cards: Card) -> Bool in return
            cards.header.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        filteredInfo = headerInfoAr.filter({
            (cards: Card) -> Bool in return
            cards.info.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        subtopicIndex = 0
        headerIndex = 0
        infoIndex = 0
        
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
        if (searchActive){
            return 1
        } else {
            return status.CategoryList.count
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchActive) {
            let counter = filteredTopics.count + filteredSubtopics.count + filteredHeaders.count + filteredInfo.count
            return counter
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
                return UITableViewCell(style: UITableViewCell.CellStyle.subtitle,
                                       reuseIdentifier: "cell")}
            
            // gets the topics
            if indexPath.row < filteredTopics.count{
                cell.textLabel?.text = filteredTopics[indexPath.row].topicName
                cell.detailTextLabel?.text = "Category: "
            }
                // gets the subtopics
            else if subtopicIndex < filteredSubtopics.count{
                cell.textLabel?.text = filteredSubtopics[subtopicIndex].subtopicName
                cell.detailTextLabel?.text = "Category: , Topic: "
                subtopicIndex += 1
            }
                // gets the headers
            else if headerIndex < filteredHeaders.count{
                cell.textLabel?.text = filteredHeaders[headerIndex].header
                cell.detailTextLabel?.text = "Category: , Topic: , Subtopic: "
                headerIndex += 1
            }
                // gets the info
            else if infoIndex < filteredInfo.count{
                cell.textLabel?.text = filteredInfo[infoIndex].info
                cell.detailTextLabel?.text = "Category: , Topic: , Subtopic: , Header: "
                infoIndex += 1
            }
            
            cell.textLabel?.textColor = UIColor.white
            cell.detailTextLabel?.textColor = UIColor.cyan
            return cell
        }
        else {
            if indexPath.row == 0 {  //Categories
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                    return UITableViewCell()}
                let trimmedCategory = status.CategoryList[indexPath.section].categoryName.replacingOccurrences(of: "\n", with: "")
                cell.textLabel?.text = trimmedCategory
                cell.detailTextLabel?.text = ""
                cell.textLabel?.textColor = UIColor.white
                return cell
            }
            else {  //Topics
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                    return UITableViewCell()}
                
                cell.textLabel?.text = "\t" + status.CategoryList[indexPath.section].topics[indexPath.row - 1].topicName
                cell.textLabel?.textColor = UIColor.white
                cell.detailTextLabel?.text = ""
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
        print("segue")
        if(segue.identifier == "subCell") {
            let subTableView = segue.destination as! SubTableViewController
            subTableView.topic = status.CategoryList[sectionIndex].topics[rowIndex]
            subTableView.topicIndex = rowIndex
        }
        else if(segue.identifier == "fromSearchSegue"){
            let _ = segue.destination as? SearchToCardViewController
        }
        
        spacedRep.setReviewTopic(topic: &(status.CategoryList[sectionIndex].topics[rowIndex]))
    }
}
