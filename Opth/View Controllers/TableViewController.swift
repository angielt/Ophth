//
//  TableViewController.swift
//  Opth
//
//  Created by Itzel Hernandez on 3/13/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

import UIKit

extension Topic {

//populate the table
struct cellData {
    var opened = Bool()
    var topic: String?
    var subTopic: [Subtopic]
}

class TableViewController: UITableViewController {

    //var dictTopics = [CFStringGetCString]
    //var arrayTopics = NSMutableArray()
    
    var tableViewData = [cellData]()
    var topic: Topic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //parse.csv(data:"SmallTes.txt")
        //status.printContents()
        
        //let path = Bundle.main.path(forResource: "SmallTes", ofType: "txt")
        
        //  var fileContents: String? = "txt"
        /* do {
         let fileContents = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
         let readings = fileContents.components(separatedBy: "\t") as [String]
         for row in readings.dropFirst() {
         
         arrayTopics.add(dictTopics)
         }
         } catch _ as NSError {
         print("Error")
         }*/

        tableViewData = [cellData(opened: false, topic: topic?.topicName, subTopic: topic?.subtopics ?? [])]
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tableViewData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if tableViewData[section].opened == true {
            return tableViewData[section].subTopic.count + 1
        }
        else {
            return 1
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataIndex = indexPath.row - 1
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                return UITableViewCell()}
            cell.textLabel?.text = tableViewData[indexPath.section].topic
            return cell
        }
        else {
            // use different cell identifier if needed
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                return UITableViewCell()}
            //cell.textLabel?.text = tableViewData[indexPath.section].subTopic[dataIndex]
            return cell
        }
    }
    

    // within this function, program so that subtoic goes to card
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // to make sure that subtopic doesn't close up and goes somewhere else
        if indexPath.row == 0 {
            if tableViewData[indexPath.section].opened == true {
                tableViewData[indexPath.section].opened = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none) // play around with this
            }
            else {
                tableViewData[indexPath.section].opened = true
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none) // play around with this
            }
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
}
