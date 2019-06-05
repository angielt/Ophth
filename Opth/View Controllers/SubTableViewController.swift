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

    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func reviewButton(_ sender: Any) {
        
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cardVC") as! ViewController
        spacedRep.VCreference = (viewController as! ViewController)
        spacedRep.setReviewTopic(topic: &topic)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topic.subtopics.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        topicName.text = topic.topicName
        let userDefaults = UserDefaults.standard
        let cell = tableView.dequeueReusableCell(withIdentifier: "subCell", for: indexPath)
        cell.textLabel?.text = topic.subtopics[indexPath.row].subtopicName
        cell.textLabel?.textColor = UIColor.white
    
        if (userDefaults.string(forKey: topic.subtopics[indexPath.row].subtopicName)) != nil {
            cell.accessoryView = UIImageView(image: UIImage(named: "fileIcon.png"))
            cell.accessoryView?.frame = CGRect(x: 304, y: 45, width: 30, height: 30)
        } else {
            cell.accessoryView?.isHidden = true
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        subtopic = topic.subtopics[indexPath.row]
        index = indexPath.row
        performSegue(withIdentifier: "fromSubTableSegue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        if segue.identifier == "fromSubTableSegue", let destinationVC = segue.destination as? SingleViewController{
            destinationVC.subtopic = subtopic
        }
    }
}
