//
//  CollectionViewController.swift
//  Opth
//
//  Created by Nancy Fong on 7/25/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var cateogryIndex = 0
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let filepath = Bundle.main.path(forResource: "Text_07.13.19", ofType: "txt") {
            parse.csv(data: filepath)
        } else {
            print("data file could not be found")
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return status.CategoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionViewCell
        
        let trimmedCategory = status.CategoryList[indexPath.item].categoryName.replacingOccurrences(of: "\n", with: "")
        cell.label?.text = trimmedCategory
        
        let imageCategory = trimmedCategory.replacingOccurrences(of: "/", with: "")
        cell.image.image = UIImage(named: imageCategory)
        
        return cell
    }
    
    // set size of collection view cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2, height: collectionView.frame.height / 4)
    }
    
    // column padding
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // row padding
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cateogryIndex = indexPath.item
        performSegue(withIdentifier: "topicSeg", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "topicSeg"{
            let destinationVC = segue.destination as? ContentsOfTableViewController
            destinationVC?.category = status.CategoryList[cateogryIndex]
        }
    }
}
