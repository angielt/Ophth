//
//  photoViewViewController.swift
//  Opth
//
//  Created by Wai Tong on 8/25/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

import UIKit

class photoViewViewController: UIViewController, UIScrollViewDelegate {
    
    let pagePadding: CGFloat = 10
    var pagingScrollView: UIScrollView!
    
//    var recycledPages: Set<ImageScrollView> = []
//    var visiblePages: Set<ImageScrollView> = []
//    var firstVisiblePageIndexBeforeRotation: Int!

    var image = [UIImage]()
    var imageArray = [String]()
    var imageIndex = 0
    var viewDidLayoutSubviewsForTheFirstTime = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in imageArray {
            image.append(UIImage(named: i)!)
        }
        
        let pagingScrollViewFrame = self.frameForPagingScrollView()
        self.pagingScrollView = UIScrollView(frame: pagingScrollViewFrame)
        
        self.view.backgroundColor = UIColor.black
        self.pagingScrollView.delegate = self
        self.pagingScrollView.backgroundColor = UIColor.black
        self.pagingScrollView.showsVerticalScrollIndicator = false
        self.pagingScrollView.showsHorizontalScrollIndicator = false
        self.pagingScrollView.isPagingEnabled = true
        self.pagingScrollView.contentSize = self.contentSizeForPagingScrollView()
        self.view.addSubview(self.pagingScrollView)
        
        for index in 0..<self.imageArray.count {
            let page = ImageScrollView()
            self.configure(page, for: index)
            self.pagingScrollView.addSubview(page)
        }
        
        // add gesture recognizer
        let imageTap = UITapGestureRecognizer(target: self,action:#selector(photoViewViewController.imageTapped(_:)))
        pagingScrollView.isUserInteractionEnabled = true
        pagingScrollView.addGestureRecognizer(imageTap)
    }
    
    //MARK: - Frame calculations
    func frameForPagingScrollView() -> CGRect {
        var frame = UIScreen.main.bounds
        frame.origin.x -= pagePadding
        frame.size.width += 2*pagePadding
        return frame
    }
    
    func frameForPage(at index: Int) -> CGRect {
        let bounds = self.pagingScrollView.bounds
        var pageFrame = bounds
        pageFrame.size.width -= 2*pagePadding
        pageFrame.origin.x = (bounds.size.width*CGFloat(index)) + pagePadding
        return pageFrame
    }
    
    func contentSizeForPagingScrollView() -> CGSize {
        let bounds = self.pagingScrollView.bounds
        return CGSize(width: bounds.size.width*CGFloat(self.imageArray.count), height: bounds.size.height)
    }
    
    func configure(_ page: ImageScrollView, for index: Int) {
        page.frame = self.frameForPage(at: index)
        page.display(self.image[index])
    }
    
    // tap anywhere to dismiss the image
    @objc func imageTapped(_ sender:UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
