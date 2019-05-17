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
    var topic: Topic!
    var subtopic: Subtopic!
    var index = 0
    var topicIndex = 0
    var image = UIImage(named: "notes.png")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topic.subtopics.sort(by: {$0.subtopicName < $1.subtopicName})
        self.loadData()
    }
    
    func loadData(){
        view.reloadInputViews()
        self.tableView.reloadData()
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        self.tableView.reloadData()
    }
    
    @IBAction func reviewButton(_ sender: Any) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cardVC") as! ViewController
        spacedRep.VCreference = (viewController as! ViewController)
        spacedRep.setReviewTopic(topic: &topic)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = topic.topicName
        self.tableView.reloadData()
    }

    //number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    //number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topic.subtopics.count
    }
    
    //print out the subtopics
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        topicName.text = topic.topicName
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "subCell", for: indexPath)

        cell.textLabel?.text = topic.subtopics[indexPath.row].subtopicName//subtopicAr[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        
        if UserDefaults.standard.string(forKey: topic.subtopics[indexPath.row].subtopicName) != nil {
            let imageview = UIImageView(image: image)
            imageview.frame = CGRect(x: 304, y: 45, width: 25, height: 25)
            cell.accessoryView = imageview
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
