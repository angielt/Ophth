//
//  CardRevealViewController.swift
//  Opth
//
//  Created by Angie Ta on 2/18/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//




import Foundation

import UIKit

class CardRevealViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var subtopicTableView: SubtopicTableView!
    //count how many taps
    var counter = 0
    var index = 0 // indexPath.row
    var indexMax = 0
    var showInfo = false
    let tap = UITapGestureRecognizer()
    let curReviewIndex = spacedRep.curReviewIndex // current subtopic
//    subtopicTableView.addGestureRecognizer(tap)
    
    //Buttons
    @IBAction func easyOnClick(_ sender: Any) {
        print("easy")
        spacedRep.easyPressed()
       // spacedRep.curReviewIndex = spacedRep.curReviewIndex + 1
        dismiss(animated: true) {
        }
    }
    @IBAction func unsureOnClick(_ sender: Any) {
        print("unsure")
        spacedRep.unsurePressed()
        dismiss(animated: true, completion: nil)
    }
    @IBAction func hardOnClick(_ sender: Any) {
        print("hard")
        spacedRep.hardPressed()
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // programmically add uiview
//        let currentReviewIndex = spacedRep.curReviewIndex
//        if(spacedRep.ReviewList[currentReviewIndex].img_list[currentReviewIndex] != "no image"){
//            
//        }
        subtopicTableView.rowHeight = UITableView.automaticDimension
        let tap = UITapGestureRecognizer(target: self, action: #selector(CardRevealViewController.handleTap(_:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        subtopicTableView.addGestureRecognizer(tap)
        subtopicTableView.isUserInteractionEnabled = true
        indexMax = spacedRep.reviewList.count
        
    }
    // tap occlusion
    @objc func handleTap(_ sender:UITapGestureRecognizer){
        if(index <= indexMax-1){
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
        //print("num headers " + String(spacedRep.subtopics[curReviewIndex].cards.count))
        //print("num headers " + String(spacedRep.subtopics[curReviewIndex].cards[]))
        print("curReviewIndex " + String(curReviewIndex))
        print("curReviewIndex.count " + String(spacedRep.reviewList.count))
        return spacedRep.reviewList[curReviewIndex].cards.count
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
    
}

