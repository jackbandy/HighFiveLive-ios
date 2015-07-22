//
//  EnergySegmentor.swift
//  HighFiveLive
//
//  Created by Jack Bandy on 7/15/15.
//  Copyright © 2015 Jack Work. All rights reserved.
//

import Foundation
import UIKit

class EnergySegmentor : StreamListener {
    let MAGNITUDE_THRESHOLD:Double = 1.5
    let nextHandler:SegmentHandler
    let streamSource:SensorDataStream
    var isSegmenting:Bool
    var currentSegment:Array<Coordinate>
    
    init(aHandler:SegmentHandler,aStream:SensorDataStream){
        isSegmenting = false
        nextHandler = aHandler
        streamSource = aStream
        currentSegment = Array<Coordinate>()
    }
    
    
    func newSensorCoordinate(aCoordinate: Coordinate) {
        if(!isSegmenting){
            //NOT CURRENTLY TRACKING
            if(aCoordinate.magnitude > MAGNITUDE_THRESHOLD){
                /*
                let notification = UILocalNotification()
                notification.alertBody = "You did it!"
                notification.fireDate = NSDate()
                notification.soundName = UILocalNotificationDefaultSoundName // play default sound
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
                */
                isSegmenting = true
                var toAdd: Array<Coordinate> = streamSource.getCache256()
                toAdd.removeRange(0..<240)
                currentSegment += toAdd
            }
        }
        
        
        else{
            //CURRENTLY TRACKING A GESTURE
            if(currentSegment.count == 128){
                isSegmenting = false
                nextHandler.handleNewSegment(currentSegment,featureVector:nil)
                currentSegment.removeAll()
            }
            else{
                currentSegment.append(aCoordinate)
            }
        }
    }
}
