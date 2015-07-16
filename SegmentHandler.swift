//
//  File.swift
//  HighFiveLive
//
//  Created by Jack Bandy on 7/15/15.
//  Copyright © 2015 Jack Work. All rights reserved.
//

import Foundation

protocol SegmentHandler {
    init(aSegmentHandler: SegmentHandler?)
    func handleNewSegment(segmentPoints: Array<Coordinate>, featureVector:Array<Double>?)
}