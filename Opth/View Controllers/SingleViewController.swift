//
//  SingleViewController.swift
//  Opth
//
//  Created by Cathy Hsieh on 5/8/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

import UIKit

class SingleViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
//    static let cardCornerRadius: CGFloat = 25

    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        self.reloadInputViews()
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
//    @IBOutlet weak var cardFront: UILabel!
//    @IBOutlet weak var card: UIView!
    
    var subtopic: Subtopic!
    var topic: Topic!
    var index = 0
    
    //Make the top bar with the time to be white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func viewDidLayoutSubviews() {
        var index = 0
        for i in topic.subtopics{
            if i.subtopicName == subtopic.subtopicName{
                self.collectionView.scrollToItem(at:IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: false)
            }
            index += 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.loadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topic.subtopics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SVcellCollectionViewCell
        
        cell.label?.text = topic.subtopics[indexPath.item].subtopicName
        
        return cell
    }
    
    // row padding
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // column padding
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        var index = 0
//        for i in topic.subtopics{
//            if i.subtopicName == subtopic.subtopicName{
//                self.collectionView.scrollToItem(at:IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: false)
//            }
//            index += 1
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        index = indexPath.item
        if topic.subtopics[indexPath.item].img_list[0] == "nil" {
            performSegue(withIdentifier: "singleViewReveal", sender: nil)
        }
        else {
            performSegue(withIdentifier: "singleViewImageReveal", sender: nil)
        }
    }
    
    
    
//    func loadData(){
//
//        cardFront.text = subtopic.subtopicName
//
//        card.layer.cornerRadius = 4.0
//        card.layer.borderWidth = 1.0
//        card.layer.borderColor = UIColor.clear.cgColor
//        card.layer.masksToBounds = false
//        card.layer.shadowColor = UIColor.gray.cgColor
//        card.layer.shadowOffset = CGSize(width: 0, height: 1.0)
//        card.layer.shadowRadius = 4.0
//        card.layer.shadowOpacity = 1.0
//        card.layer.masksToBounds = false
//        card.layer.shadowPath = UIBezierPath(roundedRect: card.bounds, cornerRadius: card.layer.cornerRadius).cgPath
//
//    }
    
//    @IBAction func handleTap(_ sender: Any) {
//        if subtopic.img_list[0] == "nil" {
//            performSegue(withIdentifier: "singleViewReveal", sender: nil)
//        }
//        else {
//            performSegue(withIdentifier: "singleViewImageReveal", sender: nil)
//        }
//    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "singleViewReveal",
            let destinationViewController = segue.destination as? SingleViewCardReveal {
//            destinationViewController.transitioningDelegate = self
            destinationViewController.subtopic = topic.subtopics[index]
            // delay changes to current VC until after  flip animation
        }
        else if segue.identifier == "singleViewImageReveal",
            let destinationViewController = segue.destination as? SingleViewImageCardReveal {
//            destinationViewController.transitioningDelegate = self
            destinationViewController.subtopic = topic.subtopics[index]
            // delay changes to current VC until after  flip animation
        }
    }
}

//extension SingleViewController: UIViewControllerTransitioningDelegate {
//    func animationController(forPresented presented: UIViewController,
//                             presenting: UIViewController,
//                             source: UIViewController)
//        -> UIViewControllerAnimatedTransitioning? {
//            return FlipPresentAnimationController(originFrame: card.frame)
//    }
//}

