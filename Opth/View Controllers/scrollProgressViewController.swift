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
    
    // so that we can see the time on the phone and stuff clearly (status bar)
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //status.progressVC = self
        slideScrollView.delegate = self
        let slides:[slide] = createSlides()
        setupSlideScrollView(slides: slides)
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
        view.backgroundColor = UIColor.backgroundColor
    }
    
    // create slides here (put progress circle here)
    func createSlides() -> [slide] {
        let slide1:slide = Bundle.main.loadNibNamed("slide", owner: self, options: nil)?.first as! slide
        slide1.label.text = "Subtopic Progress"
        slide1.indicator = "subtopic"
        slide1.setupNotificationObservers()
        slide1.setupCircleLayers()
        slide1.setupPercentageLabel()
        slide1.accumulatesProgress()
        
        let slide2:slide = Bundle.main.loadNibNamed("slide", owner: self, options: nil)?.first as! slide
        slide2.label.text = "Topic Progress"
        slide2.indicator = "topic"
        slide2.setupNotificationObservers()
        slide2.setupCircleLayers()
        slide2.setupPercentageLabel()
        slide2.accumulatesProgress()
        
        let slide3:slide = Bundle.main.loadNibNamed("slide", owner: self, options: nil)?.first as! slide
        slide3.label.text = "Category Progress"
        slide3.indicator = "category"
        slide3.setupNotificationObservers()
        slide3.setupCircleLayers()
        slide3.setupPercentageLabel()
        slide3.accumulatesProgress()
        return [slide1, slide2, slide3]
    }
    
    
    // Set up the frame and size of the slides (prob don't need to edit this function)
    func setupSlideScrollView(slides:[slide]) {
        slideScrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: slideScrollView.frame.height)
        slideScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: slideScrollView.frame.height)
        
        slideScrollView.isPagingEnabled = true
        for i in 0..<slides.count{
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: slideScrollView.frame.height)
            slideScrollView.addSubview(slides[i])
        }
        
    }
    
    // for page controller index (prob don't need to edit this function)
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }

}
