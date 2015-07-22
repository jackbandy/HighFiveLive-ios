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


class InterfaceController: WKInterfaceController, StreamListener, ClassificationListener {
    
    @IBOutlet var xLabel: WKInterfaceLabel!
    @IBOutlet var gestureLabel: WKInterfaceLabel!
    @IBOutlet var yLabel: WKInterfaceLabel!
    @IBOutlet var zLabel: WKInterfaceLabel!
    
    @IBAction func startBtn() {
        self.gestureLabel.setText("tracking!")

        print("A")
        
        let newStream: WatchAccStream = WatchAccStream()
        print("B")
        
        newStream.addListener(self)
        print("C")
        
        newStream.startupStream()
        print("D")
        
        let myClassifier = LogRegClassifier(aSegmentHandler: nil)
        print("E")
        
        let myExtractor = FeatureExtractor(aSegmentHandler: myClassifier)
        print("F")
        
        let mySegmentor = EnergySegmentor(aHandler: myExtractor, aStream: newStream)
        print("G")
        
        newStream.addListener(mySegmentor)
        print("H")
        
        myClassifier.addListener(self)
        print("I")
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)

    }
    
    func newSensorCoordinate(aCoordinate: Coordinate) {
        let tmpArr = aCoordinate.toArray()
        self.xLabel.setText(String(format: "X: %.3f", (tmpArr[0])))
        self.yLabel.setText(String(format: "Y: %.3f", (tmpArr[1])))
        self.zLabel.setText(String(format: "Z: %.3f", (tmpArr[2])))
    }
    
    
    func didReceiveNewClassification(aClassification: String){
        self.gestureLabel.setText(aClassification)
        let watch: WKInterfaceDevice = WKInterfaceDevice()
        watch.playHaptic(.Success)
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
