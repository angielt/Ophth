//
//  SingleViewCardReveal.swift
//  Opth
//
//  Created by Cathy Hsieh on 5/15/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

import Foundation
import SwiftRichString
import UIKit

class SingleViewCardReveal: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var cardTitle: UILabel!
    @IBOutlet weak var addNotes: UIButton!
    @IBOutlet weak var subtopicTableView: SubtopicTableView!
    @IBOutlet weak var downIndicator: UIImageView!
    
    var index = 0
    var indexMax = 0
    var showInfo = false
    let tap = UITapGestureRecognizer()
    var subtopic: Subtopic!
    var buttonsVisible:Bool = false
    var isFromSearch = false

    @IBAction func backButton(_ sender: Any) {
        if isFromSearch{
            dismiss(animated: true, completion: nil)
        }
        else{
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    //Make the top bar with the time to be white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downIndicator.loadGif(name: "downArrow")
        downIndicator.isHidden = false
        subtopicTableView.rowHeight = UITableView.automaticDimension
        let tap = UITapGestureRecognizer(target: self, action: #selector(CardRevealViewController.handleTap(_:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        subtopicTableView.addGestureRecognizer(tap)
        subtopicTableView.isUserInteractionEnabled = true
        indexMax = subtopic.cards.count //spacedRep.reviewList.count
        
        cardTitle.text = subtopic.subtopicName
    }
    
    //Fade in effect
    func fadeIn(name: UILabel){
        UIView.animate(withDuration: 0.5, animations: {name.alpha = 0})
    }
    
    // Return the number of rows for the table.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subtopic.cards.count
    }
    
    // Provide a cell object for each row.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // fetch cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubtopicInfoCell", for: indexPath) as! SubtopicTableViewCell
        
        let underline = Style {
            $0.font = UIFont.systemFont(ofSize: 20)
            $0.underline = (style: NSUnderlineStyle.single, color: nil)
        }
        
        let italic = Style {
            //$0.font = UIFont.systemFont(ofSize: 20)
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
        if(indexPath.row < subtopic.cards.count){
            let str = subtopic.cards[indexPath.row].header
            cell.Header.attributedText = str.set(style: myGroup)
            cell.Info.text = subtopic.cards[indexPath.row].info
            
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
            if (index == subtopic.cards.count-1){
                cell.Info.textColor = UIColor.white
                index = index+1
            }
            if(visibleRowIndexArray.contains(index+1)){
                if(index < subtopic.cards.count - 1) {
                    let a = subtopicTableView.cellForRow(at: IndexPath(row: index + 1, section: 0)) as! SubtopicTableViewCell
                    cell.Info.textColor = UIColor.white
                    a.Header.textColor = UIColor.cyan
                }
                index = index+1
            }
            if(index == subtopic.cards.count){
                downIndicator.isHidden = true
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationController = segue.destination as? UINavigationController,
            let destinationViewController = navigationController.viewControllers.first as? NotesViewController {
            destinationViewController.subtopic = subtopic.subtopicName
        }
    }
    
    // An unwind segue moves backward through one or more segues to return the user to a scene managed by an existing view controller.
    @IBAction func unwindToFlashCardList(sender: UIStoryboardSegue) {
        if sender.source is NotesViewController {
        }
    }
}
