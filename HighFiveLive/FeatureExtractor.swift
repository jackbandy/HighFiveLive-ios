//
//  EnergySegmentor.swift
//  HighFiveLive
//
//  Created by Jack Bandy on 7/15/15.
//  Copyright © 2015 Jack Work. All rights reserved.
//

import Foundation
import Surge
import SigmaSwiftStatistics

class FeatureExtractor : SegmentHandler {
    let myNextHandler: SegmentHandler!
    
    required init(aSegmentHandler: SegmentHandler?){
        myNextHandler = aSegmentHandler
    }
    
    func signalEnergyFromFFT(theFFT: Array<Double>) -> Double{
        var runSum : Double = 0.0
        for i in 0..<theFFT.count {
            runSum += Surge.pow(theFFT[i], 2)
        }
        return (1.0/128.0)*runSum
    }

    
    func handleNewSegment(segmentPoints: Array<Coordinate>, featureVector: Array<Double>?) {
        let startTime: NSDate = NSDate()
        
        var features = Array<Double>()
        var featCount = 0
        var xArray = Array<Double>()
        var yArray = Array<Double>()
        var zArray = Array<Double>()
        
        for coord in segmentPoints{
            let tmpArray = coord.toArray()
            xArray.append(tmpArray[0])
            yArray.append(tmpArray[1])
            zArray.append(tmpArray[2])
        }
        
        
        //-------TIME DOMAIN FEATURES------
        //Minimum values
        features.insert(Surge.min(xArray), atIndex: featCount++)
        features.insert(Surge.min(yArray), atIndex: featCount++)
        features.insert(Surge.min(zArray), atIndex: featCount++)
        
        //Maximum values
        features.insert(Surge.max(xArray), atIndex: featCount++)
        features.insert(Surge.max(yArray), atIndex: featCount++)
        features.insert(Surge.max(zArray), atIndex: featCount++)
        
        //Mean values
        features.insert(Surge.mean(xArray), atIndex: featCount++)
        features.insert(Surge.mean(yArray), atIndex: featCount++)
        features.insert(Surge.mean(zArray), atIndex: featCount++)
        
        //Standard deviation
        features.insert(σ.standardDeviationPopulation(xArray)!, atIndex: featCount++)
        features.insert(σ.standardDeviationPopulation(yArray)!, atIndex: featCount++)
        features.insert(σ.standardDeviationPopulation(zArray)!, atIndex: featCount++)

        //Pairwise correlation/covariance
        features.insert(σ.covariancePopulation(x: xArray,y: yArray)!, atIndex: featCount++)
        features.insert(σ.covariancePopulation(x: xArray,y: zArray)!, atIndex: featCount++)
        features.insert(σ.covariancePopulation(x: yArray,y: zArray)!, atIndex: featCount++)
        
        //Zero crossing rate
        features.insert(σ.zeroCrossRate(xArray)!, atIndex: featCount++)
        features.insert(σ.zeroCrossRate(yArray)!, atIndex: featCount++)
        features.insert(σ.zeroCrossRate(zArray)!, atIndex: featCount++)
        
        //Skew
        features.insert(Surge.mean(xArray), atIndex: featCount++)
        features.insert(Surge.mean(yArray), atIndex: featCount++)
        features.insert(Surge.mean(zArray), atIndex: featCount++)
        
        //Kurtosis
        features.insert(σ.kurtosis(xArray)!, atIndex: featCount++)
        features.insert(σ.kurtosis(yArray)!, atIndex: featCount++)
        features.insert(σ.kurtosis(zArray)!, atIndex: featCount++)
        
        //Interquartile range
        features.insert(σ.interQuartileRange(xArray)!, atIndex: featCount++)
        features.insert(σ.interQuartileRange(yArray)!, atIndex: featCount++)
        features.insert(σ.interQuartileRange(zArray)!, atIndex: featCount++)
        
        //mean crossing rate
        features.insert(σ.meanCrossRate(xArray)!, atIndex: featCount++)
        features.insert(σ.meanCrossRate(yArray)!, atIndex: featCount++)
        features.insert(σ.meanCrossRate(zArray)!, atIndex: featCount++)
        
        //Trapezoidal sum
        features.insert(σ.sum(xArray), atIndex: featCount++)
        features.insert(σ.sum(yArray), atIndex: featCount++)
        features.insert(σ.sum(zArray), atIndex: featCount++)
        
        
        //-------FREQUENCY DOMAIN FEATURES------
        let xFFT = Surge.fft(xArray)
        let yFFT = Surge.fft(yArray)
        let zFFT = Surge.fft(zArray)

        //FFT Signal Energy
        features.insert(signalEnergyFromFFT(xFFT), atIndex: featCount++)
        features.insert(signalEnergyFromFFT(yFFT), atIndex: featCount++)
        features.insert(signalEnergyFromFFT(zFFT), atIndex: featCount++)

        
        //First 8 DFT Coefficients
        let numberOfCoefficients = 8
        for i in 0..<numberOfCoefficients {
            features.insert(xFFT[i], atIndex: featCount++)
        }
        for i in 0..<numberOfCoefficients {
            features.insert(yFFT[i], atIndex: featCount++)
        }
        for i in 0..<numberOfCoefficients {
            features.insert(zFFT[i], atIndex: featCount++)
        }
        
        let duration = NSDate().timeIntervalSinceDate(startTime)
        print("FEATURE CALCULATION TIME: ")
        print(duration)
        
        myNextHandler.handleNewSegment(segmentPoints, featureVector: features)
    }
}
