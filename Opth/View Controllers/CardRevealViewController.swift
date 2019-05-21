//
//  CardRevealViewController.swift
//  Opth
//
//  Created by Angie Ta on 2/18/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

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
    var buttonsVisible:Bool = false
    
    @IBOutlet weak var easyButton: UIButton!
    @IBOutlet weak var unsureButton: UIButton!
    @IBOutlet weak var hardButton: UIButton!
    
    //Buttons

    @IBAction func backButton(_ sender: Any) {
        if spacedRep.all_active{
            dismiss(animated: true, completion: nil)
        }
        else{
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func easyOnClick(_ sender: Any) {
        if(buttonsVisible == true){
            spacedRep.easyPressed()
            // status.curReviewIndex = status.curReviewIndex + 1
            dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func unsureOnClick(_ sender: Any) {
        if(buttonsVisible == true){
            spacedRep.unsurePressed()
            // status.curReviewIndex = status.curReviewIndex + 1
            dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func hardOnClick(_ sender: Any) {
        if(buttonsVisible == true){
            spacedRep.hardPressed()
            // status.curReviewIndex = status.curReviewIndex + 1
            dismiss(animated: true, completion: nil)
        }
    }
    func showButtons(){
        easyButton.isHidden = false
        unsureButton.isHidden = false
        hardButton.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        easyButton.isHidden = true
        unsureButton.isHidden = true
        hardButton.isHidden = true
        
        subtopicTableView.rowHeight = UITableView.automaticDimension
        let tap = UITapGestureRecognizer(target: self, action: #selector(CardRevealViewController.handleTap(_:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        subtopicTableView.addGestureRecognizer(tap)
        subtopicTableView.isUserInteractionEnabled = true
        indexMax = spacedRep.reviewList[curReviewIndex].cards.count //spacedRep.reviewList.count
        
        cardTitle.text = spacedRep.reviewList[curReviewIndex].subtopicName
    }
    
    //Fade in effect
    func fadeIn(name: UILabel){
        UIView.animate(withDuration: 0.5, animations: {name.alpha = 0})
    }
    
    // Return the number of rows for the table.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spacedRep.reviewList[curReviewIndex].cards.count
    }
    
    // Provide a cell object for each row.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        // fetch cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubtopicInfoCell", for: indexPath) as! SubtopicTableViewCell
        
        
        // fill cell contents
        if(indexPath.row < spacedRep.reviewList[curReviewIndex].cards.count){
            let info = spacedRep.reviewList[curReviewIndex].cards[indexPath.row].info
            cell.Header.text = spacedRep.reviewList[curReviewIndex].cards[indexPath.row].header
            cell.Info.text = info
            
            
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
    
    // tap occlusion
    @objc func handleTap(_ sender:UITapGestureRecognizer){
        
        let visibleIndexPaths = subtopicTableView.indexPathsForVisibleRows

        var visibleRowIndexArray: [Int] = []
        
        for currentIndextPath in visibleIndexPaths! {
            //  You now have visible cells in visibleCellsArray
            visibleRowIndexArray.append(currentIndextPath.row)
        }
        if(visibleRowIndexArray.contains(index)){
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
            if(index == spacedRep.reviewList[curReviewIndex].cards.count){
                buttonsVisible = true
                self.showButtons()
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationController = segue.destination as? UINavigationController,
            let destinationViewController = navigationController.viewControllers.first as? NotesViewController {
            destinationViewController.subtopic = spacedRep.reviewList[curReviewIndex].subtopicName
        }
    }

    // An unwind segue moves backward through one or more segues to return the user to a scene managed by an existing view controller.
    @IBAction func unwindToFlashCardList(sender: UIStoryboardSegue) {
        if let senderVC = sender.source as? NotesViewController {

        }
    }
}
