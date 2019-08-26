//
//  ImageScrollViewController.swift
//  Opth
//
//  Created by Wai Tong on 8/25/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

import UIKit

class ImageScrollViewController: UIViewController {

    var imageScrollView: ImageScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1. Initialize imageScrollView and adding it to viewControllers view
        self.imageScrollView = ImageScrollView(frame: self.view.bounds)
        self.view.addSubview(self.imageScrollView)
        
        //2. Making an image from our photo path
        let imagePath = Bundle.main.path(forResource: "testImage1", ofType: "jpg")!
        let image = UIImage(contentsOfFile: imagePath)!
        
        //3. Ask imageScrollView to show image
        self.imageScrollView.display(image)
        
    }
}
