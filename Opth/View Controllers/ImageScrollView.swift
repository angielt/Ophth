//
//  ImageScrollView.swift
//  Opth
//
//  Created by Wai Tong on 8/25/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

import UIKit

class ImageScrollView: UIScrollView, UIScrollViewDelegate {
    
    var zoomView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.decelerationRate = UIScrollView.DecelerationRate.fast
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.centerImage()
        
    }
    
    //MARK: - Configure scrollView to display new image
    func display(_ image: UIImage) {
        
        //1. clear the previous image
        zoomView?.removeFromSuperview()
        zoomView = nil
        
        //2. make a new UIImageView for the new image
        zoomView = UIImageView(image: image)
        self.configureFor(image.size)
        self.addSubview(zoomView)
        
    }
    
    func configureFor(_ imageSize: CGSize) {
        self.contentSize = imageSize
        self.setMaxMinZoomScaleForCurrentBounds()
        self.zoomScale = self.minimumZoomScale
    }
    
    func setMaxMinZoomScaleForCurrentBounds() {
        let boundsSize = self.bounds.size
        let imageSize = zoomView.bounds.size
        
        //1. calculate minimumZoomscale
        let xScale =  boundsSize.width  / imageSize.width    // the scale needed to perfectly fit the image width-wise
        let yScale = boundsSize.height / imageSize.height  // the scale needed to perfectly fit the image height-wise
        let minScale = min(xScale, yScale)                 // use minimum of these to allow the image to become fully visible
        
        //2. calculate maximumZoomscale
        var maxScale: CGFloat = 1.0
        if minScale < 0.1 {
            maxScale = 0.3
        }
        if minScale >= 0.1 && minScale < 0.5 {
            maxScale = 0.7
        }
        if minScale >= 0.5 {
            maxScale = max(1.0, minScale)
        }
        
        self.maximumZoomScale = maxScale
        self.minimumZoomScale = minScale
    }
    
    //MARK: - UIScrollView Delegate Methods
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.zoomView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.centerImage()
    }
    
    func centerImage() {
        
        // center the zoom view as it becomes smaller than the size of the screen
        let boundsSize = self.bounds.size
        var frameToCenter = zoomView?.frame ?? CGRect.zero
        
        // center horizontally
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width)/2
        }
        else {
            frameToCenter.origin.x = 0
        }
        
        // center vertically
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height)/2
        }
        else {
            frameToCenter.origin.y = 0
        }
        
        zoomView?.frame = frameToCenter
    }
}
