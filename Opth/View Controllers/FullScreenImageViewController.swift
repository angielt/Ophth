//
//  FullScreenImageViewController.swift
//  Opth
//
//  Created by Cathy Hsieh on 4/27/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

import UIKit

class FullScreenImageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    var imageName = ""
    var subtopic: Subtopic!
    var imageView = UIImageView()
    var imgCell: ImageCollectionViewCell!
    var viewDidLayoutSubviewsForTheFirstTime = true
    
    //Make the top bar with the time to be white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
    
    // start at specific index according to user's choice
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Make sure this is the first time, else return
        guard viewDidLayoutSubviewsForTheFirstTime == true else {return}
        viewDidLayoutSubviewsForTheFirstTime = false
        
        // Create the layout
        var index = 0
        for i in subtopic.img_list{
            if i == imageName{
                self.collectionView.scrollToItem(at:IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: false)
            }
            index += 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // add gesture recognizer
        let imageTap = UITapGestureRecognizer(target: self,action:#selector(FullScreenImageViewController.imageTapped(_:)))
        collectionView.isUserInteractionEnabled = true
        collectionView.addGestureRecognizer(imageTap)
        
//        self.collectionView.minimumZoomScale = 1.0
//        self.collectionView.maximumZoomScale = 6.0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subtopic.img_list.count
    }
    
    // display the cell contents
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
        
        cell.image.image = UIImage(named: subtopic.img_list[indexPath.item])
        imageView = cell.image
        print(imageView.image)
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
    
    // set size of collection view cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    // tap anywhere to dismiss the image
    @objc func imageTapped(_ sender:UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
