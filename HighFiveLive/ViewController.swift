//
//  ViewController.swift
//  HighFiveLive
//
//  Created by Jack Work on 7/14/15.
//  Copyright © 2015 Jack Work. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    private var motionManager: CMMotionManager!

    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    @IBOutlet weak var zLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        motionManager = CMMotionManager()
        
        if motionManager.accelerometerAvailable{
            motionManager.startAccelerometerUpdates()
            let timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target:self, selector: Selector("outputData"), userInfo: nil, repeats: true)
            timer.fire()
        } else {
            print("Accelerometer is not available")
        }

        
    }
    
    func outputData(){
        if(motionManager.accelerometerActive && motionManager.accelerometerData != nil){
            let data:CMAccelerometerData = motionManager.accelerometerData!
            self.xLabel.text = (String(format: "X: %.3f", (data.acceleration.x)))
            self.yLabel.text = (String(format: "Y: %.3f", (data.acceleration.y)))
            self.zLabel.text = (String(format: "Z: %.3f", (data.acceleration.z)))
            
        }
    }
    
    func outputData(xAcc: Double, yAcc: Double, zAcc: Double){
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

