//
//  InterfaceController.swift
//  HighFiveLive WatchKit Extension
//
//  Created by Jack Work on 7/14/15.
//  Copyright © 2015 Jack Work. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion


class InterfaceController: WKInterfaceController {
    
    lazy var motionManager = CMMotionManager()

    @IBOutlet var xLabel: WKInterfaceLabel!
    @IBOutlet var yLabel: WKInterfaceLabel!
    @IBOutlet var zLabel: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        if motionManager.accelerometerAvailable{
            let queue = NSOperationQueue()
            motionManager.accelerometerUpdateInterval = 0.02
            motionManager.startAccelerometerUpdatesToQueue(queue, withHandler:
                {data, error in
                    
                    guard let data = data else{
                        return
                    }
                    
                    self.xLabel.setText(String(format: "X: %.3f", (data.acceleration.x)))
                    self.yLabel.setText(String(format: "Y: %.3f", (data.acceleration.y)))
                    self.zLabel.setText(String(format: "Z: %.3f", (data.acceleration.z)))
                    
                }
            )
        } else {
            print("Accelerometer is not available")
        }
    }
    

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    


    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
