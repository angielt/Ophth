//
//  ImageCardRevealViewController.swift
//  Opth
//
//  Created by Cathy Hsieh on 4/28/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

import Foundation

import UIKit

class imageTapGesture: UITapGestureRecognizer{
    var imageIndex = 0
}

class ImageCardRevealViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var imagePageController: UIPageControl!
    
    var imageIndex = 0
    var isBackFromFullScreen = false
    
    @IBOutlet weak var subtopicTableView: SubtopicTableView!
    @IBOutlet weak var addNotes: UIButton!
    
    //count how many taps
    var counter = 0
    var index = 0
    var indexMax = 0
    var showInfo = false
    let tap = UITapGestureRecognizer()
    let currentIndex = status.curReviewIndex
    
    var imageArray = [UIImage]()
    var imageCaption = [String]()
    
    var cards: [Card]?
    var subtopic: String?
    var subIndex = 0
    var topicIndex = 0
    var categoryIndex = 0
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
        
        
        //UI image start from here
        
        //print(status.CategoryList[0].topics[0].subtopics[0].img_list[0])
        
        imageScrollView.delegate = self
        
        /***DON'T NEED image caption WHEN PARSE ***/
        imageCaption = ["caption 0","caption 1", "caption 2", "caption 3", "caption 4"]
        
        imagePageController.numberOfPages = imageArray.count
        
        //UI Image
        for i in 0..<status.CategoryList[currentIndex].topics[currentIndex].subtopics[currentIndex].img_list.count{
            let imageView = UIImageView()
            imageView.isUserInteractionEnabled = true  //enable tap on image
            imageView.image = UIImage(named: status.CategoryList[currentIndex].topics[currentIndex].subtopics[currentIndex].img_list[i])
            
            //set the size and position of the image frame and image
            imageView.contentMode = .scaleAspectFit
            let xCordinate = self.view.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xCordinate + 20, y: 0, width: self.imageScrollView.frame.width, height: self.imageScrollView.frame.height - 30)
            self.imageScrollView.contentSize.width = self.view.frame.width * CGFloat(i + 1)
            
            //add tap recognizer for image
            let imageTap = imageTapGesture(target: self,action:#selector(imageTapped))
            imageTap.imageIndex = i
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(imageTap)
            self.imageScrollView.addSubview(imageView)
            
            //add caption for each image
            let caption = UILabel(frame: CGRect.init(origin: CGPoint.init(x:0,y:self.imageScrollView.frame.height - 20), size: CGSize.init(width:0,height:40)))
            caption.text = imageCaption[i]
            caption.textColor = UIColor.white
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
        print("index: " + String(index))
        print("indexPath: "+String(indexPath.row))
        print("review index: "+String(currentIndex))
        // fetch cell
        if(indexMax < indexPath.row){
            indexMax = indexPath.row
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubtopicInfoCell", for: indexPath) as! SubtopicTableViewCell
        
        // fill cell contents
        if(indexPath.row < cards?.count ?? 1){
            cell.Header.text = cards?[indexPath.row].header
            cell.Info.text = cards?[indexPath.row].info
            
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
    
    // An unwind segue moves backward through one or more segues to return the user to a scene managed by an existing view controller.
    @IBAction func unwindToFlashCardList(sender: UIStoryboardSegue) {
        if sender.source is NotesViewController {
        }
    }
    
    // link the page controller with the image scroll view
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        imagePageController.currentPage = Int(round(imageScrollView.contentOffset.x / imageScrollView.frame.width))
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
            let image = segue.destination as! FullScreenImageViewController
            image.fullImage = UIImage(named: status.CategoryList[currentIndex].topics[currentIndex].subtopics[currentIndex].img_list[imageIndex])
        } else if segue.identifier == "addNotes", let navigationController = segue.destination as? UINavigationController,
            let destinationViewController = navigationController.viewControllers.first as? NotesViewController {
            destinationViewController.subtopic = self.subtopic
        }
    }
}
