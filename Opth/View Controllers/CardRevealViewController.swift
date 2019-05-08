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
    

    @IBOutlet weak var subtopicTableView: SubtopicTableView!
    @IBOutlet weak var addNotes: UIButton!
    
    //count how many taps
    var counter = 0
    var index = 0
    var indexMax = 0
    var showInfo = false
    let tap = UITapGestureRecognizer()
    let currentIndex = status.curReviewIndex
    
    var cards: [Card]?
//    subtopicTableView.addGestureRecognizer(tap)
    
    //Buttons
    @IBAction func easyOnClick(_ sender: Any) {
        print("easy")
       // status.curReviewIndex = status.curReviewIndex + 1
        dismiss(animated: true, completion: nil)
    }
    @IBAction func unsureOnClick(_ sender: Any) {
        print("unsure")
        //status.curReviewIndex = status.curReviewIndex + 1
        dismiss(animated: true, completion: nil)
    }
    @IBAction func hardOnClick(_ sender: Any) {
        print("hard")
        //status.curReviewIndex = status.curReviewIndex + 1
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tableViewonClick(_ sender: UITableView){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subtopicTableView.rowHeight = UITableView.automaticDimension
        let tap = UITapGestureRecognizer(target: self, action: #selector(CardRevealViewController.handleTap(_:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        subtopicTableView.addGestureRecognizer(tap)
        subtopicTableView.isUserInteractionEnabled = true

    }
    // tap occlusion
    @objc func handleTap(_ sender:UITapGestureRecognizer){
        if(index <= indexMax){
            let cell = subtopicTableView.cellForRow(at: IndexPath(row: index, section: 0)) as! SubtopicTableViewCell
            if(showInfo == false){
                showInfo = true
                cell.Info.textColor = UIColor.white
                index = index+1
            }
            else if(showInfo == true){
                showInfo = false
                cell.Header.textColor = UIColor.blue
            }
        }
    }
    
    //Fade in effect
    func fadeIn(name: UILabel){
        UIView.animate(withDuration: 0.5, animations: {name.alpha = 0})
    }
    
    // Return the number of rows for the table.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards?.count ?? 1 //status.ReviewList[currentIndex].cards.count
    }
    
    // Provide a cell object for each row.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // fetch cell
        if(indexMax < indexPath.row){
            indexMax = indexPath.row
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubtopicInfoCell", for: indexPath) as! SubtopicTableViewCell

        
        // fill cell contents
        if(indexPath.row < cards?.count ?? 1){ //status.ReviewList[currentIndex].cards.count
            cell.Header.text = cards?[indexPath.row].header //status.ReviewList[currentIndex].cards[indexPath.row].header
            cell.Info.text = cards?[indexPath.row].info //status.ReviewList[currentIndex].cards[indexPath.row].info

            if(indexPath.row == 0 && index <= indexPath.row){
                cell.Header.textColor = UIColor.blue
                cell.Info.textColor = UIColor.black
            }
            else if(index < indexPath.row){
                cell.Header.textColor = UIColor.black
                cell.Info.textColor = UIColor.black
            }
            else if(index > indexPath.row){
                cell.Header.textColor = UIColor.blue
                cell.Info.textColor = UIColor.white
            }
        }
        
        return cell
    }
    
    //MARK: Actions
    @IBAction func unwindToFlashCardList(sender: UIStoryboardSegue) {
        if sender.source is NotesViewController { //meal = sourceViewController.meal {
        }
        
    }
}


