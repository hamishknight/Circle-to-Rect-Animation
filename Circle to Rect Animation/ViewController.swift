//
//  ViewController.swift
//  Circle to Rect Animation
//
//  Created by Hamish Knight on 27/01/2016.
//  Copyright © 2016 Redonkulous Apps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let animLayer = CALayer() // the layer that is going to be animated
    let cornerRadiusAnim = CABasicAnimation(keyPath: "cornerRadius") // the corner radius reducing animation
    let cornerRadiusUndoAnim = CABasicAnimation(keyPath: "cornerRadius") // the corner radius increasing animation
    let widthAnim = CABasicAnimation(keyPath: "bounds.size.width") // the width animation
    let animDuration = NSTimeInterval(1.0) // the duration of one 'segment' of the animation
    let layerSize = CGFloat(100) // the width & height of the layer (when it's a square)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        cornerRadiusAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn) // timing function to make it look nice

        
        // inverse of the cornerRadiusAnim
        cornerRadiusUndoAnim.duration = animDuration
        cornerRadiusUndoAnim.fromValue = 0;
        cornerRadiusUndoAnim.toValue = animLayer.cornerRadius
        cornerRadiusUndoAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut) // timing function to make it look nice

        
        // increases the width, and autoreverses on completion
        widthAnim.duration = animDuration
        widthAnim.fromValue = animLayer.frame.size.width
        widthAnim.toValue = rect.size.width
        widthAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut) // timing function to make it look nice
        widthAnim.autoreverses = true
        widthAnim.delegate = self // so that we get notified when the width animation finishes
        
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        
        animLayer.addAnimation(cornerRadiusUndoAnim, forKey: "cornerRadiusUndo")
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        animLayer.cornerRadius = layerSize*0.5
        CATransaction.commit()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        widthAnim.beginTime = CACurrentMediaTime()+animDuration // starts after the corner radius anim has finished
        
        animLayer.addAnimation(widthAnim, forKey: "widthAnim")
        animLayer.addAnimation(cornerRadiusAnim, forKey: "cornerRadius")
        
        CATransaction.begin()
        CATransaction.setDisableActions(true) // disables implicit animations
        animLayer.cornerRadius = 0
        CATransaction.commit()
    }
}

