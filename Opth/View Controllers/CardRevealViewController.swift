//
//  CardRevealViewController.swift
//  Opth
//
//  Created by Angie Ta on 2/18/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

import Foundation
import SwiftRichString

import UIKit

// Reveals card without images in Shuffle All
class CardRevealViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var cardTitle: UILabel!
    @IBOutlet weak var subtopicTableView: SubtopicTableView!
    @IBOutlet weak var addNotes: UIButton!
    @IBOutlet weak var downIndicator: UIImageView!
    
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
    
    //Make the top bar with the time to be white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }

    @IBAction func backButton(_ sender: Any) {
        if spacedRep.all_active{
            spacedRep.curReviewIndex = spacedRep.curReviewIndex - 1
            spacedRep.VCreference?.loadData()
            dismiss(animated: true, completion: nil)
        }
        else{
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func easyOnClick(_ sender: Any) {
        if(buttonsVisible == true){
            spacedRep.easyPressed()
            dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func unsureOnClick(_ sender: Any) {
        if(buttonsVisible == true){
            spacedRep.unsurePressed()
            dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func hardOnClick(_ sender: Any) {
        if(buttonsVisible == true){
            spacedRep.hardPressed()
            dismiss(animated: true, completion: nil)
        }
    }
    func showButtons(){
        downIndicator.isHidden = true
        easyButton.isHidden = false
        unsureButton.isHidden = false
        hardButton.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downIndicator.loadGif(name: "downArrow")
        easyButton.isHidden = true
        unsureButton.isHidden = true
        hardButton.isHidden = true
        downIndicator.isHidden = false
        
        subtopicTableView.rowHeight = UITableView.automaticDimension
        let tap = UITapGestureRecognizer(target: self, action: #selector(CardRevealViewController.handleTap(_:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        subtopicTableView.addGestureRecognizer(tap)
        subtopicTableView.isUserInteractionEnabled = true
        indexMax = spacedRep.reviewList[curReviewIndex].cards.count
        
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
        
        // text style
        let underline = Style {
            $0.font = UIFont.systemFont(ofSize: 20)
            $0.underline = (style: NSUnderlineStyle.single, color: nil)
        }
        let italic = Style {
            $0.font = UIFont.italicSystemFont(ofSize: 20)
        }
        let bold = Style {
            $0.font = UIFont.boldSystemFont(ofSize: 20)
        }
        let myGroup = StyleGroup([
            "u": underline,
            "i": italic,
            "b": bold
            ]
        )
        
        // fill cell contents
        if(indexPath.row < spacedRep.reviewList[curReviewIndex].cards.count){
            let str = spacedRep.reviewList[curReviewIndex].cards[indexPath.row].header
            
            cell.Header.attributedText = str.set(style: myGroup)
            cell.Info.text = spacedRep.reviewList[curReviewIndex].cards[indexPath.row].info

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
            
            // display the last info
            if (index == spacedRep.reviewList[curReviewIndex].cards.count-1){
                cell.Info.textColor = UIColor.white
                index = index+1
            }
            if(visibleRowIndexArray.contains(index+1)){
                if(index < spacedRep.reviewList[curReviewIndex].cards.count - 1) {
                    let a = subtopicTableView.cellForRow(at: IndexPath(row: index + 1, section: 0)) as! SubtopicTableViewCell
                    cell.Info.textColor = UIColor.white
                    a.Header.textColor = UIColor.cyan
                }
                index = index+1
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
        if sender.source is NotesViewController {
        }
    }
}
