//
//  FullScreenImageViewController.swift
//  Opth
//
//  Created by Cathy Hsieh on 4/27/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

import UIKit

class FullScreenImageViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    var fullImage:UIImage!
    
    //Make the top bar with the time to be white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.delegate = self
        
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        
        imageView.image = fullImage
        
        let imageTap = UITapGestureRecognizer(target: self,action:#selector(FullScreenImageViewController.imageTapped(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(imageTap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    // tap anywhere to go back
    @objc func imageTapped(_ sender:UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
