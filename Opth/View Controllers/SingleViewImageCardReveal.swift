//
//  SingleViewImageCardReveal.swift
//  Opth
//
//  Created by Cathy Hsieh on 5/15/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

import Foundation
import SwiftRichString

import UIKit

class singleViewimageTapGesture: UITapGestureRecognizer{
    var imageIndex = 0
}

class SingleViewImageCardReveal: UIViewController, UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching, UIScrollViewDelegate {
    
    @IBOutlet weak var cardTitle: UILabel!
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var imagePageController: UIPageControl!
    @IBOutlet weak var downIndicator: UIImageView!
    @IBOutlet weak var subtopicTableView: SubtopicTableView!
    @IBOutlet weak var addNotes: UIButton!
    
    var imageIndex = 0
    var isBackFromFullScreen = false
    var buttonsVisible:Bool = false
    var isFromSearch = false

    @IBAction func backButton(_ sender: Any) {
        if isFromSearch{
            dismiss(animated: true, completion: nil)
        }
        else{
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    var index = 0
    var indexMax = 0
    var showInfo = false
    let tap = UITapGestureRecognizer()
    var subtopic: Subtopic!
    var imageCount = 0
    
    //Make the top bar with the time to be white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subtopicTableView.prefetchDataSource = self
        
        downIndicator.loadGif(name: "downArrow")
        downIndicator.isHidden = false
        
        subtopicTableView.rowHeight = UITableView.automaticDimension
        let tap = UITapGestureRecognizer(target: self, action: #selector(CardRevealViewController.handleTap(_:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        subtopicTableView.addGestureRecognizer(tap)
        subtopicTableView.isUserInteractionEnabled = true
        indexMax = subtopic.cards.count
        
        cardTitle.text = subtopic.subtopicName
        
        //UI image
        imageScrollView.delegate = self
        
        // set image count
        imageCount = subtopic.img_list.count
        
        // set page indicator count
        imagePageController.numberOfPages = imageCount
        
        // loop through the images for the specific subtopic and display
        for i in 0..<imageCount{
            let imageView = UIImageView()
            imageView.isUserInteractionEnabled = true  //enable tap on image
            var img = subtopic.img_list[i] // get the image list
            
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
            let imageTap = singleViewimageTapGesture(target: self,action:#selector(imageTapped))
            imageTap.imageIndex = i
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(imageTap)
            self.imageScrollView.addSubview(imageView)
            
//            //add caption for each image
//            if subtopic.img_caption[0] != "nil"{
//                let caption = UILabel(frame: CGRect.init(origin: CGPoint.init(x:0,y:self.imageScrollView.frame.height - 62), size: CGSize.init(width:self.view.frame.width,height:50)))
//                caption.text = subtopic.img_caption[i]
//                caption.textColor = UIColor.white
//                caption.font = UIFont.systemFont(ofSize: 14.0)
//                caption.numberOfLines = 1
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setScrollIndicatorColor(color: UIColor.white)
        DispatchQueue.main.asyncAfter(deadline: (.now() + .milliseconds(500))){
            self.subtopicTableView.flashScrollIndicators()
        }
        navigationController?.navigationBar.barStyle = .black
    }
    
    func setScrollIndicatorColor(color:UIColor) {
        for view in self.subtopicTableView.subviews {
            if view.isKind(of: UIImageView.self),
                let imageView = view as? UIImageView,
                let _ = imageView.image {
                imageView.image = nil
                view.backgroundColor = color
            }
        }
        self.subtopicTableView.flashScrollIndicators()
    }
    
    // Return the number of rows for the table.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subtopic.cards.count
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
        
        // fill cell contents
        if(indexPath.row < subtopic.cards.count){
            let str = subtopic.cards[indexPath.row].header
            let str2 = subtopic.cards[indexPath.row].info
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
    
    // tap recognizer for image
    @objc func imageTapped(sender:singleViewimageTapGesture) {
        let index = sender.imageIndex
        imageIndex = index
        performSegue(withIdentifier: "fullImage", sender: self)
    }
    
    // segue from image to full screen image
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "fullImage"){
            let image = segue.destination as! FullScreenImageViewController
            image.subtopic = subtopic
            image.imageName = subtopic.img_list[imageIndex]
        }
        if (segue.identifier == "addNotes") {
            let navigationController = segue.destination as? UINavigationController
            let destinationViewController = navigationController?.viewControllers.first as? NotesViewController
            destinationViewController?.subtopic = subtopic.subtopicName
        }
    }
    
    // prefetch table view
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        print(indexPaths)
    }
}
