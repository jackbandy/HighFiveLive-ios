//
//  ViewController.swift
//  HighFiveLive
//
//  Created by Jack Work on 7/14/15.
//  Copyright © 2015 Jack Work. All rights reserved.
//

import UIKit
import CoreMotion
import AudioToolbox


class ViewController: UIViewController, StreamListener, ClassificationListener {
    
    private var motionManager: CMMotionManager!
    
    @IBOutlet weak var gestureLabel: UILabel!
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    @IBOutlet weak var zLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newStream: PhoneAccStream = PhoneAccStream()
        newStream.addListener(self)
        newStream.startupStream()
        let myClassifier = LogRegClassifier(aSegmentHandler: nil)
        let myExtractor = FeatureExtractor(aSegmentHandler: myClassifier)
        let mySegmentor = EnergySegmentor(aHandler: myExtractor, aStream: newStream)
        newStream.addListener(mySegmentor)
        myClassifier.addListener(self)
        
        /*
        var test = Array<Coordinate>()
        for i in 0..<128 {
        test.append(Coordinate(x: testSegment[(3*i)+0], y: (-1)*testSegment[(3*i)+1], z: testSegment[(3*i)+2]))
        }
        
        myExtractor.handleNewSegment(test, featureVector: nil)
        */
    }
    
    
    func newSensorCoordinate(aCoordinate: Coordinate) {
        self.xLabel.text = (String(format: "X: %.3f", (aCoordinate.x)))
        self.yLabel.text = (String(format: "Y: %.3f", (aCoordinate.y)))
        self.zLabel.text = (String(format: "Z: %.3f", (aCoordinate.z)))
    }
    
    
    func didReceiveNewClassification(aClassification: String){
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        self.gestureLabel.text = aClassification
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

