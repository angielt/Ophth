//
//  SubTableViewController.swift
//  Opth
//
//  Created by Cathy Hsieh on 4/18/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

import UIKit

class SubTableViewController: UITableViewController {
    @IBOutlet weak var topicName: UILabel!
    //var topicLabel = ""
    //var categoryCount = 0
    //var subtopicCount = 0
    //var subtopicAr = [String]()
    var topic: Topic!
    var subtopic: Subtopic!
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = topic.topicName
    }

    //number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1 //categoryCount
    }

    //number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return topic.subtopics.count //subtopicCount
    }
    
    //print out the subtopics
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //topicName.text = topic.topicName
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "subCell", for: indexPath)

        cell.textLabel?.text = topic.subtopics[indexPath.row].subtopicName//subtopicAr[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //let destinationVC = ViewController()
        //destinationVC.subtopic = topic?.subtopics[indexPath.row]
        
        
        /***
         need to fix the segue from here to the card Reveal (flashcard)
        ***/
        
//        let selectedTopic = status.CategoryList[indexPath.section].topics[topicIndex].subtopics[indexPath.row].subtopicName
//        let destinationVC = ViewController()
//        destinationVC.cardName = selectedTopic
//        destinationVC.performSegue(withIdentifier: "flashCardSegue", sender: self)
        subtopic = topic.subtopics[indexPath.row]
        index = indexPath.row
        performSegue(withIdentifier: "flashCardSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        if segue.identifier == "flashCardSegue", let destinationVC = segue.destination as? ViewController{
            destinationVC.subtopic = subtopic
            destinationVC.topic = topic
            destinationVC.curIndex = index
        }
    }
}