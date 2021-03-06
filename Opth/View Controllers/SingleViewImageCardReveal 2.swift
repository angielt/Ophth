//
//  SingleViewImageCardReveal.swift
//  Opth
//
//  Created by Cathy Hsieh on 5/15/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

import Foundation

import UIKit

class singleViewimageTapGesture: UITapGestureRecognizer{
    var imageIndex = 0
}

class SingleViewImageCardReveal: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    
    
    @IBOutlet weak var cardTitle: UILabel!
    @IBOutlet weak var easyButton: UIButton!
    @IBOutlet weak var unsureButton: UIButton!
    @IBOutlet weak var hardButton: UIButton!
 
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var imagePageController: UIPageControl!
    
    var imageIndex = 0
    var isBackFromFullScreen = false
    var buttonsVisible:Bool = false
    
    @IBOutlet weak var subtopicTableView: SubtopicTableView!
    @IBOutlet weak var addNotes: UIButton!
    
    var index = 0
    var indexMax = 0
    var showInfo = false
    let tap = UITapGestureRecognizer()
    var subtopic: Subtopic!
    var imageCount = 0
    
    //Buttons
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func easyOnClick(_ sender: Any) {
        if(buttonsVisible == true){
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func unsureOnClick(_ sender: Any) {
        if(buttonsVisible == true){
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func hardOnClick(_ sender: Any) {
        if(buttonsVisible == true){
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
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
        indexMax = subtopic.cards.count
        
        cardTitle.text = subtopic.subtopicName
        
        //UI image start from here
        imageScrollView.delegate = self
        
        imageCount = subtopic.img_list.count
        
        imagePageController.numberOfPages = imageCount
        
        for i in 0..<imageCount{
            let imageView = UIImageView()
            imageView.isUserInteractionEnabled = true  //enable tap on image
            var img = subtopic.img_list[i]
            if (img.contains(".gif")){
                img = img.replacingOccurrences(of: ".gif", with: "")
                imageView.loadGif(name: img)
            }
            else{
                imageView.image = UIImage(named: img)
            }
            
            //set the size and position of the image frame and image
            imageView.contentMode = .scaleAspectFit
            let xCordinate = self.view.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xCordinate + 30, y: 0, width: self.imageScrollView.frame.width - 20, height: self.imageScrollView.frame.height - 70)
            self.imageScrollView.contentSize.width = self.view.frame.width * CGFloat(i + 1)
            
            //add tap recognizer for image
            let imageTap = singleViewimageTapGesture(target: self,action:#selector(imageTapped))
            imageTap.imageIndex = i
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(imageTap)
            self.imageScrollView.addSubview(imageView)
            
            //add caption for each image
            if subtopic.img_caption[0] != "nil"{
                let caption = UILabel(frame: CGRect.init(origin: CGPoint.init(x:0,y:self.imageScrollView.frame.height - 62), size: CGSize.init(width:self.view.frame.width - 20,height:50)))
                caption.text = subtopic.img_caption[i]
                caption.textColor = UIColor.white
                caption.font = UIFont.systemFont(ofSize: 14.0)
                caption.numberOfLines = 3
                caption.lineBreakMode = .byWordWrapping
                caption.sizeToFit()
                let captionLocation = self.imageScrollView.center.x + 20
                
                //set the position of the caption
                if i == 0{
                    caption.center.x = captionLocation
                }
                else{
                    caption.center.x = captionLocation + self.view.frame.width * CGFloat(i)
                }
                self.imageScrollView.addSubview(caption)
            }
        }
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
        
        
        // fill cell contents
        if(indexPath.row < subtopic.cards.count){
            cell.Header.text = subtopic.cards[indexPath.row].header
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
        //print("tap")
        
        let visibleIndexPaths = subtopicTableView.indexPathsForVisibleRows
        //print(visibleIndexPaths)
        //print("index ",index)
        
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
                //print("-----")
                //print(index)
                //print((subtopic.cards.count)-1)
                if(index != subtopic.cards.count-1){
                    //print("true")
                    index = index+1
                }
            }
            else if(showInfo == true){
                //print(":::::")
                //print("index ",index)
                //print((subtopic.cards.count)-1)
                showInfo = false
                cell.Header.textColor = UIColor.cyan
            }
            if(index == subtopic.cards.count-1){
                buttonsVisible = true
                self.showButtons()
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
            image.fullImage = UIImage(named: subtopic.img_list[imageIndex])
        }
        if (segue.identifier == "addNotes") {
            let navigationController = segue.destination as? UINavigationController
            let destinationViewController = navigationController?.viewControllers.first as? NotesViewController
            destinationViewController?.subtopic = subtopic.subtopicName
        }
    }
}
