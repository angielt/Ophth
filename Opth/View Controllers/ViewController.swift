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
    
    @IBOutlet weak var cardFront: UILabel!
    @IBOutlet weak var card: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        //parse.csv(data:"/Users/cathyhsieh/Documents/GitHub/Opth/Opth/Information/biggerdata.txt")
        //parse.csv(data: "/Users/Angie/Desktop/test/biggerdata.txt")
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
            self.dismiss(animated: true, completion: nil) // possible callback to clear spaced rep stuff
        }
        
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cardRevealVC") as UIViewController
        self.loadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if(spacedRep.curReviewIndex < spacedRep.reviewList.count ){
                self.present(viewController, animated: true, completion: nil)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if(spacedRep.curReviewIndex < spacedRep.reviewList.count){
                    spacedRep.curReviewIndex = spacedRep.curReviewIndex + 1
//                    print("spaced rep index" + String(spacedRep.curReviewIndex) + String(spacedRep.reviewList[spacedRep.curReviewIndex].subtopicName))
                    self.loadData() // loads data for next card
                }
                
            }
            
        }
        //self.present(viewController, animated: true, completion: nil)
        // performSegue(withIdentifier: "reveal", sender: nil)
    }
    
//    @IBAction func handleTap(_ sender: Any) {
//        if(spacedRep.curReviewIndex == spacedRep.reviewList.count){
//            if(spacedRep.finished == true){
//                self.dismiss(animated: true, completion: nil) // possible callback to clear spaced rep stuff
//            }
//            else{
//                 spacedRep.generateReviewList(subtopics: spacedRep.subtopics)
//            }
//        }
//
//        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cardRevealVC") as UIViewController
//        self.loadData()
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//         self.present(viewController, animated: true, completion: nil)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                print("current index" + String(spacedRep.curReviewIndex))
//                if(spacedRep.curReviewIndex < spacedRep.reviewList.count){
//                    if(spacedRep.curReviewIndex+1 == spacedRep.reviewList.count && spacedRep.isReviewFinished() == true){ // last card
//                        print("exit")
//                        self.exitCardChange()
//                    }
//                    else{
//                        print("load")
//                        spacedRep.curReviewIndex = spacedRep.curReviewIndex + 1
//                        self.loadData()
//                    }
//                       // spacedRep.curReviewIndex = spacedRep.curReviewIndex + 1
//                }
//            }
//        }
//        //self.present(viewController, animated: true, completion: nil)
//       // performSegue(withIdentifier: "reveal", sender: nil)
//    }
    
    // segue to card reveal VC
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "reveal",
//            let destinationViewController = segue.destination as? CardRevealViewController {
//            destinationViewController.transitioningDelegate = self
//            // delay changes to current VC until after  flip animation
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            if(spacedRep.curReviewIndex < spacedRep.reviewList.count){
//                spacedRep.curReviewIndex = spacedRep.curReviewIndex + 1
//                self.loadData()
//            }
//        }
//    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            return FlipPresentAnimationController(originFrame: card.frame)
    }
}
