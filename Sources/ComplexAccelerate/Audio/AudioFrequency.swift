//
//  AudioFrequency.swift
//
//
//  Created by Albertus Liberius on 2022-12-27.
//

import Foundation
import Accelerate

/// Defines a structure containing frequency in hertz, and also defines conversions into other units and into log scale.
public struct AudioFrequency: ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral{
    public let inHertz: Double
    public var inOctave: Double{
        log2(inHertz / 440) + 4.75
    }
    
    public var inRadiansPerSecond: Double{
        2 * .pi * inHertz
    }
    public var inAudibleRangeLogScale: Double{
        log10(inHertz / 20) / 3
    }
    
    public init(floatLiteral inHertz: Double){
        self.inHertz = abs(inHertz)
    }
    public init(integerLiteral value: Int) {
        self.inHertz = Double(value)
    }
    public init(inHertz: Double){
        self.inHertz = abs(inHertz)
    }
    public init(inOctave: Double){
        self.inHertz = exp2(inOctave - 4.75) * 440
    }
    public init(inRadiansPerSecond: Double){
        self.inHertz = abs(inRadiansPerSecond) / (2 * Double.pi)
    }
    public init(inAudibleRangeLogScale: Double){
        self.inHertz = 20 * pow(10, (3 * inAudibleRangeLogScale))
    }
    @frozen
    public enum Note{
        /// The note a semitone below ``A``.
        case AFlat
        /// The note two whole tones above ``F``.
        case A
        /// The note a semitone above ``A``.
        case ASharp
        /// The note a semitone below ``B``.
        case BFlat
        /// The note three whole tones above ``F``.
        case B
        /// The note a semitone above ``B``.
        case BSharp
        /// The note a semitone below ``C``.
        case CFlat
        /// The base note of the octave.
        case C
        /// The note a semitone above ``C``.
        case CSharp
        /// The note a semitone below ``D``.
        case DFlat
        /// The note a whole tone above ``C``.
        case D
        /// The note a semitone above ``D``.
        case DSharp
        /// The note a semitone below ``E``.
        case EFlat
        /// The note two whole tones above ``C``.
        case E
        /// The note a semitone above ``E``.
        case ESharp
        /// The note a semitone below ``F``, which is the same as ``E``.
        case FFlat
        /// The note a semitone above ``E``.
        case F
        /// The note a semitone above ``F``.
        case FSharp
        /// The note a semitone below ``G``.
        case GFlat
        /// The note a whole tone above ``F``.
        case G
        /// The note a semitone above ``G``.
        case GSharp
    }
    public init(note: Note, octave: Int){
        let oneOverTwelve: Double
        switch note{
        case .CFlat:
            oneOverTwelve = -1.0/12
        case .C:
            oneOverTwelve = 0 //
        case .CSharp:
            oneOverTwelve = 1.0/12
        case .DFlat:
            oneOverTwelve = 1.0/12
        case .D:
            oneOverTwelve = 2.0/12 //
        case .DSharp:
            oneOverTwelve = 3.0/12
        case .EFlat:
            oneOverTwelve = 3.0/12
        case .E:
            oneOverTwelve = 4.0/12 //
        case .ESharp:
            oneOverTwelve = 5.0/12
        case .FFlat:
            oneOverTwelve = 4.0/12
        case .F:
            oneOverTwelve = 5.0/12 //
        case .FSharp:
            oneOverTwelve = 6.0/12
        case .GFlat:
            oneOverTwelve = 6.0/12
        case .G:
            oneOverTwelve = 7.0/12 //
        case .GSharp:
            oneOverTwelve = 8.0/12
        case .AFlat:
            oneOverTwelve = 8.0/12
        case .A:
            oneOverTwelve = 9.0/12 //
        case .ASharp:
            oneOverTwelve = 10.0/12
        case .BFlat:
            oneOverTwelve = 10.0/12
        case .B:
            oneOverTwelve = 11.0/12 //
        case .BSharp:
            oneOverTwelve = 12.0/12
        }
        self.init(inOctave: oneOverTwelve + Double(octave))
    }
}
extension AudioFrequency: CustomStringConvertible{
    public var description: String{
        Int(self.inHertz.rounded(.toNearestOrAwayFromZero)).description + "Hz"
    }
}

extension AudioFrequency: Hashable{
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.inHertz)
    }
}

public extension AudioFrequency{
    static let sample_32kHz = AudioFrequency(inHertz: 32000)
    static let sample_44kHz = AudioFrequency(inHertz: 44100)
    static let sample_48kHz = AudioFrequency(inHertz: 48000)
    static let sample_96kHz = AudioFrequency(inHertz: 96000)
    static let sample_192kHz = AudioFrequency(inHertz: 192000)
}

extension AudioFrequency: Equatable{
    public static func == (lhs: AudioFrequency, rhs: AudioFrequency) -> Bool{
        lhs.inHertz == rhs.inHertz
    }
}

extension AudioFrequency: Comparable{
    public static func < (lhs: AudioFrequency, rhs: AudioFrequency) -> Bool{
        lhs.inHertz < rhs.inHertz
    }
}

