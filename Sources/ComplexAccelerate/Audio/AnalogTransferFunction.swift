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
    /*
    public func bilinearTransformToDigital(sampleRate: AudioFrequency) -> DigitalTransferFunction{
        let zTransform = 2 * sampleRate.inHertz * PolynomialFraction(numerator: .init(coefficients: [1, -1]), denominator: .init(coefficients: [1, 1]))
        return DigitalTransferFunction(zInverseExpression: sExpression.substitute(variableBy: zTransform), sampleRate: sampleRate)
    }*/
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
    
    /*
    public func frequencyResponse(_ frequency: AudioFrequency) -> DSPDoubleComplex{
        let order = self.sExpression.order
        let orderCounting = vDSP.integerToFloatingPoint(Array(Int32(0)...Int32(order)), floatingPointType: Double.self)
        let omegaNPowers = vForce.pow(base: frequency.angularVelocity, exponents: orderCounting)
        let denominator = vDSP.multiply(omegaNPowers[0..<self.sExpression.denominator.coefficients.count], self.sExpression.denominator.coefficients)
        let numerator = vDSP.multiply(omegaNPowers[0..<self.sExpression.numerator.coefficients.count], self.sExpression.numerator.coefficients)
        print(denominator, numerator)
        let denominatorComplex =
            denominator.withUnsafeBufferPointer { ptr in
                let denPtr = ptr.baseAddress!
                var denMod0: Double = 0
                vDSP_sveD(denPtr, vDSP_Stride(4), &denMod0, vDSP_Length((denominator.count+3) / 4))
                var denMod1: Double = 0
                vDSP_sveD(denPtr + 1, vDSP_Stride(4), &denMod1, vDSP_Length((denominator.count+2) / 4))
                var denMod2: Double = 0
                vDSP_sveD(denPtr + 2, vDSP_Stride(4), &denMod2, vDSP_Length((denominator.count+1) / 4))
                var denMod3: Double = 0
                vDSP_sveD(denPtr + 3, vDSP_Stride(4), &denMod3, vDSP_Length((denominator.count) / 4))
                return DSPDoubleComplex(real: denMod0 - denMod2, imag: denMod1 - denMod3)
            }
        let numeratorComplex =
            numerator.withUnsafeBufferPointer { numPtr in
                let ptr = numPtr.baseAddress!
                var numMod0: Double = 0
                vDSP_sveD(ptr, vDSP_Stride(4), &numMod0, vDSP_Length((numerator.count+3) / 4))
                var numMod1: Double = 0
                vDSP_sveD(ptr + 1, vDSP_Stride(4), &numMod1, vDSP_Length((numerator.count+2) / 4))
                var numMod2: Double = 0
                vDSP_sveD(ptr + 2, vDSP_Stride(4), &numMod2, vDSP_Length((numerator.count+1) / 4))
                var numMod3: Double = 0
                vDSP_sveD(ptr + 3, vDSP_Stride(4), &numMod3, vDSP_Length((numerator.count) / 4))
                return DSPDoubleComplex(real: numMod0 - numMod2, imag: numMod1 - numMod3)
            }
        return numeratorComplex / denominatorComplex
    }
    */
    public func frequencyResponse(_ frequencies: [AudioFrequency]) -> [DSPDoubleComplex]{
        if frequencies.isEmpty{
            return []
        }
        let parallelOmegas = Vector.angularVelocities(of: frequencies)
        var omegaNPowers: [[Double]] = Array(repeating: [], count: max(2, self.sExpression.order + 1))
        omegaNPowers[0] = Array(repeating: 1, count: parallelOmegas.count)
        omegaNPowers[1] = parallelOmegas
        for i in 2..<omegaNPowers.count{
            omegaNPowers[i] = vDSP.multiply(parallelOmegas, omegaNPowers[i-1])
        }
        //resultReal: [Double] = Array(repeating: 0, count: omegaNPowers.first!.count)
        //resultImag: [Double] = Array(repeating: 0, count: omegaNPowers.first!.count)
        func sRealization(coefficients: [Double], omegaNPowers: [[Double]], resultReal: inout [Double], resultImag: inout [Double]){
            for i in 0..<(coefficients.count+3)/4{
                let index = 4*i
                resultReal = vDSP.add(multiplication: (a: omegaNPowers[index], b: coefficients[index]), resultReal)
            }
            for i in 0..<(coefficients.count+2)/4{
                let index = 4*i+1
                resultImag = vDSP.add(multiplication: (a: omegaNPowers[index], b: coefficients[index]), resultImag)
            }
            for i in 0..<(coefficients.count+1)/4{
                let index = 4*i+2
                resultReal = vDSP.add(multiplication: (a: omegaNPowers[index], b: -coefficients[index]), resultReal)
            }
            for i in 0..<(coefficients.count)/4{
                let index = 4*i+3
                resultImag = vDSP.add(multiplication: (a: omegaNPowers[index], b: -coefficients[index]), resultImag)
            }
        }
        var numReal: [Double] = Array(repeating: 0, count: frequencies.count)
        var numImag: [Double] = Array(repeating: 0, count: frequencies.count)
        var denReal: [Double] = Array(repeating: 0, count: frequencies.count)
        var denImag: [Double] = Array(repeating: 0, count: frequencies.count)
        sRealization(coefficients: self.sExpression.numerator.coefficients, omegaNPowers: omegaNPowers, resultReal: &numReal, resultImag: &numImag)
        sRealization(coefficients: self.sExpression.denominator.coefficients, omegaNPowers: omegaNPowers, resultReal: &denReal, resultImag: &denImag)
        
        var numRP = UnsafeMutablePointer(mutating: numReal)
        var numIP = UnsafeMutablePointer(mutating: numImag)
        var denRP = UnsafeMutablePointer(mutating: denReal)
        var denIP = UnsafeMutablePointer(mutating: denImag)
        var numP = DSPDoubleSplitComplex(realp: numRP, imagp: numIP)
        var denP = DSPDoubleSplitComplex(realp: denRP, imagp: denIP)
        var resultReal: [Double] = Array(repeating: 0, count: frequencies.count)
        var resultImag: [Double] = Array(repeating: 0, count: frequencies.count)
        var resultRP = UnsafeMutablePointer(mutating: resultReal)
        var resultIP = UnsafeMutablePointer(mutating: resultImag)
        var resultP = DSPDoubleSplitComplex(realp: resultRP, imagp: resultIP)
        vDSP.divide(numP, by: denP, count: frequencies.count, result: &resultP)
        var result = Array(repeating: DSPDoubleComplex(), count: frequencies.count)
        vDSP.convert(splitComplexVector: resultP, toInterleavedComplexVector: &result)
        return result
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


