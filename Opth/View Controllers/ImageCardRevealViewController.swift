//
//  ImageCardRevealViewController.swift
//  Opth
//
//  Created by Cathy Hsieh on 4/28/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

import Foundation
import SwiftRichString
import UIKit

class imageTapGesture: UITapGestureRecognizer{
    var imageIndex = 0
}

// Reveals card with images in Shuffle All
class ImageCardRevealViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    
    @IBOutlet weak var cardTitle: UILabel!
    @IBOutlet weak var easyButton: UIButton!
    @IBOutlet weak var unsureButton: UIButton!
    @IBOutlet weak var hardButton: UIButton!
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var imagePageController: UIPageControl!
    @IBOutlet weak var downIndicator: UIImageView!
    @IBOutlet weak var subtopicTableView: SubtopicTableView!
    @IBOutlet weak var addNotes: UIButton!
    
    var imageIndex = 0
    var isBackFromFullScreen = false
    
    //count how many taps
    var counter = 0
    var index = 0
    var indexMax = 0
    var showInfo = false
    let tap = UITapGestureRecognizer()
    let curReviewIndex = spacedRep.curReviewIndex // current subtopic
    var occlusionFinished = false
    var occlusionTapCount = 0
    var imageCount = 0
    var buttonsVisible:Bool = false
    
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
            spacedRep.VCreference?.loadCard()
            dismiss(animated: true, completion: nil)
        }
        else{
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        
    }
    @IBAction func easyOnClick(_ sender: Any) {
        if(buttonsVisible == true){
            spacedRep.easyPressed()
            dismiss(animated: true) {
            }
        }
    }
    @IBAction func unsureOnClick(_ sender: Any) {
        if(buttonsVisible == true){
            spacedRep.unsurePressed()
            dismiss(animated: true) {
            }
        }
    }
    @IBAction func hardOnClick(_ sender: Any) {
        if(buttonsVisible == true){
            spacedRep.hardPressed()
            dismiss(animated: true) {
            }
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
        
        //UI image
        imageScrollView.delegate = self
        
        // set image count
        imageCount = spacedRep.reviewList[curReviewIndex].img_list.count
        
        // set page indicator count
        imagePageController.numberOfPages = imageCount

        // loop through the images for the specific subtopic and display
        for i in 0..<imageCount{
            let imageView = UIImageView()
            imageView.isUserInteractionEnabled = true  //enable tap on image
            var img = spacedRep.reviewList[curReviewIndex].img_list[i]  // get the image list
            
            // display .gif images
            if (img.contains(".gif")){
                img = img.replacingOccurrences(of: ".gif", with: "")
                imageView.loadGif(name: img)
            }
            else{  // display .png or .jpg images
                imageView.image = UIImage(named: img)
            }
            
            //set the size and position of the image frame and image
            imageView.contentMode = .scaleAspectFit
            let xCordinate = self.view.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xCordinate, y: 0, width: self.imageScrollView.frame.width, height: self.imageScrollView.frame.height)
            self.imageScrollView.contentSize.width = self.view.frame.width * CGFloat(i + 1)
            
            //add tap recognizer for image
            let imageTap = imageTapGesture(target: self,action:#selector(imageTapped))
            imageTap.imageIndex = i
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(imageTap)
            self.imageScrollView.addSubview(imageView)
            
            /***
                uncommit code below to add caption for each image
            ***/
            
//            if spacedRep.reviewList[curReviewIndex].img_caption[0] != "nil"{
//                let caption = UILabel(frame: CGRect.init(origin: CGPoint.init(x:0,y:self.imageScrollView.frame.height - 62), size: CGSize.init(width:self.view.frame.width,height:50)))
//                caption.text = spacedRep.reviewList[curReviewIndex].img_caption[i]
//                caption.textColor = UIColor.white
//                caption.font = UIFont.systemFont(ofSize: 14.0)
//                caption.numberOfLines = 3
//                caption.lineBreakMode = .byWordWrapping
//                caption.sizeToFit()
//                let captionLocation = self.imageScrollView.center.x
//
//                //set the position of the caption
//                if i == 0{
//                    caption.center.x = captionLocation
//                }
//                else{
//                    caption.center.x = captionLocation + self.view.frame.width * CGFloat(i)
//                }
//                self.imageScrollView.addSubview(caption)
//            }
        }
    }
    
    // Return the number of rows for the table.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spacedRep.reviewList[curReviewIndex].cards.count
    }
    
    // Provide a cell object for each row.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // fetch cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubtopicInfoCell", for: indexPath) as! SubtopicTableViewCell
        
        // font style
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
        
        let cardCount = spacedRep.reviewList[spacedRep.curReviewIndex].cards.count

        // fill cell contents
        if(indexPath.row < cardCount){
            let str = spacedRep.reviewList[curReviewIndex].cards[indexPath.row].header
            let str2 = spacedRep.reviewList[curReviewIndex].cards[indexPath.row].info
            cell.Header.attributedText = str.set(style: myGroup)
            cell.Info.attributedText = str2.set(style: myGroup)
            
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
    
    // An unwind segue moves backward through one or more segues to return the user to a scene managed by an existing view controller.
    @IBAction func unwindToFlashCardList(sender: UIStoryboardSegue) {
        if sender.source is NotesViewController {
        }
    }

    // link the page controller with the image scroll view
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        imagePageController.currentPage = Int(round(imageScrollView.contentOffset.x / imageScrollView.frame.width))
    }
    
    // tap occlusion
    @objc func handleTap(_ sender:UITapGestureRecognizer){
        let visibleIndexPaths = subtopicTableView.indexPathsForVisibleRows
        
        var visibleRowIndexArray: [Int] = []
        
        for currentIndextPath in visibleIndexPaths! {
            //  You now have visible cells in visibleCellsArray
            visibleRowIndexArray.append(currentIndextPath.row)
        }
        
        // display info and header at the same time
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
            if(index == (spacedRep.reviewList[curReviewIndex].cards.count)){
                self.buttonsVisible = true
                self.showButtons()
            }
        }
    }
    
    // tap recognizer for image
    @objc func imageTapped(sender:imageTapGesture) {
        let index = sender.imageIndex
        imageIndex = index
        performSegue(withIdentifier: "fullImage", sender: self)
    }
    
    // segue from image to full screen image
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "fullImage"){
            let image = segue.destination as! photoViewViewController
            image.imageIndex = imageIndex
            image.imageArray = spacedRep.reviewList[curReviewIndex].img_list
        }
        if (segue.identifier == "addNotes") {
            let navigationController = segue.destination as? UINavigationController
            let destinationViewController = navigationController?.viewControllers.first as? NotesViewController
            destinationViewController?.subtopic = spacedRep.reviewList[curReviewIndex].subtopicName
        }
    }
}