public extension Vector where Element == AudioFrequency{
    static func frequenciesInHertz<AudioFrequencyArray>(of frequencies: AudioFrequencyArray) -> [Double]
    where AudioFrequencyArray: AccelerateBuffer, AudioFrequencyArray.Element == AudioFrequency
    {
        [Double](unsafeUninitializedCapacity: frequencies.count) { outputBuffer, initializedCount in
            frequencies.withUnsafeBufferPointer { fBuffer in
                fBuffer.withMemoryRebound(to: Double.self) { inputDoubleBuffer in
                    let inputRawBuffer = UnsafeRawBufferPointer(inputDoubleBuffer)
                    let outputRawBuffer = UnsafeMutableRawBufferPointer(outputBuffer)
                    outputRawBuffer.copyMemory(from: inputRawBuffer)
                }
            }
            initializedCount = frequencies.count
        }
    }
    static func octaves<AudioFrequencyArray>(of frequencies: AudioFrequencyArray) -> [Double]
    where AudioFrequencyArray: AccelerateBuffer, AudioFrequencyArray.Element == AudioFrequency
    {
        vDSP.add(4.75 - Darwin.log2(440), vForce.log2(frequenciesInHertz(of: frequencies)))
    }
    static func angularVelocities<AudioFrequencyArray>(of frequencies: AudioFrequencyArray) -> [Double]
    where AudioFrequencyArray: AccelerateBuffer, AudioFrequencyArray.Element == AudioFrequency
    {
        vDSP.multiply(2 * Double.pi, frequenciesInHertz(of: frequencies))
    }
    static func audibleRangeLogScaleParameters<AudioFrequencyArray>(of frequencies: AudioFrequencyArray) -> [Double]
    where AudioFrequencyArray: AccelerateBuffer, AudioFrequencyArray.Element == AudioFrequency
    {
        vDSP.divide(vForce.log10(vDSP.divide(frequenciesInHertz(of: frequencies), 20)), 3)
    }
    
    static func create<DoubleArray>(frequenciesInHertz: DoubleArray) -> [AudioFrequency]
    where DoubleArray: AccelerateBuffer, DoubleArray.Element == Double
    {
        return [AudioFrequency](unsafeUninitializedCapacity: frequenciesInHertz.count) { fBuffer, initializedCount in
            frequenciesInHertz.withUnsafeBufferPointer { inputDoubleBuffer in
                fBuffer.withMemoryRebound(to: Double.self) { outputDoubleBuffer in
                    let inputRawBuffer = UnsafeRawBufferPointer(inputDoubleBuffer)
                    let outputRawBuffer = UnsafeMutableRawBufferPointer(outputDoubleBuffer)
                    outputRawBuffer.copyMemory(from: inputRawBuffer)
                }
            }
            initializedCount = frequenciesInHertz.count
        }
    }
    static func create<DoubleArray>(octaves: DoubleArray) -> [AudioFrequency]
    where DoubleArray: AccelerateBuffer, DoubleArray.Element == Double
    {
        create(frequenciesInHertz: vDSP.multiply(440, vForce.exp2(vDSP.add(-4.75, octaves))))
    }
    static func create<DoubleArray>(angularVelocities: DoubleArray) -> [AudioFrequency]
    where DoubleArray: AccelerateBuffer, DoubleArray.Element == Double
    {
        create(frequenciesInHertz: vDSP.divide(angularVelocities, 2 * Double.pi))
    }
    static func create<DoubleArray>(audibleRangeLogScaleParameters: DoubleArray) -> [AudioFrequency]
    where DoubleArray: AccelerateBuffer, DoubleArray.Element == Double
    {
        create(frequenciesInHertz: vForce.exp(vDSP.add(Foundation.log(Double(20)), vDSP.multiply(3 * Foundation.log(Double(10)), audibleRangeLogScaleParameters))))
    }
    static func create<FloatArray>(frequenciesInHertz: FloatArray) -> [AudioFrequency]
    where FloatArray: AccelerateBuffer, FloatArray.Element == Float
    {
        create(frequenciesInHertz: vDSP.floatToDouble(frequenciesInHertz))
    }
    static func create<FloatArray>(octaves: FloatArray) -> [AudioFrequency]
    where FloatArray: AccelerateBuffer, FloatArray.Element == Float
    {
        create(octaves: vDSP.floatToDouble(octaves))
    }
    static func create<FloatArray>(angularVelocities: FloatArray) -> [AudioFrequency]
    where FloatArray: AccelerateBuffer, FloatArray.Element == Float
    {
        create(angularVelocities: vDSP.floatToDouble(angularVelocities))
    }
    static func create<FloatArray>(audibleRangeLogScaleParameters: FloatArray) -> [AudioFrequency]
    where FloatArray: AccelerateBuffer, FloatArray.Element == Float
    {
        create(audibleRangeLogScaleParameters: vDSP.floatToDouble(audibleRangeLogScaleParameters))
    }
    
    static func createFrequenciesLogScale(in range: ClosedRange<AudioFrequency>, count: Int = 256) -> [AudioFrequency]{
        create(frequenciesInHertz: Vector<Double>.geometricProgression(initialValue: range.lowerBound.inHertz, to: range.upperBound.inHertz, count: count))
    }
}
