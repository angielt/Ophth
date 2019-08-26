//
//  photoViewViewController.swift
//  Opth
//
//  Created by Wai Tong on 8/25/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

import UIKit

class photoViewViewController: UIViewController {
    
    let pagePadding: CGFloat = 10
    var pagingScrollView: UIScrollView!
    var image = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image = [#imageLiteral(resourceName: "241_Retinoschisis_AdultRetinoschisis_2"), #imageLiteral(resourceName: "203_MacularHoles_IdiopathicMacularHole_1"), #imageLiteral(resourceName: "224_FEVR_2"), #imageLiteral(resourceName: "264_OtherPigmentedLesions_CHRPE_2")]
        
        let pagingScrollViewFrame = self.frameForPagingScrollView()
        self.pagingScrollView = UIScrollView(frame: pagingScrollViewFrame)
        
        self.view.backgroundColor = UIColor.black
        self.pagingScrollView.backgroundColor = UIColor.black
        self.pagingScrollView.showsVerticalScrollIndicator = false
        self.pagingScrollView.showsHorizontalScrollIndicator = false
        self.pagingScrollView.isPagingEnabled = true
        self.pagingScrollView.contentSize = self.contentSizeForPagingScrollView()
        self.view.addSubview(self.pagingScrollView)
        
        for index in 0..<self.image.count {
            let page = ImageScrollView()
            self.configure(page, for: index)
            self.pagingScrollView.addSubview(page)
        }
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
        return CGSize(width: bounds.size.width*CGFloat(self.image.count), height: bounds.size.height)
    }
    
    func configure(_ page: ImageScrollView, for index: Int) {
        page.frame = self.frameForPage(at: index)
        page.display(self.image[index])
    }
}
