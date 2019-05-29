//
//  slide.swift
//  Opth
//
//  Created by Cathy Hsieh on 5/22/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

import UIKit

class slide: UIView, UIScrollViewDelegate {

    @IBOutlet weak var label: UILabel!
    var indicator = ""
    var shapeLayer: CAShapeLayer!
    // create pulsating layer
    var pulsatingLayer: CAShapeLayer!
    
    // how the percentage label looks
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    // next 2 functions fix bug in xcode where the animation is gone if you exit to home screen and then come back
    func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func handleEnterForeground() {
        animatePulsatingLayer()
    }
    
    // create a template for layer formats
    func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
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
        layer.position = CGPoint(x: self.frame.width/1.8, y: self.frame.height/1.4)
        return layer
    }
    
    // add percentage to the view inside the circle (format)
    func setupPercentageLabel() {
        // add percentage to the view inside the circle (format)
        addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.center = CGPoint(x: self.frame.width/1.8, y: self.frame.height/1.4) // can use auto layout
        
    }
    
    // makes the layers and circle inside the view
    func setupCircleLayers() {
        // make pulsating layer behind the track layer
        pulsatingLayer = createCircleShapeLayer(strokeColor: .clear, fillColor: UIColor.pulsatingFillColor)
        layer.addSublayer(pulsatingLayer)
        animatePulsatingLayer()
        
        // create track layer (the rim that the shapeLayer fills)
        let trackLayer = createCircleShapeLayer(strokeColor: .trackStrokeColor, fillColor: .backgroundColor)
        layer.addSublayer(trackLayer)
        
        // the line running outside the circle when you click it
        shapeLayer = createCircleShapeLayer(strokeColor: .outlineStrokeColor, fillColor: .clear)
        // rotates the circle 90 degrees above the z-axis so we start at 12:00 position and not 3:00 position
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        // this gets rid of the shapeLayer so it doesn't show up initially and only during animation
        shapeLayer.strokeEnd = 0
        layer.addSublayer(shapeLayer)
    }
    
    // animate pulsating layer
    func animatePulsatingLayer() {
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
    
    func accumulatesProgress() {
        // this is so we start at the 12:00 position
        shapeLayer.strokeEnd = 0
        
        //Subtopic
        if indicator == "subtopic"{
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
                self.percentageLabel.text = "\(Int(doneReviewingSubtopics.count)) / \(Int(totalSubtopics.count))" + "\n" + "Cards"
                self.percentageLabel.numberOfLines = 2
                self.shapeLayer.strokeEnd = percentage
            }
        }
        else if indicator == "topic"{
            
        }
        else if indicator == "category"{
            
        }
    }
}
