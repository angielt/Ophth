//
//  ViewControllerReview.swift
//  Opth
//
//  Created by Angie Ta on 5/12/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//


import UIKit

// view controller of card front
class ViewControllerReview: UIViewController{
    
    static let cardCornerRadius: CGFloat = 25
    
    @IBOutlet weak var cardFront: UILabel!
    @IBOutlet weak var card: UIView!
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for item in status.CategoryList[0].topics[0].subtopics{
            print(item.repeat_factor)
        }
        self.loadData()
        
      
        
    }
    
    func loadData(){
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
        cardFront.text = "Review Finished - tap to exit"
        cardFront.textColor = UIColor.gray
    }
    
    func newListCardChange(){
        cardFront.text = spacedRep.reviewList[spacedRep.curReviewIndex].subtopicName
    }
    
    @IBAction func handleTap(_ sender: Any) {
        if(spacedRep.finished == true){
            spacedRep.finished = false
            self.dismiss(animated: true, completion: nil) // possible callback to clear spaced rep stuff
        }
            
        else if (spacedRep.reviewList[spacedRep.curReviewIndex].img_list[0] == "nil"){
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
                //self.present(viewController, animated: true, completion: nil)
                if (spacedRep.reviewList[spacedRep.curReviewIndex].img_list[0] == "nil") {
                    self.performSegue(withIdentifier: "reveal", sender: nil)
                }
                else {
                    self.performSegue(withIdentifier: "revealImage", sender: nil)
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
