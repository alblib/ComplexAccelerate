//
//  AudioGain.swift
//
//
//  Created by Albertus Liberius on 2022-12-29.
//

import Foundation
import Accelerate

/// Defines a relative amplitude of audio, or a value of a transfer function, in various units.
public struct AudioGain: ExpressibleByFloatLiteral{
    public let byAmplitude: Double
    public var byPower: Double{
        byAmplitude * byAmplitude
    }
    public var inDecibels: Double{
        20 * log10( byAmplitude )
    }
    
    public init(floatLiteral value: Double) {
        self.byAmplitude = abs(value)
    }
    public init(byAmplitude: Double) {
        self.byAmplitude = abs(byAmplitude)
    }
    public init(byAmplitude: Float) {
        self.byAmplitude = Double(abs(byAmplitude))
    }
    public init(byAmplitude: Int) {
        self.byAmplitude = Double(abs(byAmplitude))
    }
    public init(byPower: Double){
        self.byAmplitude = sqrt(abs(byPower))
    }
    public init(byPower: Float){
        self.byAmplitude = sqrt(Double(abs(byPower)))
    }
    public init(byPower: Int){
        self.byAmplitude = sqrt(Double(abs(byPower)))
    }
    public init(inDecibels: Double){
        self.byAmplitude = pow(10, inDecibels / 20)
    }
    public init(inDecibels: Float){
        self.byAmplitude = pow(10, Double(inDecibels) / 20)
    }
    public init(inDecibels: Int){
        self.byAmplitude = pow(10, Double(inDecibels) / 20)
    }
}

extension AudioGain: CustomStringConvertible{
    public var description: String{
        String(format: "%+.1fdB", self.inDecibels)
    }
}


public extension Vector where Element == AudioGain{
    static func amplitudeGains<AudioGainArray>(of gains: AudioGainArray) -> [Double]
    where AudioGainArray: AccelerateBuffer, AudioGainArray.Element == AudioGain
    {
        [Double](unsafeUninitializedCapacity: gains.count) { doubleBuffer, initializedCount in
            gains.withUnsafeBufferPointer { gainsBuffer in
                gainsBuffer.withMemoryRebound(to: Double.self) { inputDoubleBuffer in
                    let inputRawBuffer = UnsafeRawBufferPointer(inputDoubleBuffer)
                    let outputRawBuffer = UnsafeMutableRawBufferPointer(doubleBuffer)
                    outputRawBuffer.copyMemory(from: inputRawBuffer)
                }
            }
            initializedCount = gains.count
        }
    }
    static func powerGains<AudioGainArray>(of gains: AudioGainArray) -> [Double]
    where AudioGainArray: AccelerateBuffer, AudioGainArray.Element == AudioGain
    {
        vDSP.square(amplitudeGains(of: gains))
    }
    static func decibels<AudioGainArray>(of gains: AudioGainArray) -> [Double]
    where AudioGainArray: AccelerateBuffer, AudioGainArray.Element == AudioGain
    {
        vDSP.amplitudeToDecibels(amplitudeGains(of: gains), zeroReference: 1)
    }
    
    static func create<DoubleArray>(amplitudeGains: DoubleArray) -> [AudioGain]
    where DoubleArray: AccelerateBuffer, DoubleArray.Element == Double
    {
        let absResult = vDSP.absolute(amplitudeGains)
        return [AudioGain](unsafeUninitializedCapacity: amplitudeGains.count) { gainsBuffer, initializedCount in
            absResult.withUnsafeBufferPointer { inputDoubleBuffer in
                gainsBuffer.withMemoryRebound(to: Double.self) { outputDoubleBuffer in
                    let inputRawBuffer = UnsafeRawBufferPointer(inputDoubleBuffer)
                    let outputRawBuffer = UnsafeMutableRawBufferPointer(outputDoubleBuffer)
                    outputRawBuffer.copyMemory(from: inputRawBuffer)
                }
            }
            initializedCount = amplitudeGains.count
        }
    }
    static func create<DoubleArray>(powerGains: DoubleArray) -> [AudioGain]
    where DoubleArray: AccelerateBuffer, DoubleArray.Element == Double
    {
        create(amplitudeGains: vForce.sqrt(powerGains))
    }
    static func create<DoubleArray>(decibels: DoubleArray) -> [AudioGain]
    where DoubleArray: AccelerateBuffer, DoubleArray.Element == Double
    {
        create(amplitudeGains: vForce.exp(vDSP.multiply(Foundation.log(10) / 20, decibels)))
    }
    static func create<FloatArray>(amplitudeGains: FloatArray) -> [AudioGain]
    where FloatArray: AccelerateBuffer, FloatArray.Element == Float
    {
        create(amplitudeGains: vDSP.floatToDouble(amplitudeGains))
    }
    static func create<FloatArray>(powerGains: FloatArray) -> [AudioGain]
    where FloatArray: AccelerateBuffer, FloatArray.Element == Float
    {
        create(powerGains: vDSP.floatToDouble(powerGains))
    }
    static func create<FloatArray>(decibels: FloatArray) -> [AudioGain]
    where FloatArray: AccelerateBuffer, FloatArray.Element == Float
    {
        create(decibels: vDSP.floatToDouble(decibels))
    }
    
    static func gainMultiply<GainArray>(_ gains: GainArray, _ gain: AudioGain) -> [AudioGain]
    where GainArray: AccelerateBuffer, GainArray.Element == AudioGain
    {
        create(amplitudeGains: vDSP.multiply(gain.byAmplitude, amplitudeGains(of: gains)))
    }
    static func gainMultiply<GainArray>(_ gain: AudioGain, _ gains: GainArray) -> [AudioGain]
    where GainArray: AccelerateBuffer, GainArray.Element == AudioGain
    {
        create(amplitudeGains: vDSP.multiply(gain.byAmplitude, amplitudeGains(of: gains)))
    }
}
