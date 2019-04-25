//
//  CardRevealImageViewController.swift
//  Opth
//
//  Created by Angie Ta on 4/24/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//
import Foundation

import UIKit

class CardRevealImageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var subtopicImageCollectionView: UICollectionView!
    
    @IBOutlet weak var subtopicImagePageControl: UIPageControl!
    
    @IBOutlet weak var subtopicTableView: SubtopicTableView!
    
    var imageArr:[UIImage] = []
    //count how many taps
    var counter = 0
    var index = 0
    var indexMax = 0
    var showInfo = false
    let tap = UITapGestureRecognizer()
    let currentIndex = status.curReviewIndex
    //    subtopicTableView.addGestureRecognizer(tap)
    
    //Buttons
    @IBAction func easyOnClick(_ sender: Any) {
        print("easy")
        
        dismiss(animated: true, completion: nil)
    }
    @IBAction func unsureOnClick(_ sender: Any) {
        print("unsure")
        
        dismiss(animated: true, completion: nil)
    }
    @IBAction func hardOnClick(_ sender: Any) {
        print("hard")
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tableViewonClick(_ sender: UITableView){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // programmically add uiview
        let currentReviewIndex = status.curReviewIndex
        if(status.ReviewList[currentReviewIndex].img_list.count != 0){
            
        }
        
        subtopicTableView.rowHeight = UITableView.automaticDimension
        let tap = UITapGestureRecognizer(target: self, action: #selector(CardRevealImageViewController.handleTap(_:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        subtopicTableView.addGestureRecognizer(tap)
        subtopicTableView.isUserInteractionEnabled = true
        
        //        // occlusion
        
    }
    // tap occlusion
    @objc func handleTap(_ sender:UITapGestureRecognizer){
        if(index <= indexMax){
            print("handletap")
            print(indexMax)
            
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
        return status.ReviewList[currentIndex].cards.count
    }
    
    // Provide a cell object for each row.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("index: " + String(index))
        print("indexPath: "+String(indexPath.row))
        print("review index: "+String(currentIndex))
        // fetch cell
        if(indexMax < indexPath.row){
            indexMax = indexPath.row
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubtopicInfoCell", for: indexPath) as! SubtopicTableViewCell
        
        
        // fill cell contents
        if(indexPath.row < status.ReviewList[currentIndex].cards.count){
            cell.Header.text = status.ReviewList[currentIndex].cards[indexPath.row].header
            cell.Info.text = status.ReviewList[currentIndex].cards[indexPath.row].info
            
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
    
}

