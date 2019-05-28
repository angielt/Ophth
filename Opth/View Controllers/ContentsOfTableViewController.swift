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
    
    var tapTopic = false
    
    var fTopic: Topic!
    var fSubtopic: Subtopic!
    
    
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
        
        self.tabBarController?.tabBar.isHidden = false
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor.darkGray
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        //navigationBarAppearace.barTintColor = UIColor.black
        if let filepath = Bundle.main.path(forResource: "temp", ofType: "txt") {
                parse.csv(data: filepath)
        } else {
            print("data file could not be found")
        }
        
        //setup delegate
        searchBar.delegate = self
        
        //status.CategoryList.sort(by: {$0.categoryName < $1.categoryName })
        
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
    
    // get rid of keyboard if not searching
    func dismissKeyboard() {
        if searchActive == false {
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
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
        
        func loadData() {
            // code to load data from network, and refresh the interface
            tableView.reloadData()
        }
        
        // checks
        if (searchBar.text == "") {
            searchActive = false
            dismissKeyboard()
            loadData()
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
        if searchActive{
            return 1
        }
        else {
            return status.CategoryList.count
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //status.CategoryList[section].topics.sort(by: { $0.topicName < $1.topicName })
        
        if searchActive{
            return filteredTopics.count + filteredSubtopics.count + filteredHeaders.count + filteredInfo.count
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
                let category = filteredTopics[indexPath.row].topicCategory
                cell.textLabel?.text = filteredTopics[indexPath.row].topicName
                cell.detailTextLabel?.text = "\(category)"
            }
            // gets the subtopics
            else if indexPath.row - filteredTopics.count < filteredSubtopics.count{
                let index = indexPath.row - filteredTopics.count
                let category = filteredSubtopics[index].subtopicCategory
                let topic = filteredSubtopics[index].subtopicTopic
                cell.textLabel?.text = filteredSubtopics[index].subtopicName
                cell.detailTextLabel?.text = "\(category) > \(topic)"
                
            }
            // gets the headers
            else if indexPath.row - filteredTopics.count - filteredSubtopics.count < filteredHeaders.count{
                let index = indexPath.row - filteredTopics.count - filteredSubtopics.count
                let category = filteredHeaders[index].cardCategory
                let topic = filteredHeaders[index].cardTopic
                let subtopic = filteredHeaders[index].cardSubtopic
                cell.textLabel?.text = filteredHeaders[index].header
                cell.detailTextLabel?.text = "\(category) > \(topic) > \(subtopic)"
                
            }
            // gets the info
            else if indexPath.row - filteredTopics.count - filteredSubtopics.count - filteredHeaders.count < filteredInfo.count{
                let index = indexPath.row - filteredTopics.count - filteredSubtopics.count - filteredHeaders.count
                let category = filteredInfo[index].cardCategory
                let topic = filteredInfo[index].cardTopic
                let subtopic = filteredInfo[index].cardSubtopic
                cell.textLabel?.text = filteredInfo[index].info
                cell.detailTextLabel?.text = "\(category) > \(topic) > \(subtopic)"
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
        if searchActive{
            let totalCount = filteredTopics.count + filteredSubtopics.count + filteredHeaders.count + filteredInfo.count
            var t = filteredTopics.count
            var s = filteredSubtopics.count
            var h = filteredHeaders.count
            var i = filteredInfo.count
            
            // loop through the search contents to see rather the cell is a topic, subtopic, header, or info
            for k in 0..<totalCount{
                if k == indexPath.row{
                    break
                }
                else{t -= 1}        // decrement the topic index
                if t < 0 {s -= 1}   // if topic is < 0, the decrement the subtopic index
                if s < 0 {h -= 1}   // if subtpic is < 0, the decrement the header index
                if h < 0 {i -= 1}   // if header is < 0, the decrement the info index
            }
            
            if t > 0{
                tapTopic = true
                fTopic = filteredTopics[indexPath.row]
                performSegue(withIdentifier: "subCell", sender: self)
            }
            else if s > 0{
                for k in 0..<filteredSubtopics.count + 1{
                    if k == indexPath.row - filteredTopics.count{
                        fSubtopic = filteredSubtopics[k]
                        performSegue(withIdentifier: "fromSearchSegue", sender: self)
                    }
                }
            }
            else if h > 0{
                for k in 0..<filteredHeaders.count + 1{
                    if k == indexPath.row - filteredTopics.count - filteredSubtopics.count{
                        for i in subtopicAr{
                            for j in i.cards{
                                if filteredHeaders[k].header == j.header {
                                    if i.img_list[0] != "nil"{
                                        fSubtopic = i
                                        performSegue(withIdentifier: "headerImageSegue", sender: self)
                                    }
                                    else{
                                        fSubtopic = i
                                        performSegue(withIdentifier: "headerSegue", sender: self)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else if i > 0{
                for k in 0..<filteredInfo.count + 1{
                    if k == indexPath.row - filteredTopics.count - filteredSubtopics.count - filteredHeaders.count{
                        for i in subtopicAr{
                            for j in i.cards{
                                if filteredInfo[k].info == j.info {
                                    if i.img_list[0] != "nil"{
                                        fSubtopic = i
                                        performSegue(withIdentifier: "headerImageSegue", sender: self)
                                    }
                                    else{
                                        fSubtopic = i
                                        performSegue(withIdentifier: "headerSegue", sender: self)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        else{
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
            else {  // if search not active
                rowIndex = indexPath.row - 1
                sectionIndex = indexPath.section
                performSegue(withIdentifier: "subCell", sender: self)
            }
        }
    }
    
    //pass in the topic index into SubTableViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "subCell"{
            let subTableView = segue.destination as? SubTableViewController
            if tapTopic {
                subTableView?.topic = fTopic
            }
            else{
                subTableView?.topic = status.CategoryList[sectionIndex].topics[rowIndex]
            }
            subTableView?.topicIndex = rowIndex
        }
        else if segue.identifier == "fromSearchSegue"{
            let destinationVC = segue.destination as? SingleViewController
            destinationVC?.subtopic = fSubtopic
        }
        else if segue.identifier == "headerSegue"{
            let destinationVC = segue.destination as? SingleViewCardReveal
            destinationVC?.subtopic = fSubtopic
            destinationVC?.isFromSearch = true
        }
        else if segue.identifier == "headerImageSegue"{
            let destinationVC = segue.destination as? SingleViewImageCardReveal
            destinationVC?.subtopic = fSubtopic
            destinationVC?.isFromSearch = true
        }
    }
}
