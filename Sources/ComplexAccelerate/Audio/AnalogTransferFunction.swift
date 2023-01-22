//
//  AnalogTransferFunction.swift
//
//
//  Created by Albertus Liberius on 2022-12-27.
//

import Foundation
import Accelerate

/// Defines a transfer function 𝐻(𝑠).
public struct AnalogTransferFunction{
    /// The transfer function 𝐻(𝑠) in terms of 𝑠.
    public let sExpression: PolynomialFraction<Double>
    
    public init(sExpression: PolynomialFraction<Double>){
        self.sExpression = sExpression
    }
    
    public var identity: Self{
        AnalogTransferFunction(sExpression: .one)
    }
    
    public func bilinearTransformToDigital(sampleRate: AudioFrequency) -> DigitalTransferFunction{
        // s = f(z)
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
    public static func firstOrderShelvingFilter(centerFrequency: AudioFrequency, bassGain: AudioGain, trebleGain: AudioGain) -> AnalogTransferFunction
    {
        // H(s) = H(inf) * (s/(2pi fc) + sqrt(H(0)/H(inf))) / (s/(2pi fc) + sqrt(H(inf)/H(0)))
        let sCoeff = 1 / centerFrequency.inRadiansPerSecond
        let sqrtH0overHinf = sqrt(bassGain.byAmplitude / trebleGain.byAmplitude)
        let numerator: Polynomial<Double> = [sqrtH0overHinf, sCoeff]
        let denominator: Polynomial<Double> = [1 / sqrtH0overHinf, sCoeff]
        return .init(sExpression: trebleGain.byAmplitude * numerator / denominator)
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

extension AnalogTransferFunction{
    public static var weightK: AnalogTransferFunction{
        // https://www.itu.int/dms_pubrec/itu-r/rec/bs/R-REC-BS.1770-0-200607-S!!PDF-E.pdf
        AnalogTransferFunction(sExpression: [1.125945072697908e8, 18886.914378028894, 1.5848647011308556] / [1.125945072697908e8, 15004.846526655718, 1])
    }
    
    //https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4331191/
    public static var weightA: AnalogTransferFunction{
        AnalogTransferFunction(
            sExpression:
                [0, 0, 0, 0, 1.3780221280022709e10]
                / [3.08375028205341e20, 5.295693853630862e18, 2.6718101443475372e16,
                   3.340095613379588e13, 6.728668228324725e9, 158808.43147552284, 1])
    
    }
    
    //https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4331191/
    public static var weightC: AnalogTransferFunction{
        AnalogTransferFunction(
            sExpression:
                [0, 0, 7.1587509876576e9]
                / [9.8337567314626e13, 1.522146745441614e12, 5.910081257945861e9, 153495.90480450515, 1])
    
    }
}
