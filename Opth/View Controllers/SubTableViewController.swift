//
//  SubTableViewController.swift
//  Opth
//
//  Created by Cathy Hsieh on 4/18/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

import UIKit

class SubTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBAction func backtwo(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topicName: UILabel!
    var topic: Topic!
    var subtopic: Subtopic!
    var index = 0
    var topicIndex = 0
    
    //Make the top bar with the time to be white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
    
    // reload the data
    func loadData(){
        self.tableView.reloadData()
        self.view.reloadInputViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserDefaults.standard.synchronize()
        self.tableView.reloadData()
    }

    // back button to dismiss the view
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func reviewButton(_ sender: Any) {
        // segue to topic spaced rep review
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cardVC") as! ViewController
        spacedRep.VCreference = (viewController as! ViewController)
        spacedRep.setReviewTopic(topic: &topic)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    // set number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // set number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topic.subtopics.count
    }
    
    // display the content for each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        topicName.text = topic.topicName
        let userDefaults = UserDefaults.standard
        let cell = tableView.dequeueReusableCell(withIdentifier: "subCell", for: indexPath)
        cell.textLabel?.text = topic.subtopics[indexPath.row].subtopicName
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17.0)
        
    
        // display or hide the note icon
        if (userDefaults.string(forKey: topic.subtopics[indexPath.row].subtopicName)) != nil {
            cell.accessoryView = UIImageView(image: UIImage(named: "fileIcon.png"))
            cell.accessoryView?.frame = CGRect(x: 304, y: 45, width: 30, height: 30)
        } else {
            cell.accessoryView?.isHidden = true
        }
        return cell
        
    }
    
    // segue to single view card
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        subtopic = topic.subtopics[indexPath.row]
        index = indexPath.row
        performSegue(withIdentifier: "fromSubTableSegue", sender: self)
    }

    // pass in the subtopic to the single view card
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        if segue.identifier == "fromSubTableSegue", let destinationVC = segue.destination as? SingleViewController{
            destinationVC.subtopic = subtopic
        }
    }
}
