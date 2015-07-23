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
    private var coordCount: Int
    private var myStream: SensorDataStream
    private var myClassifier: GestureClassifier
    private var myExtractor: FeatureExtractor
    private var mySegmentor: EnergySegmentor
    private var gestureText: String
    
    @IBOutlet var xLabel: WKInterfaceLabel!
    @IBOutlet var gestureLabel: WKInterfaceLabel!
    @IBOutlet var yLabel: WKInterfaceLabel!
    @IBOutlet var zLabel: WKInterfaceLabel!
    @IBOutlet var theButton: WKInterfaceButton!
    
    
    override init() {
        coordCount = 0
        isTracking = false
        gestureText = "Not tracking yet!"

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
            dispatch_async(dispatch_get_main_queue()) {
                self.gestureText = "Not tracking yet!"
                self.gestureLabel.setText(self.gestureText)
                self.theButton.setTitle("Start")
                self.myStream.terminateStream()
                self.isTracking = false
            }
        }
        else if(!isTracking){
            dispatch_async(dispatch_get_main_queue()) {
                self.gestureText = "Tracking!"
                self.gestureLabel.setText(self.gestureText)
                self.theButton.setTitle("Stop")
                self.myStream.startupStream()
                self.isTracking = true
            }
        }
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        isTracking = false
    }
    
    func newSensorCoordinate(aCoordinate: Coordinate) {
        if(coordCount++ == 16){
            coordCount = 0
            dispatch_async(dispatch_get_main_queue()) {
                let tmpArr = aCoordinate.toArray()
                self.xLabel.setText(String(format: "X: %.3f", (tmpArr[0])))
                self.yLabel.setText(String(format: "Y: %.3f", (tmpArr[1])))
                self.zLabel.setText(String(format: "Z: %.3f", (tmpArr[2])))
                self.gestureLabel.setText(self.gestureText)
            }
        }
    }
    
    
    func didReceiveNewClassification(aClassification: String){
        gestureText = aClassification
        dispatch_async(dispatch_get_main_queue()) {
            self.gestureLabel.setText(self.gestureText)
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
