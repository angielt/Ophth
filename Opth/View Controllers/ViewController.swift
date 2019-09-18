//
//  ViewController.swift
//  Opth
//
//  Created by Angie Ta on 2/14/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

import UIKit

// view controller of card front
class ViewController: UIViewController{

    static let cardCornerRadius: CGFloat = 25
    
    var category: Category!
    var categoryCount = 0
    var tempCategoryName = ""

    @IBOutlet weak var cardFront: UILabel!
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func backButton(_ sender: Any) {
        if(spacedRep.all_active == false){// category shuffle, now exited back to TableofContents
            if(spacedRep.curReviewIndex != 0){
                spacedRep.category_curReviewIndex = spacedRep.curReviewIndex // store where user left off in shuffle all
            }
            spacedRep.clear()
        }
        
        dismiss(animated: true, completion: nil)
        self.reloadInputViews()
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
        
        spacedRep.all_active = false
        spacedRep.setReviewCategory(category: &category)
        
        self.loadCard()
        
    }
    
    func loadCard(){
        if spacedRep.curReviewIndex < spacedRep.reviewList.count {
            cardFront.text = spacedRep.reviewList[spacedRep.curReviewIndex].subtopicName
        }
    }
    
    func exitCardChange(){
        card.layer.backgroundColor = UIColor.black.cgColor
        card.layer.borderWidth = 1.0
        card.layer.borderColor = UIColor.gray.cgColor
        cardFront.text = "Review Finished - Tap to Exit"
        cardFront.textColor = UIColor.gray
        backButton.isHidden = true
    }
    
    func newListCardChange(){
       
    }
    
    @IBAction func handleTap(_ sender: Any) {
        var loadData = false

        if(spacedRep.finished == true){
            spacedRep.finished = false
            self.dismiss(animated: true, completion: nil) // possible callback to clear spaced rep stuff
        }
        else if (spacedRep.reviewList[spacedRep.curReviewIndex].img_list[0] == "nil"){
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cardRevealVC") as UIViewController
            viewController.modalTransitionStyle = .flipHorizontal
            self.loadCard()
            loadData = true
        }
        else {
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "imageCardRevealVC") as UIViewController
            viewController.modalTransitionStyle = .flipHorizontal
            self.loadCard()
            loadData = true
        }
        if (loadData == true){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

                if(spacedRep.curReviewIndex < spacedRep.reviewList.count ){
                    if (spacedRep.reviewList[spacedRep.curReviewIndex].img_list[0] == "nil") {
                        self.performSegue(withIdentifier: "reveal", sender: nil)
                    }
                    else {
                        self.performSegue(withIdentifier: "revealImage", sender: nil)
                    }

                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    // condition needs testing for last card
                    if(spacedRep.curReviewIndex < spacedRep.reviewList.count){
                        spacedRep.curReviewIndex = spacedRep.curReviewIndex + 1
                        self.loadCard()
                        if(spacedRep.curReviewIndex == spacedRep.reviewList.count){
                            spacedRep.curReviewIndex = spacedRep.curReviewIndex - 1
                            spacedRep.finished = true
                            self.exitCardChange()
                        }
                    }
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

extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            return FlipPresentAnimationController(originFrame: card.frame)
    }
}
