//
//  TransferFunction.swift
//  
//
//  Created by Albertus Liberius on 2022-12-30.
//

import Foundation
import Accelerate

public protocol TransferFunction{
    func frequencyResponse(_ frequencies: [AudioFrequency]) -> [DSPDoubleComplex]
    var bassGain: AudioGain { get }
    var bassGroupDelay: TimeInterval { get }
    func gainFrequencyResponse(_ frequencies: [AudioFrequency]) -> [AudioGain]
    func gainFrequencyResponse(in freqRange: ClosedRange<AudioFrequency>, count: Int) -> [AudioGain]
    func phaseFrequencyResponse(_ frequencies: [AudioFrequency]) -> [AudioPhase]
    func phaseFrequencyResponse(in freqRange: ClosedRange<AudioFrequency>, count: Int) -> [AudioPhase]
    func relativePhaseFrequencyResponse(_ frequencies: [AudioFrequency]) -> [AudioPhase]
    func relativePhaseFrequencyResponse(in freqRange: ClosedRange<AudioFrequency>, count: Int) -> [AudioPhase]
    func continuousPhaseFrequencyResponse(in freqRange: ClosedRange<AudioFrequency>, count: Int) -> [AudioPhase]
    func continuousRelativePhaseFrequencyResponse(in freqRange: ClosedRange<AudioFrequency>, count: Int) -> [AudioPhase]
}
extension TransferFunction{
    public func gainFrequencyResponse(_ frequencies: [AudioFrequency]) -> [AudioGain]{
        Vector.create(amplitudeGains: Vector.absolute(frequencyResponse(frequencies)))
    }
    public func gainFrequencyResponse(in freqRange: ClosedRange<AudioFrequency> = 20...20000, count: Int = 256) -> [AudioGain]{
        gainFrequencyResponse(Vector.createFrequenciesLogScale(in: freqRange, count: count))
    }
    public func phaseFrequencyResponse(_ frequencies: [AudioFrequency]) -> [AudioPhase]{
        Vector.create(radians: Vector.phase(frequencyResponse(frequencies)))
    }
    public func phaseFrequencyResponse(in freqRange: ClosedRange<AudioFrequency> = 20...20000, count: Int = 256) -> [AudioPhase]{
        phaseFrequencyResponse(Vector.createFrequenciesLogScale(in: freqRange, count: count))
    }
    public func relativePhaseFrequencyResponse(_ frequencies: [AudioFrequency]) -> [AudioPhase]{
        let phases = Vector.phase(frequencyResponse(frequencies))
        let delays = vDSP.multiply(bassGroupDelay, Vector<AudioFrequency>.angularVelocities(of: frequencies))
        let results_yet_remainded = vDSP.add(phases, delays)
        let results = vForce.remainder(dividends: results_yet_remainded, divisors: Vector<Double>.create(repeating: .pi * 2, count: results_yet_remainded.count))
        return Vector.create(radians: results)
    }
    public func relativePhaseFrequencyResponse(in freqRange: ClosedRange<AudioFrequency> = 20...20000, count: Int = 256) -> [AudioPhase]{
        relativePhaseFrequencyResponse(Vector.createFrequenciesLogScale(in: freqRange, count: count))
    }
    public func continuousPhaseFrequencyResponse(in freqRange: ClosedRange<AudioFrequency> = 20...20000, count: Int = 256) -> [AudioPhase]{
        Vector.convertToContinuousBranch(phaseVector: phaseFrequencyResponse(in: freqRange, count: count))
    }
    public func continuousRelativePhaseFrequencyResponse(in freqRange: ClosedRange<AudioFrequency> = 20...20000, count: Int = 256) -> [AudioPhase]{
        Vector.convertToContinuousBranch(phaseVector: relativePhaseFrequencyResponse(in: freqRange, count: count))
    }
}
