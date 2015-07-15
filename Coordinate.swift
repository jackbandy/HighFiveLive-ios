//
//  Coordinate.swift
//  HighFiveLive
//
//  Created by Jack Bandy on 7/15/15.
//  Copyright © 2015 Jack Work. All rights reserved.
//

import Foundation

public struct Coordinate {
    let x, y, z : Double
    let magnitude : Double
    
    init(x:Double,y:Double,z:Double){
        self.x = x
        self.y = y
        self.z = z
        self.magnitude = sqrt(x*x + y*y + z*z)
    }
    
    public func toArray() -> Array<Double> {
        return Array<Double>(arrayLiteral: self.x,self.y,self.z)
    }
    
    public func toString() -> String {
        return "x: \ny: \nz:"
    }
    
}
