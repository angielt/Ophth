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
        
        // data file
        if let filepath = Bundle.main.path(forResource: "Text_07.13.19", ofType: "txt") {
               parse.csv(data: filepath)
        } else {
            print("data file could not be found")
        }
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
        if status.CategoryList[section].opened == true {
            return category.topics[section].subtopics.count
        }
        else {
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {  //Categories
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                return UITableViewCell()}
            cell.textLabel?.text = category.topics[indexPath.section].topicName // the cells displayed are the categories
            cell.detailTextLabel?.text = "" // has no subtitle under it to be displayed
            cell.textLabel?.textColor = UIColor.white
            cell.textLabel?.font = UIFont.systemFont(ofSize: 17.0)
            return cell
        }
        else {  //Topics
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                return UITableViewCell()}
            
            cell.textLabel?.text = "  \t" + category.topics[indexPath.section].subtopics[indexPath.row-1].subtopicName
            cell.textLabel?.textColor = UIColor.white
            cell.detailTextLabel?.text = "" // they have no subtitle under it to be displayed
            cell.textLabel?.font = UIFont.systemFont(ofSize: 17.0)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
        else {  // if search not active, segue is performed to go to the subtopics page
            rowIndex = indexPath.row - 1
            sectionIndex = indexPath.section
            performSegue(withIdentifier: "fromSubTableSegue", sender: self)
        }
    }
    
    //pass in the topic index into SubTableViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromSubTableSegue", let destinationVC = segue.destination as? SingleViewController{
            destinationVC.subtopic = category.topics[sectionIndex].subtopics[rowIndex]
        }
    }
}
