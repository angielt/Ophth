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
    
    var shapeLayer: CAShapeLayer!
    // create pulsating layer
    var pulsatingLayer: CAShapeLayer!
    
    // how the percentage label looks
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "Start"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    // so that we can see the time on the phone and stuff clearly (status bar)
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    // next 2 functions fix bug in xcode where the animation is gone if you exit to home screen and then come back
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc private func handleEnterForeground() {
        animatePulsatingLayer()
    }
    
    // create a template for layer formats
    private func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        // creates the circle
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 20
        // inside of the circle color
        layer.fillColor = fillColor.cgColor
        layer.lineCap = CAShapeLayerLineCap.round
        // puts circle in the center of view instead of .zero origin on top left corner of screen
        layer.position = view.center
        return layer
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        slideScrollView.delegate = self
        let slides:[slide] = createSlides()
        setupSlideScrollView(slides: slides)
        //pageControl.numberOfPages = 3
        //pageControl.currentPage = 0
        //view.bringSubviewToFront(pageControl)
        
        // for progress
        setupNotificationObservers()
        // used the set color in extensions file
        view.backgroundColor = UIColor.backgroundColor
        setupCircleLayers()
        setupPercentageLabel()
        
        accumulatesProgress()
    }
    
    // create slides here (put progress circle here)
    func createSlides() -> [slide] {
        let slide1:slide = Bundle.main.loadNibNamed("slide", owner: self, options: nil)?.first as! slide
        slide1.label.text = "Subtopic Progress"
        
        let slide2:slide = Bundle.main.loadNibNamed("slide", owner: self, options: nil)?.first as! slide
        slide2.label.text = "Topic Progress"
        
        let slide3:slide = Bundle.main.loadNibNamed("slide", owner: self, options: nil)?.first as! slide
        slide3.label.text = ""
        
        return [slide1]
        //return [slide1, slide2, slide3]
    }
    
    
    // add percentage to the view inside the circle (format)
    private func setupPercentageLabel() {
        // add percentage to the view inside the circle (format)
        view.addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.center = view.center // can use auto layout
    }
    
    // makes the layers and circle inside the view
    private func setupCircleLayers() {
        // make pulsating layer behind the track layer
        pulsatingLayer = createCircleShapeLayer(strokeColor: .clear, fillColor: UIColor.pulsatingFillColor)
        view.layer.addSublayer(pulsatingLayer)
        animatePulsatingLayer()
        
        // create track layer (the rim that the shapeLayer fills)
        let trackLayer = createCircleShapeLayer(strokeColor: .trackStrokeColor, fillColor: .backgroundColor)
        view.layer.addSublayer(trackLayer)
        
        // the line running outside the circle when you click it
        shapeLayer = createCircleShapeLayer(strokeColor: .outlineStrokeColor, fillColor: .clear)
        // rotates the circle 90 degrees above the z-axis so we start at 12:00 position and not 3:00 position
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        // this gets rid of the shapeLayer so it doesn't show up initially and only during animation
        shapeLayer.strokeEnd = 0
        view.layer.addSublayer(shapeLayer)
    }
    
    // animate pulsating layer
    private func animatePulsatingLayer() {
        //circle int he back is constantly scaling back and forth
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        //circle is scaled up 1.5
        animation.toValue = 1.5
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        // so it pulsates back forever
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        
        pulsatingLayer.add(animation, forKey: "pulsing")
    }
    
    private func accumulatesProgress() {
        // this is so we start at the 12:00 position
        shapeLayer.strokeEnd = 0
        
        // get data
        var flattenedArray = status.CategoryList.flatMap { category in
            return category.topics.map { topics in
                return topics.subtopics.map {
                    subtopics in
                    return subtopics
                }
            }
        }
        
        var totalSubtopics = flattenedArray.flatMap({$0})
        var doneReviewingSubtopics = totalSubtopics.filter{$0.repeat_factor == 1}
        
       
        //let percentage = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        let percentage = CGFloat(doneReviewingSubtopics.count) / CGFloat(totalSubtopics.count)
        
        // tie the animation to the percentage, so we don't need to run animateCircle() anymore
        DispatchQueue.main.async {
            // changes the percentage of download to show up
            self.percentageLabel.text = "\(Int(doneReviewingSubtopics.count)) / \(Int(totalSubtopics.count))"
            self.shapeLayer.strokeEnd = percentage
        }
        
    }
    
    
    fileprivate func animateCircle() {
        // allows the animation of the shapeLayer appearing around the circle
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        // handles how many seconds the animation takes
        basicAnimation.duration = 2 // in seconds
        // tells the animation not to remove the entire strokeEnd = 1 (shapeLayer stays at the end)
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        // adds the animation to the shapeLayer to appear in the view
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
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
