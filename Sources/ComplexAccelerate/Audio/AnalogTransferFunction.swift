//
//  AnalogTransferFunction.swift
//
//
//  Created by Albertus Liberius on 2022-12-27.
//

import Foundation
import Accelerate

public struct AnalogTransferFunction{
    public let sExpression: PolynomialFraction<Double>
    
    public init(sExpression: PolynomialFraction<Double>){
        self.sExpression = sExpression
    }
    
    public var identity: Self{
        AnalogTransferFunction(sExpression: .one)
    }
    
    public func bilinearTransformToDigital(sampleRate: AudioFrequency) -> DigitalTransferFunction{
        let zTransform = 2 * sampleRate.inHertz * PolynomialFraction(numerator: .init(coefficients: [1, -1]), denominator: .init(coefficients: [1, 1]))
        return DigitalTransferFunction(zInverseExpression: sExpression.substitute(variable: zTransform), sampleRate: sampleRate)
    }
}


extension AnalogTransferFunction: CustomStringConvertible{
    static let formatter = PolynomialFormatter(variable: "𝑠")
    
    public var description: String {
        "𝐻(𝑠) = " + AnalogTransferFunction.formatter.string(from: sExpression)
    }
}


// MARK: Properties
extension AnalogTransferFunction: TransferFunction{
    
    
    public var bassGain: AudioGain {
        AudioGain(byAmplitude: (self.sExpression.numerator.coefficients.first ?? 0) / (self.sExpression.denominator.coefficients.first ?? 0))
    }
    
    public var bassGroupDelay: TimeInterval {
        let A0 = sExpression.denominator.coefficient(order: 0)
        let A1 = sExpression.denominator.coefficient(order: 1)
        let B0 = sExpression.numerator.coefficient(order: 0)
        let B1 = sExpression.numerator.coefficient(order: 1)
        return (B0 * A1 - B1 * A0) / (B0 * A0)
    }
    
    /// Calculates the values of the transfer function 𝐻(𝑠 = 2𝜋𝑖𝑓)) parallely for each tab.
    public func frequencyResponse(_ frequencies: [AudioFrequency]) -> [Complex<Double>]{
        let s = Vector<Complex<Double>>.multiply(Complex<Double>.I, Vector<Complex<Double>>.castToComplexes(Vector.angularVelocities(of: frequencies)))
        return sExpression.evaluate(variable: s)
    }
}


// MARK: - Filters
// https://www.mathworks.com/help//sps/powersys/ref/secondorderfilter.html
extension AnalogTransferFunction{
    public static func firstOrderLowPassFilter(cutoffFrequency: AudioFrequency) -> AnalogTransferFunction{
        AnalogTransferFunction(sExpression: .init(numerator: .one, denominator: Polynomial(coefficients: [1, 1 / (2 * Double.pi * cutoffFrequency.inHertz)])))
    }
    public static func firstOrderHighPassFilter(cutoffFrequency: AudioFrequency) -> AnalogTransferFunction{
        let RC = 1 / cutoffFrequency.inRadiansPerSecond
        return AnalogTransferFunction(sExpression: .init(numerator: Polynomial(coefficients: [0, RC]), denominator: Polynomial(coefficients: [1, RC])))
    }
    public static func secondOrderLowPassFilter(cornerFrequency: AudioFrequency, dampingRatio zeta: Double) -> AnalogTransferFunction{
        let omega = cornerFrequency.inRadiansPerSecond
        let omega2 = omega * omega
        return AnalogTransferFunction(sExpression: PolynomialFraction(
            numerator: Polynomial(coefficients: [omega2]),
            denominator: Polynomial(coefficients: [omega2, 2 * zeta * omega, 1])))
    }
    public static func secondOrderLowPassFilter(cornerFrequency: AudioFrequency, qualityFactor Q: Double) -> AnalogTransferFunction{
        return secondOrderLowPassFilter(cornerFrequency: cornerFrequency, dampingRatio: 1 / (2 * Q))
    }
    public static func secondOrderHighPassFilter(cornerFrequency: AudioFrequency, dampingRatio zeta: Double) -> AnalogTransferFunction{
        let omega = cornerFrequency.inRadiansPerSecond
        return AnalogTransferFunction(sExpression: PolynomialFraction(
            numerator: Polynomial(coefficients: [0,0,1]),
            denominator: Polynomial(coefficients: [omega * omega, 2 * zeta * omega, 1])))
    }
    public static func secondOrderHighPassFilter(cornerFrequency: AudioFrequency, qualityFactor Q: Double) -> AnalogTransferFunction{
        return secondOrderHighPassFilter(cornerFrequency: cornerFrequency, dampingRatio: 1 / (2 * Q))
    }
    public static func secondOrderBandPassFilter(centerFrequency: AudioFrequency, dampingRatio zeta: Double) -> AnalogTransferFunction{
        let omega = centerFrequency.inRadiansPerSecond
        return AnalogTransferFunction(sExpression: PolynomialFraction(
            numerator: Polynomial(coefficients: [0, 2 * zeta * omega]),
            denominator: Polynomial(coefficients: [omega * omega, 2 * zeta * omega, 1])))
    }
    public static func secondOrderBandPassFilter(centerFrequency: AudioFrequency, qualityFactor Q: Double) -> AnalogTransferFunction{
        return secondOrderBandPassFilter(centerFrequency: centerFrequency, dampingRatio: 1 / (2 * Q))
    }
    public static func secondOrderBandStopFilter(centerFrequency: AudioFrequency, dampingRatio zeta: Double) -> AnalogTransferFunction{
        let omega = centerFrequency.inRadiansPerSecond
        let omega2 = omega * omega
        return AnalogTransferFunction(sExpression: PolynomialFraction(
            numerator: Polynomial(coefficients: [omega2, 0, 1]),
            denominator: Polynomial(coefficients: [omega2, 2 * zeta * omega, 1])))
    }
    public static func secondOrderBandStopFilter(centerFrequency: AudioFrequency, qualityFactor Q: Double) -> AnalogTransferFunction{
        return secondOrderBandStopFilter(centerFrequency: centerFrequency, dampingRatio: 1 / (2 * Q))
    }
}


