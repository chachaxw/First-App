//
//  ViewController.swift
//  First App
//
//  Created by 周伟 on 16/1/10.
//  Copyright © 2016年 周伟. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let rangeSlider = RangeSlider(frame: CGRectZero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSThread.sleepForTimeInterval(2)
        
//        rangeSlider.backgroundColor = UIColor.grayColor()
        view.addSubview(rangeSlider)
        rangeSlider.addTarget(self, action: "rangeSliderValueChanged:", forControlEvents: .ValueChanged)
        
//        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC))
//        dispatch_after(time, dispatch_get_main_queue()){
//            self.rangeSlider.trackHighLightTintColor = UIColor.redColor()
//            self.rangeSlider.curvaceousness = 0.0
//        }
    }

    override func viewDidLayoutSubviews() {
        let margin: CGFloat = 20.0
        let width = view.bounds.width - margin * 2.0
        rangeSlider.frame = CGRect(x: margin, y: margin + topLayoutGuide.length, width: width, height: 44.0)
    }
  
    func rangeSliderValueChanged(rangeSlider: RangeSlider) {
        print("Range slider value changed: (\(rangeSlider.lowerValue) \(rangeSlider.upperValue))")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

