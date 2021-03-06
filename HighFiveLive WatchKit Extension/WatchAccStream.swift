//
//  PhoneAccStream.swift
//  HighFiveLive
//
//  Created by Jack Bandy on 7/15/15.
//  Copyright © 2015 Jack Work. All rights reserved.
//

import Foundation
import CoreMotion

class WatchAccStream : SensorDataStream {
    private var isStreaming : Bool = false
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
            motionManager.accelerometerUpdateInterval = 0.02

            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue()) {
                [weak self] (data: CMAccelerometerData?, error: NSError?) in
                if(data?.acceleration != nil){
                    let newCoord = Coordinate(x: (-1) * (data?.acceleration.x)!, y: (data?.acceleration.y)!, z: (data?.acceleration.z)!)
                    self!.myCache.removeAtIndex(0)
                    self!.myCache.append(newCoord)
                    
                    for aListner in self!.myListeners{
                        aListner.newSensorCoordinate(newCoord)
                    }
            
                }
            }
            isStreaming = true

            //motionManager.startAccelerometerUpdates()
            //myTimer = NSTimer.scheduledTimerWithTimeInterval(0.02, target:self, selector: Selector("getNewCoord"), userInfo: nil, repeats: true)
            //myTimer.fire()
        } else {
            isStreaming = false
            print("Accelerometer is not available")
        }
    }
    
    
    
    func terminateStream(){
        isStreaming = false
        motionManager.stopAccelerometerUpdates()
        //myTimer.invalidate()
    }
    
    
    
    @objc func getNewCoord(){
        if(isStreaming){
            if(motionManager.accelerometerActive && motionManager.accelerometerData != nil){
                let data:CMAccelerometerData = motionManager.accelerometerData!
                let newCoord = Coordinate(x: (-1 * data.acceleration.x), y: data.acceleration.y, z: data.acceleration.z)
                
                myCache.removeAtIndex(0)
                myCache.append(newCoord)
                
                for aListner in myListeners{
                    aListner.newSensorCoordinate(newCoord)
                }
            }
        }
    }
    
    
    func getCache256() -> Array<Coordinate> {
        return myCache
    }
}
