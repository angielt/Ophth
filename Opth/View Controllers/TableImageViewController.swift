//
//  TableImageViewController.swift
//  Opth
//
//  Created by Cathy Hsieh on 5/18/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

import UIKit

class TableImageViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var cardTitle: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    var tableImage:UIImage!
    
    @IBAction func backButton(_ sender: Any) {
        if spacedRep.all_active{
            dismiss(animated: true, completion: nil)
        }
        else{
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func easyOnClick(_ sender: Any) {
        spacedRep.easyPressed()
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func unsureOnClick(_ sender: Any) {
        spacedRep.easyPressed()
        dismiss(animated: true, completion: nil)
    }
    @IBAction func hardOnClick(_ sender: Any) {
        spacedRep.easyPressed()
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.delegate = self
        
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0

        cardTitle.text = spacedRep.reviewList[spacedRep.curReviewIndex].subtopicName
        
        imageView.image = tableImage
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }

}
