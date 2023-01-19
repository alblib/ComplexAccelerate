//
//  File.swift
//
//
//  Created by Albertus Liberius on 2022-12-27.
//

import Foundation
import Accelerate

public struct DigitalTransferFunction{
    
    public let zInverseExpression: PolynomialFraction<Double>
    public let sampleRate: AudioFrequency
    
    public init(zInverseExpression: PolynomialFraction<Double>, sampleRate: AudioFrequency) {
        self.zInverseExpression = zInverseExpression
        self.sampleRate = sampleRate
    }
    
    public static func identity(sampleRate: AudioFrequency) -> DigitalTransferFunction{
        DigitalTransferFunction(zInverseExpression: .one, sampleRate: sampleRate)
    }
    
    
    public func bilinearTransformToAnalog() -> AnalogTransferFunction{
        let coeff: Double = 1 / (2 * self.sampleRate.inHertz)
        let sTransform = PolynomialFraction(numerator: .init(coefficients: [1, -coeff]), denominator: .init(coefficients: [1, coeff]))
        return AnalogTransferFunction(sExpression: zInverseExpression.substitute(variable: sTransform))
    }
    
}

extension DigitalTransferFunction: CustomStringConvertible{
    static let formatter = PolynomialFormatter(variable: .init("𝑧", exponent: -1))
    
    public var description: String {
        "𝐻(𝑧) = " + DigitalTransferFunction.formatter.string(from: zInverseExpression)
    }
}

// MARK: Properties
extension DigitalTransferFunction: TransferFunction{
    
    /// Calculates the values of the transfer function 𝐻(𝑧 = exp(2𝜋𝑖𝑓/𝑓ₛ)) parallely with given input frequencies [𝑓].
    public func frequencyResponse(_ frequencies: [AudioFrequency]) -> [Complex<Double>]{
        let minusPhases = Vector.divide(Vector.angularVelocities(of: frequencies), -sampleRate.inHertz)
        return zInverseExpression.evaluate(withUnitComplexesOfPhases: minusPhases)
    }
    
    public var bassGain: AudioGain{
        AudioGain(byAmplitude: vDSP.sum(self.zInverseExpression.numerator.coefficients) / vDSP.sum(self.zInverseExpression.denominator.coefficients))
    }
    public var bassGroupDelay: TimeInterval{
        func nAnSum(_ array: [Double]) -> Double{
            vDSP.dot(Array(0..<array.count).map{Double($0)}, array)
        }
        func sum(_ array: [Double]) -> Double{
            vDSP.sum(array)
        }
        
        let sumOfAi = sum(self.zInverseExpression.denominator.coefficients)
        let sumOfBi = sum(self.zInverseExpression.numerator.coefficients)
        let sumOfiAi = nAnSum(self.zInverseExpression.denominator.coefficients)
        let sumOfiBi = nAnSum(self.zInverseExpression.numerator.coefficients)
        return (sumOfiBi / sumOfBi - sumOfiAi / sumOfAi) / sampleRate.inHertz
    }
}
/*
public extension DigitalTransferFunction{
    static func LinearPhaseFIRFilter(frequencyResponse: ((AudioFrequency) -> DSPDoubleComplex), sampleRate: AudioFrequency, sampleSize: FFTSize) -> DigitalTransferFunction{
        // TODO: define
        let count = sampleSize.count
        let unitFrequency = sampleRate.inHertz / Double(count)
        
        
        let interleavedDFT = try? vDSP.DiscreteFourierTransform(previous: nil,
                                                                count: sampleSize.count,
                                                                direction: .forward,
                                                                transformType: .complexComplex,
                                                                ofType: DSPDoubleComplex.self)
        
        
        return .identity(sampleRate: sampleRate)
    }
}

/*
public extension DigitalTransferFunction{
    static func FIRFilter(frequencyResponse: ((AudioFrequency) -> DSPDoubleComplex), sampleRate: AudioFrequency, sampleSize: FFTSize) -> (filter: DigitalTransferFunction, actualSampleSize: Int, additionalGroupDelay: TimeInterval){
        // TODO: define
        
        let interleavedDFT = try? vDSP.DiscreteFourierTransform(previous: nil,
                                                                count: sampleSize.count,
                                                                direction: .forward,
                                                                transformType: .complexComplex,
                                                                ofType: DSPDoubleComplex.self)
        __builtin_clz
        
        return .identity(sampleRate: sampleRate)
    }
}
*/
*/
