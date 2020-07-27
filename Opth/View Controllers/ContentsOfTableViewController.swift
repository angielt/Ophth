//
//  ContentsOfTableViewController.swift
//  Opth
//
//  Created by Itzel Hernandez on 4/1/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

// code includes implementation for search and table of contents

import UIKit
import Foundation

class ContentsOfTableViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var topicLabel: UILabel!
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var category: Category!

    var sectionIndex = 0
    var rowIndex = 0
    
    @IBAction func categoryShuffle(_ sender: Any) {
        performSegue(withIdentifier: "categoryShuffle", sender: self)
    }
    
    @IBOutlet weak var tableView: UITableView!

    //Make the top bar with the time to be white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor.darkGray
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]

        topicLabel.text = category.categoryName
        self.loadData()
    }
    
    func loadData() {
        view.reloadInputViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // dispose of any resources that can be recreated
    }
    
    
    // MARK: table of contents
    func numberOfSections(in tableView: UITableView) -> Int {
        return category.topics.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if category.topics[section].opened == true {
            return category.topics[section].subtopics.count + 1
        }
        else {
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {  //topics
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                return UITableViewCell()}
            cell.textLabel?.text = category.topics[indexPath.section].topicName // the cells displayed are the categories
            cell.detailTextLabel?.text = "" // has no subtitle under it to be displayed
            cell.textLabel?.textColor = UIColor.white
            cell.textLabel?.font = UIFont.systemFont(ofSize: 17.0)
            return cell
        }
        else {  //subtopics
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                return UITableViewCell()}
            
            cell.textLabel?.text = "  \t" + category.topics[indexPath.section].subtopics[indexPath.row-1].subtopicName
            cell.textLabel?.textColor = UIColor.white
            cell.detailTextLabel?.text = "" // they have no subtitle under it to be displayed
            cell.textLabel?.font = UIFont.systemFont(ofSize: 17.0)
            
            if UserDefaults.standard.string(forKey: category.topics[indexPath.section].subtopics[indexPath.row-1].subtopicName) != nil {
                let imageview = UIImageView(image: UIImage(named: "fileIcon"))
                imageview.frame = CGRect(x: 304, y: 45, width: 25, height: 25)
                cell.accessoryView = imageview
            }
            else {
                cell.accessoryView = UIImageView(image: UIImage(named: ""))
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {  //Topics
            if category.topics[indexPath.section].opened == true {
                category.topics[indexPath.section].opened = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
            else {  //Open to subtopic
                category.topics[indexPath.section].opened = true
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
        }
        else {
            rowIndex = indexPath.row - 1
            sectionIndex = indexPath.section
            //performSegue(withIdentifier: "fromSubTableSegue", sender: self)
            if category.topics[sectionIndex].subtopics[rowIndex].img_list[0] == "nil" {
                performSegue(withIdentifier: "contentsToSingleViewCard", sender: nil)
            } else {
                performSegue(withIdentifier: "contentsToSingleViewImageCard", sender: nil)
            }
        }
    }
    
    //pass in the topic index into SubTableViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "contentsToSingleViewCard", let destinationViewController = segue.destination as? SingleViewCardReveal {
            destinationViewController.subtopic = category.topics[sectionIndex].subtopics[rowIndex]
        }
        else if segue.identifier == "contentsToSingleViewImageCard", let destinationViewController = segue.destination as? SingleViewImageCardReveal {
            destinationViewController.subtopic = category.topics[sectionIndex].subtopics[rowIndex]
        }
//        else if segue.identifier == "fromSubTableSegue", let destinationVC = segue.destination as? SingleViewController{
//            destinationVC.subtopic = category.topics[sectionIndex].subtopics[rowIndex]
//            destinationVC.topic = category.topics[sectionIndex]
//        }
        else if segue.identifier == "categoryShuffle", let destinationVC = segue.destination as? ViewController{
            destinationVC.category = category
            if (spacedRep.categoryShuffleList.isEmpty){
                spacedRep.setReviewCategory(category: &category)
            }
            else{
                spacedRep.reviewList = spacedRep.categoryShuffleList
                spacedRep.curReviewIndex = spacedRep.category_curReviewIndex
            }
        }
    }
}
