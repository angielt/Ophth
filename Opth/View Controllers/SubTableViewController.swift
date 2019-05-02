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
    var topicLabel = ""
    var categoryCount = 0
    var subtopicCount = 0
    var subtopicAr = [String]()
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func reviewButton(_ sender: Any) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cardVC") as! ViewController
        spacedRep.VCreference = (viewController as! ViewController)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.present(viewController, animated: true, completion: nil)
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    //number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return categoryCount
    }

    //number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return subtopicCount
    }
    
    //print out the subtopics
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        topicName.text = topicLabel
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "subCell", for: indexPath)

        cell.textLabel?.text = subtopicAr[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /***
         need to fix the segue from here to the card Reveal (flashcard)
        ***/
        
//        let selectedTopic = status.CategoryList[indexPath.section].topics[topicIndex].subtopics[indexPath.row].subtopicName
//        let destinationVC = ViewController()
//        destinationVC.cardName = selectedTopic
//        destinationVC.performSegue(withIdentifier: "flashCardSegue", sender: self)
        
        performSegue(withIdentifier: "flashCardSegue", sender: self)
    }

}
