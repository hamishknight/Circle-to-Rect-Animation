//
//  ViewController2.swift
//  Circle to Rect Animation
//
//  Created by Hamish Knight on 28/01/2016.
//  Copyright © 2016 Redonkulous Apps. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {

    
    let animLayer = CALayer() // the layer that is going to be animated
    let cornerRadiusAnim = CABasicAnimation(keyPath: "cornerRadius") // the corner radius reducing animation
    let widthAnim = CABasicAnimation(keyPath: "bounds.size.width") // the width animation
    let groupAnim = CAAnimationGroup() // the combination of the corner and width animation
    let animDuration = NSTimeInterval(1.0) // the duration of one 'segment' of the animation
    let layerSize = CGFloat(100) // the width & height of the layer (when it's a square)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        let rect = view.frame
        
        animLayer.backgroundColor = UIColor.blueColor().CGColor // color of the layer, feel free to change
        animLayer.frame = CGRect(x: rect.width-layerSize*0.5, y: rect.height-layerSize*0.5, width: layerSize, height: layerSize)
        animLayer.cornerRadius = layerSize*0.5;
        animLayer.anchorPoint = CGPoint(x: 1, y: 1) // sets so that when the width is changed, it goes to the left
        view.layer.addSublayer(animLayer)
        
        // decreases the corner radius
        cornerRadiusAnim.duration = animDuration
        cornerRadiusAnim.fromValue = animLayer.cornerRadius
        cornerRadiusAnim.toValue = 0;
        cornerRadiusAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut) // timing function to make it look nice
        
        // increases the width, and autoreverses on completion
        widthAnim.duration = animDuration
        widthAnim.fromValue = animLayer.frame.size.width
        widthAnim.toValue = rect.size.width
        widthAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut) // timing function to make it look nice
        
        // adds both animations to a group animation
        groupAnim.animations = [cornerRadiusAnim, widthAnim]
        groupAnim.duration = animDuration;
        groupAnim.autoreverses = true; // auto-reverses the animation once completed
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        animLayer.addAnimation(groupAnim, forKey: "anims") // runs both animations concurrently
    }


}
