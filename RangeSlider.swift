//
//  RangeSlider.swift
//  First App
//
//  Created by 周伟 on 16/1/10.
//  Copyright © 2016年 周伟. All rights reserved.
//

import UIKit
import QuartzCore

class RangeSlider: UIControl {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var minmumValue: Double = 0.0{
        didSet{
            updateLayerFrames()
        }
    }
    
    var maxmumValue: Double = 1.0{
        didSet{
            updateLayerFrames()
        }
    }
    
    var lowerValue: Double = 0.2{
        didSet{
            updateLayerFrames()
        }
    }
    
    var upperValue: Double = 0.8{
        didSet{
            updateLayerFrames()
        }
    }
    
    let lowerThumbLayer = RangeSliderThumbLayer()
    let upperThumbLayer = RangeSliderThumbLayer()
    var previousLocation = CGPoint()   //用来跟踪记录用户的触摸位置
    				
    let trackLayer = RangeSliderTrackLayer()
    
    var trackTintColor: UIColor = UIColor(white: 0.9, alpha: 1.0){
        didSet{
            trackLayer.setNeedsDisplay()
        }
    }
    
    var trackHighLightTintColor: UIColor = UIColor(red: 0.00, green: 0.45, blue: 0.94, alpha: 1.00){
        didSet{
            trackLayer.setNeedsDisplay()
        }
    }
    
    var thumbTintColor: UIColor = UIColor.whiteColor(){
        didSet{
            lowerThumbLayer.setNeedsDisplay()
            upperThumbLayer.setNeedsDisplay()
        }
    }
    
    var curvaceousness : CGFloat = 1.0{
        didSet{
            trackLayer.setNeedsDisplay()
            lowerThumbLayer.setNeedsDisplay()
            upperThumbLayer.setNeedsDisplay()
        }
    }
    
    var thumbWidth: CGFloat{
        return CGFloat(bounds.height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        trackLayer.rangeSlider = self
        trackLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(trackLayer)
        
        lowerThumbLayer.rangeSlider = self
        lowerThumbLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(lowerThumbLayer)
        
        upperThumbLayer.rangeSlider = self
        lowerThumbLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(upperThumbLayer)
        
        updateLayerFrames()

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func updateLayerFrames(){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        trackLayer.frame = bounds.insetBy(dx: 0, dy: bounds.height / 3)
        trackLayer.setNeedsDisplay()
        
        let lowerThumbCenter = CGFloat(positionForValue(lowerValue))
        
        lowerThumbLayer.frame = CGRect(x: lowerThumbCenter - thumbWidth / 2.0, y: 0.0, width: thumbWidth, height: thumbWidth)
        lowerThumbLayer.setNeedsDisplay()
        
        let upperThumbCenter = CGFloat(positionForValue(upperValue))
        
        upperThumbLayer.frame = CGRect(x: upperThumbCenter - thumbWidth / 2.0, y: 0.0, width: thumbWidth, height: thumbWidth)
        upperThumbLayer.setNeedsDisplay()
        
        CATransaction.commit()
    }

    func positionForValue(value: Double) -> Double {
        let widthDouble = Double(thumbWidth)
        
        return Double(bounds.width - thumbWidth) * (value - minmumValue) / (maxmumValue - minmumValue) + Double(thumbWidth / 2.0)
    }
    
    override func beginTrackingWithTouch(touch: UITouch!, withEvent event: UIEvent!) -> Bool {
        previousLocation = touch.locationInView(self)
        
        if lowerThumbLayer.frame.contains(previousLocation) {
            lowerThumbLayer.highlighted = true
        }else if upperThumbLayer.frame.contains(previousLocation) {
            upperThumbLayer.highlighted = true
        }
        
        return lowerThumbLayer.highlighted || upperThumbLayer.highlighted
    }
    
    func boundValue(value: Double, toLowerValue lowerValue: Double, upperValue: Double)  -> Double {
        return min(max(value, lowerValue), upperValue)
    }
    
    override func continueTrackingWithTouch(touch: UITouch!, withEvent event: UIEvent!) -> Bool {
        let location = touch.locationInView(self)
        
        let deltaLocation = Double(location.x - previousLocation.x)
        let deltaValue = (maxmumValue - minmumValue) * deltaLocation / Double(bounds.width - bounds.height)
        
        previousLocation = location
        
        // 更新value
        if lowerThumbLayer.highlighted {
            lowerValue += deltaValue
            lowerValue = boundValue(lowerValue, toLowerValue: minmumValue, upperValue: upperValue)
        }else if upperThumbLayer.highlighted {
            upperValue += deltaValue
            upperValue = boundValue(upperValue, toLowerValue: lowerValue, upperValue: maxmumValue)
        }
        
//        CATransaction.begin()
//        CATransaction.setDisableActions(true)
//        //更新UI
//        updateLayerFrames()
//        CATransaction.commit()
        
        sendActionsForControlEvents(.ValueChanged)
        
        return true
     }
    
    override func endTrackingWithTouch(touch: UITouch!, withEvent event: UIEvent!) {
        lowerThumbLayer.highlighted = false
        upperThumbLayer.highlighted = false
    }
    
    override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
}
