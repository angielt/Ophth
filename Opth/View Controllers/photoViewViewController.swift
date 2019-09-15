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
    var recycledPages: Set<ImageScrollView> = []
    var visiblePages: Set<ImageScrollView> = []

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
        self.pagingScrollView.delegate = self
        self.view.addSubview(self.pagingScrollView)
        
        self.tilePages()
        
        // add gesture recognizer
        let imageTap = UITapGestureRecognizer(target: self,action:#selector(photoViewViewController.imageTapped(_:)))
        pagingScrollView.isUserInteractionEnabled = true
        pagingScrollView.addGestureRecognizer(imageTap)
    }
    
    //MARK: - Tiling and page configuration
    func tilePages() {
        //1.  Calculate which pages should now be visible
        let visibleBounds = pagingScrollView.bounds
        
        var firstNeededPageIndex: Int = Int(floor(visibleBounds.minX/visibleBounds.width))
        var lastNeededPageIndex: Int = Int(floor((visibleBounds.maxX - 1)/visibleBounds.width))
        firstNeededPageIndex = max(firstNeededPageIndex, 0)
        lastNeededPageIndex = min(lastNeededPageIndex, self.imageArray.count - 1)
        
        
        //2. Recycle no longer needs pages
        for page in self.visiblePages {
            if ((page.index < firstNeededPageIndex) || (page.index > lastNeededPageIndex)) {
                self.recycledPages.insert(page)
                page.removeFromSuperview()
            }
        }
        self.visiblePages.subtract(self.recycledPages)
        
        
        //3. Add missing pages
        for index in firstNeededPageIndex...lastNeededPageIndex {
            if !self.isDisplayingPage(forIndex: index) {
                
                let page = self.dequeueRecycledPage() ?? ImageScrollView()
                self.configure(page, for: index)
                self.pagingScrollView.addSubview(page)
                self.visiblePages.insert(page)
            }
        }
    }
    
    
    
    func dequeueRecycledPage() -> ImageScrollView? {
        if let page = self.recycledPages.first {
            self.recycledPages.remove(page)
            return page
        }
        return nil
    }
    
    
    func isDisplayingPage(forIndex index: Int) -> Bool {
        for page in self.visiblePages {
            if page.index == index {
                return true
            }
        }
        return false
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
        page.index = index
        page.frame = self.frameForPage(at: index)
        page.display(self.image[index])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.tilePages()
    }
    
    // tap anywhere to dismiss the image
    @objc func imageTapped(_ sender:UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}

