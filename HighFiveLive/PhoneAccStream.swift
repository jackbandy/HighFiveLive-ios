//
//  PhoneAccStream.swift
//  HighFiveLive
//
//  Created by Jack Bandy on 7/15/15.
//  Copyright © 2015 Jack Work. All rights reserved.
//

import Foundation
import CoreMotion

class PhoneAccStream : SensorDataStream {
    private var myListeners : Array<StreamListener> = []
    private var myTimer : NSTimer!
    private var motionManager: CMMotionManager!
    private var myCache: Array<Coordinate>!
    
    
    func addListener(aListener: StreamListener){
        myListeners.append(aListener)
    }
    
    
    func startupStream(){
        let zeroCoord : Coordinate = Coordinate(x: 0.0, y: 0.0, z: 0.0)
        myCache = Array(count: 256, repeatedValue: zeroCoord)
        
        motionManager = CMMotionManager()
        
        if motionManager.accelerometerAvailable{
            motionManager.startAccelerometerUpdates()
            myTimer = NSTimer.scheduledTimerWithTimeInterval(0.02, target:self, selector: Selector("getNewCoord"), userInfo: nil, repeats: true)
            myTimer.fire()
        } else {
            print("Accelerometer is not available")
        }
    }
    
    
    func terminateStream(){
        myTimer.invalidate()
    }
    
    
    @objc func getNewCoord(){
        if(motionManager.accelerometerActive && motionManager.accelerometerData != nil){
            let data:CMAccelerometerData = motionManager.accelerometerData!
            let newCoord = Coordinate(x: data.acceleration.x, y: data.acceleration.y, z: data.acceleration.z)
            
            myCache.removeAtIndex(0)
            myCache.append(newCoord)
            
            for aListner in myListeners{
                aListner.newSensorCoordinate(newCoord)
            }
        }
    }
    
    
    func getCache256() -> Array<Coordinate> {
        return myCache
    }
}
