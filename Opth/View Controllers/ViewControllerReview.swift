//
//  ViewControllerReview.swift
//  Opth
//
//  Created by Angie Ta on 5/12/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//


import UIKit

// view controller of card front for Shuffle All
class ViewControllerReview: UIViewController{
    
    static let cardCornerRadius: CGFloat = 25
    
    @IBOutlet weak var cardFront: UILabel!
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tapCardLabel: UILabel!
    
    var backButtonPressed = false;
    
    @IBAction func backButton(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
        self.tabBarController?.tabBar.isHidden = false
        
        
        if(spacedRep.all_active == true){// already shuffled all, now exited back to TableofContents
            if(spacedRep.all_subtopics.count != 0){
                spacedRep.all_curReviewIndex = spacedRep.curReviewIndex // store where user left off in shuffle all
                spacedRep.all_active = false
            }
            spacedRep.clear()
        }
    }
    
    
    //Make the top bar with the time to be white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
        self.loadData()
    }
    
    
    
    override func viewDidLoad() {
        if(spacedRep.all_subtopics.count == 0){
            spacedRep.setReviewTopics(category_list: &status.CategoryList)
            spacedRep.curReviewIndex = 0
        }
        else if(spacedRep.all_curReviewIndex != 0){
            spacedRep.curReviewIndex = spacedRep.all_curReviewIndex 
        }
        spacedRep.all_active = true
        
        // handle if all subtopics reviewed already
        self.loadData()
        
    }
    
    func loadData(){
        if self.tabBarController?.tabBar.isHidden == false {
            backButton.isHidden = true
            tapCardLabel.isHidden = false
        }
        else {
            backButton.isHidden = false
            tapCardLabel.isHidden = true
        }
        
        if(spacedRep.curReviewIndex < spacedRep.reviewList.count){
            cardFront.text = spacedRep.reviewList[spacedRep.curReviewIndex].subtopicName
            
            card.layer.cornerRadius = 4.0
            card.layer.borderWidth = 1.0
            card.layer.borderColor = UIColor.clear.cgColor
            card.layer.masksToBounds = false
            card.layer.shadowColor = UIColor.gray.cgColor
            card.layer.shadowOffset = CGSize(width: 0, height: 1.0)
            card.layer.shadowRadius = 4.0
            card.layer.shadowOpacity = 1.0
            card.layer.masksToBounds = false
            card.layer.shadowPath = UIBezierPath(roundedRect: card.bounds, cornerRadius: card.layer.cornerRadius).cgPath
        }
    }
    
    func exitCardChange(){
        card.layer.backgroundColor = UIColor.black.cgColor
        cardFront.text = "Review Finished - Tap to Exit"
        cardFront.textColor = UIColor.gray
    }
    
    func newListCardChange(){
        cardFront.text = spacedRep.reviewList[spacedRep.curReviewIndex].subtopicName
    }
    
    @IBAction func handleTap(_ sender: Any) {
        if(spacedRep.all_subtopics.count == 0){

            spacedRep.setReviewTopics(category_list: &status.CategoryList)
            spacedRep.curReviewIndex = 0
        }
        if(spacedRep.finished == true){
            spacedRep.finished = false
            self.dismiss(animated: true, completion: {spacedRep.VCreference?.dismiss(animated: true, completion: nil)}) // possible callback to clear spaced rep stuff
        }
        else if (spacedRep.reviewList[spacedRep.curReviewIndex].img_list.isEmpty){
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cardRevealVC") as UIViewController
            viewController.modalTransitionStyle = .flipHorizontal
            self.loadData()
        }
        else {
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "imageCardRevealVC") as UIViewController
            viewController.modalTransitionStyle = .flipHorizontal
            self.loadData()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            if(spacedRep.curReviewIndex < spacedRep.reviewList.count ){
                if (spacedRep.reviewList[spacedRep.curReviewIndex].img_list[0] == "nil") {
                    self.performSegue(withIdentifier: "SRCardReveal", sender: nil)
                }
                else {
                    self.performSegue(withIdentifier: "SRCardRevealImage", sender: nil)
                }
                
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if(spacedRep.curReviewIndex < spacedRep.reviewList.count){
                    spacedRep.curReviewIndex = spacedRep.curReviewIndex + 1
                    self.loadData() // loads data for next card
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.tabBarController?.tabBar.isHidden = true
        if segue.identifier == "reveal",
            let destinationViewController = segue.destination as? CardRevealViewController {
            destinationViewController.transitioningDelegate = self
            // delay changes to current VC until after  flip animation
        }
        else if segue.identifier == "revealImage",
            let destinationViewController = segue.destination as? ImageCardRevealViewController {
            destinationViewController.transitioningDelegate = self
            // delay changes to current VC until after  flip animation
        }
    }
}

extension ViewControllerReview: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            return FlipPresentAnimationController(originFrame: card.frame)
    }
}
