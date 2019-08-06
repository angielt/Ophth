//
//  FullScreenImageViewController.swift
//  Opth
//
//  Created by Cathy Hsieh on 4/27/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

import UIKit

class FullScreenImageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
//    @IBOutlet var pinch: UIPinchGestureRecognizer!
    
//    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var imageView: UIImageView!
    
//    var fullImage:UIImage!
    var imageName = ""
    var subtopic: Subtopic!
    
    //Make the top bar with the time to be white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func viewDidLayoutSubviews() {
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
        
//        self.scrollView.delegate = self
//
//        // set the max and min of the zoom scale for image
//        self.scrollView.minimumZoomScale = 1.0
//        self.scrollView.maximumZoomScale = 6.0
//
//        imageView.image = fullImage
//
        // add gesture recognizer
        let imageTap = UITapGestureRecognizer(target: self,action:#selector(FullScreenImageViewController.imageTapped(_:)))
        collectionView.isUserInteractionEnabled = true
        collectionView.addGestureRecognizer(imageTap)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(sender:)))
        view.addGestureRecognizer(pinch)
        
//        self.collectionView.minimumZoomScale = 1.0
//        self.collectionView.maximumZoomScale = 6.0
    }
    
    @objc func handlePinch(sender: UIPinchGestureRecognizer) {
        guard sender.view != nil else {return}
        
        if sender.state == .began || sender.state == .changed {
            sender.view?.transform = ((sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale))!)
            sender.scale = 1.0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subtopic.img_list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
        
        cell.image.image = UIImage(named: subtopic.img_list[indexPath.item])
        
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    private func viewForZooming(in scrollView: UICollectionView) -> UIView? {
        return self.collectionView
    }

    // tap anywhere to dismiss the image
    @objc func imageTapped(_ sender:UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
