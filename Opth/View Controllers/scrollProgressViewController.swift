//
//  scrollProgressViewController.swift
//  Opth
//
//  Created by Cathy Hsieh on 5/22/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

import UIKit

class scrollProgressViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var slideScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    // so that we can see the time on the phone and stuff clearly (status bar), makes it white
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slideScrollView.delegate = self
        let slides:[slide] = createSlides()
        setupSlideScrollView(slides: slides)
        view.backgroundColor = UIColor.backgroundColor
    }
    
    // creates slide here where progress circle is called and shows up
    func createSlides() -> [slide] {
        let slide1:slide = Bundle.main.loadNibNamed("slide", owner: self, options: nil)?.first as! slide
        slide1.setupNotificationObservers()
        slide1.setupCircleLayers()
        slide1.setupPercentageLabel()
        slide1.accumulatesProgress()
        
        return [slide1]
    }
    
    
    // Set up the frame and size of the slides
    func setupSlideScrollView(slides:[slide]) {
        slideScrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: slideScrollView.frame.height)
        slideScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: slideScrollView.frame.height)
        
        slideScrollView.isPagingEnabled = true
        for i in 0..<slides.count{
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: slideScrollView.frame.height)
            slideScrollView.addSubview(slides[i])
        }
        
    }
    
    // for page controller index
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }

}
