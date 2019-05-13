//
//  CardRevealViewController.swift
//  Opth
//
//  Created by Angie Ta on 2/18/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

/*  For UI image
 *** THINGS NEED TO FIX:
 * for some reason, when click on the spaced rep buttons, it goes to the FullScreenImage.swift
 *** THINGS WANT TO FIX
 * when coming back from full screen image, want the page controller/image stays where it left off rather back to the first image
 */


import Foundation

import UIKit

class CardRevealViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var cardTitle: UILabel!
    @IBOutlet weak var subtopicTableView: SubtopicTableView!
    @IBOutlet weak var addNotes: UIButton!
    
    //count how many taps
    var counter = 0
    var index = 0
    var indexMax = 0
    var showInfo = false
    let tap = UITapGestureRecognizer()
    let curReviewIndex = spacedRep.curReviewIndex // current subtopic
    var occlusionFinished = false
    var occlusionTapCount = 0
    
    @IBOutlet weak var easyButton: UIButton!
    @IBOutlet weak var unsureButton: UIButton!
    @IBOutlet weak var hardButton: UIButton!

//    subtopicTableView.addGestureRecognizer(tap)
    
    //Buttons
    @IBAction func easyOnClick(_ sender: Any) {
        print("easy")
        spacedRep.easyPressed()
       // status.curReviewIndex = status.curReviewIndex + 1
        dismiss(animated: true, completion: nil)
    }
    @IBAction func unsureOnClick(_ sender: Any) {
        print("unsure")
        spacedRep.unsurePressed()
        //status.curReviewIndex = status.curReviewIndex + 1
        dismiss(animated: true, completion: nil)
    }
    @IBAction func hardOnClick(_ sender: Any) {
        print("hard")
        spacedRep.hardPressed()
        //status.curReviewIndex = status.curReviewIndex + 1
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subtopicTableView.rowHeight = UITableView.automaticDimension
        let tap = UITapGestureRecognizer(target: self, action: #selector(CardRevealViewController.handleTap(_:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        subtopicTableView.addGestureRecognizer(tap)
        subtopicTableView.isUserInteractionEnabled = true
        indexMax = spacedRep.reviewList.count
        
        cardTitle.text = spacedRep.reviewList[spacedRep.curReviewIndex].subtopicName

    }
    
    // tap occlusion
    @objc func handleTap(_ sender:UITapGestureRecognizer){
        if(index <= indexMax){  // -1?
            let cell = subtopicTableView.cellForRow(at: IndexPath(row: index, section: 0)) as! SubtopicTableViewCell
            if(showInfo == false){
                showInfo = true
                cell.Info.textColor = UIColor.white
                index = index+1
            }
            else if(showInfo == true){
                showInfo = false
                cell.Header.textColor = UIColor.cyan
            }
        }
    }
    
    //Fade in effect
    func fadeIn(name: UILabel){
        UIView.animate(withDuration: 0.5, animations: {name.alpha = 0})
    }
    
    // Return the number of rows for the table.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spacedRep.reviewList[spacedRep.curReviewIndex].cards.count
    }
    
    // Provide a cell object for each row.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // fetch cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubtopicInfoCell", for: indexPath) as! SubtopicTableViewCell
        
        
        // fill cell contents
        if(indexPath.row < spacedRep.reviewList[spacedRep.curReviewIndex].cards.count){
            cell.Header.text = spacedRep.reviewList[spacedRep.curReviewIndex].cards[indexPath.row].header
            cell.Info.text = spacedRep.reviewList[spacedRep.curReviewIndex].cards[indexPath.row].info
            
            if(indexPath.row == 0 && index <= indexPath.row){
                cell.Header.textColor = UIColor.cyan
                cell.Info.textColor = UIColor.black
            }
            else if(index < indexPath.row){
                cell.Header.textColor = UIColor.black
                cell.Info.textColor = UIColor.black
            }
            else if(index > indexPath.row){
                cell.Header.textColor = UIColor.cyan
                cell.Info.textColor = UIColor.white
            }
        }
        return cell
    }
//
//    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationController = segue.destination as? UINavigationController,
            let destinationViewController = navigationController.viewControllers.first as? NotesViewController {
            destinationViewController.subtopic = spacedRep.reviewList[curReviewIndex].subtopicName
        }
    }

    // An unwind segue moves backward through one or more segues to return the user to a scene managed by an existing view controller.
    @IBAction func unwindToFlashCardList(sender: UIStoryboardSegue) {
        if sender.source is NotesViewController{ //let newNote = sourceViewController.notes {
           // status.CategoryList[categoryIndex].topics[topicIndex].subtopics[subIndex].notes = newNote
        }
    }
}
