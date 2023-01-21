//
//  AudioFilter.swift
//  
//
//  Created by Albertus Liberius on 2023-01-21.
//

import Foundation

public struct AudioFilter{
    public var transferFunction: AnalogTransferFunction
    public init(analog: AnalogTransferFunction){
        transferFunction = analog
    }
    public init(digital: DigitalTransferFunction){
        transferFunction = digital.bilinearTransformToAnalog()
    }
    public var sampleRate: AudioFrequency = .sample_44kHz
    var outputCache = Array(repeating: Double.zero, count: 1024)
}
