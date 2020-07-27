//
//  SearchViewController.swift
//  Opth
//
//  Created by Nancy Fong on 7/25/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var label: UILabel!
    
    // grabs the parsed data
    var subtopicAr = [Subtopic]()
    var headerInfoAr = [Card]()
    var topicAr = [Topic]()
    
    // filtered topic and subtopic
    var fCategory: Category!
    var fTopic: Topic!
    var fSubtopic: Subtopic!
    
    // new array of grabbed data you are searching
    var filteredInfo: [Card] = []
    var filteredHeaders: [Card] = []
    var filteredSubtopics: [Subtopic] = []
    var filteredTopics: [Topic] = []
    
    var rowIndex = 0
    
    //Make the top bar with the time to be white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //setup delegate
        tableView.delegate = self
        tableView.dataSource = self
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

    // filters through the respective array in order to search for what the user inputs
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text != ""{
            tableView.isHidden = false
            label.isHidden = true
        }
        else {
            tableView.isHidden = true
            label.isHidden = false
        }
        
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
        self.tableView.reloadData()
    }
        
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTopics.count + filteredSubtopics.count + filteredHeaders.count + filteredInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            
            // trimming the HTML code
            let a = filteredHeaders[index].header.replacingOccurrences(of: "<u>", with: "")
            let b = a.replacingOccurrences(of: "</u>", with: "")
            let c = b.replacingOccurrences(of: "<b>", with: "")
            let d = c.replacingOccurrences(of: "</b>", with: "")
            let e = d.replacingOccurrences(of: "<i>", with: "")
            let f = e.replacingOccurrences(of: "</i>", with: "")
            
            cell.textLabel?.text = f
            cell.detailTextLabel?.text = "\(category) > \(topic) > \(subtopic)"
            
        }
            // gets the info
        else if indexPath.row - filteredTopics.count - filteredSubtopics.count - filteredHeaders.count < filteredInfo.count{
            let index = indexPath.row - filteredTopics.count - filteredSubtopics.count - filteredHeaders.count
            let category = filteredInfo[index].cardCategory
            let topic = filteredInfo[index].cardTopic
            let subtopic = filteredInfo[index].cardSubtopic
            
            // trimming the HTML code
            let a = filteredInfo[index].info.replacingOccurrences(of: "<u>", with: "")
            let b = a.replacingOccurrences(of: "</u>", with: "")
            let c = b.replacingOccurrences(of: "<b>", with: "")
            let d = c.replacingOccurrences(of: "</b>", with: "")
            let e = d.replacingOccurrences(of: "<i>", with: "")
            let f = e.replacingOccurrences(of: "</i>", with: "")
            
            cell.textLabel?.text = f
            cell.detailTextLabel?.text = "\(category) > \(topic) > \(subtopic)"
        }
        
        cell.textLabel?.textColor = UIColor.white // the searched info is in white text
        cell.detailTextLabel?.textColor = UIColor.cyan // the description of where the word is nested under is in cyan color
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        tableView.deselectRow(at: indexPath, animated: true)
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
        
        // segue code for redirection from search to other view controller
        if t > 0{
            fTopic = filteredTopics[indexPath.row]
            for i in status.CategoryList {
                if i.categoryName == fTopic.topicCategory {
                    fCategory = i
                }
            }
            performSegue(withIdentifier: "searchTopic", sender: self)
        }
        else if s > 0{
            for k in 0..<filteredSubtopics.count + 1{
                if k == indexPath.row - filteredTopics.count{
                    fSubtopic = filteredSubtopics[k]
                    for i in status.CategoryList {
                        for j in i.topics {
                            let temp = j.topicName.replacingOccurrences(of: " ", with: "")
                            if temp == fSubtopic.subtopicTopic {
                                fTopic = j
                            }
                        }
                    }
                    performSegue(withIdentifier: "searchSubtopic", sender: self)
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
                                    performSegue(withIdentifier: "searchHeaderImg", sender: self)
                                }
                                else{
                                    fSubtopic = i
                                    performSegue(withIdentifier: "searchHeader", sender: self)
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
                                    performSegue(withIdentifier: "searchHeaderImg", sender: self)
                                }
                                else{
                                    fSubtopic = i
                                    performSegue(withIdentifier: "searchHeader", sender: self)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    //pass in the topic index into SubTableViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "searchTopic"{
            let subTableView = segue.destination as? ContentsOfTableViewController
            subTableView?.category = fCategory
        }
        else if segue.identifier == "searchSubtopic"{
            let destinationVC = segue.destination as? SingleViewController
            destinationVC?.subtopic = fSubtopic
            destinationVC?.topic = fTopic
        }
        else if segue.identifier == "searchHeader"{
            let destinationVC = segue.destination as? SingleViewCardReveal
            destinationVC?.subtopic = fSubtopic
            destinationVC?.isFromSearch = true
        }
        else if segue.identifier == "searchHeaderImg"{
            let destinationVC = segue.destination as? SingleViewImageCardReveal
            destinationVC?.subtopic = fSubtopic
            destinationVC?.isFromSearch = true
        }
    }
}
