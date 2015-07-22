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
    
    private var isTracking: Bool
    private var myStream: SensorDataStream
    private var myClassifier: GestureClassifier
    private var myExtractor: FeatureExtractor
    private var mySegmentor: EnergySegmentor
    
    @IBOutlet var xLabel: WKInterfaceLabel!
    @IBOutlet var gestureLabel: WKInterfaceLabel!
    @IBOutlet var yLabel: WKInterfaceLabel!
    @IBOutlet var zLabel: WKInterfaceLabel!
    @IBOutlet var theButton: WKInterfaceButton!
    
    
    override init() {
        isTracking = false
        myStream = WatchAccStream()
        myClassifier = LogRegClassifier(aSegmentHandler: nil)
        myExtractor = FeatureExtractor(aSegmentHandler: myClassifier as! SegmentHandler)
        mySegmentor = EnergySegmentor(aHandler: myExtractor, aStream: myStream)
        super.init()
        
        myStream.addListener(self)
        myStream.addListener(mySegmentor)
        myClassifier.addListener(self)
        
    }
    
    @IBAction func startBtn() {
        if(isTracking){
            self.gestureLabel.setText("Not tracking yet!")
            self.theButton.setTitle("Start")
            myStream.terminateStream()
        }
        else if(!isTracking){
            self.gestureLabel.setText("Tracking!")
            self.theButton.setTitle("Stop")
            myStream.startupStream()
        }
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        isTracking = false
    }
    
    func newSensorCoordinate(aCoordinate: Coordinate) {
        let tmpArr = aCoordinate.toArray()
        self.xLabel.setText(String(format: "X: %.3f", (tmpArr[0])))
        self.yLabel.setText(String(format: "Y: %.3f", (tmpArr[1])))
        self.zLabel.setText(String(format: "Z: %.3f", (tmpArr[2])))
    }
    
    
    func didReceiveNewClassification(aClassification: String){
        dispatch_async(dispatch_get_main_queue()) {
            self.gestureLabel.setText(aClassification)
        }
        let watch: WKInterfaceDevice = WKInterfaceDevice()
        self.gestureLabel.setText(aClassification)
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
