//
//  ViewController.swift
//  HighFiveLive
//
//  Created by Jack Work on 7/14/15.
//  Copyright © 2015 Jack Work. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController, StreamListener {
    
    private var motionManager: CMMotionManager!

    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    @IBOutlet weak var zLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newStream: PhoneAccStream = PhoneAccStream()
        newStream.addListener(self)
        newStream.startupStream()
    }
    
    
    func newSensorCoordinate(aCoordinate: Coordinate) {
        self.xLabel.text = (String(format: "X: %.3f", (aCoordinate.x)))
        self.yLabel.text = (String(format: "Y: %.3f", (aCoordinate.y)))
        self.zLabel.text = (String(format: "Z: %.3f", (aCoordinate.z)))
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

