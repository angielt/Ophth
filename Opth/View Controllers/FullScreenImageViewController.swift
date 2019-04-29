//
//  FullScreenImageViewController.swift
//  Opth
//
//  Created by Cathy Hsieh on 4/27/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

import UIKit

class FullScreenImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var fullImage:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = fullImage
        
        let imageTap = UITapGestureRecognizer(target: self,action:#selector(FullScreenImageViewController.imageTapped(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(imageTap)
    }
    
    // tap anywhere to go back
    @objc func imageTapped(_ sender:UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
