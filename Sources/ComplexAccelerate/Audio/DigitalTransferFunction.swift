//
//  File.swift
//
//
//  Created by Albertus Liberius on 2022-12-27.
//

import Foundation
import Accelerate

/// Defines a digital transfer function 𝐻(𝑧) with the given sample rate.
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

public extension DigitalTransferFunction{
    static func LinearPhaseFIRFilter(frequencyResponse: ((AudioFrequency) -> AudioGain), sampleRate: AudioFrequency, sampleSize: Int) -> DigitalTransferFunction?{
        
        let log2n: UInt = {
            if sampleSize <= 16{
                return 4
            }
            var temp = (sampleSize - 1) >> 4
            var int: UInt = 4
            while temp > 0 {
                int += 1
                temp >>= 1
            }
            return int
        }()
        
        let realSize = 1 << log2n
        
        let sampleFrequencies = Vector.create(frequenciesInHertz: vDSP.multiply(sampleRate.inHertz / 2 / Double(realSize), vDSP.ramp(withInitialValue: 0, increment: 1, count: realSize)))
        
        let sampleMagnitudes: [Double] = sampleFrequencies.map{frequencyResponse($0).byAmplitude}
        
        let sampleArguments: [Double] = vDSP.ramp(withInitialValue: 0, increment: -Double(2 * realSize - 1) / Double(2 * realSize) * Double.pi, count: realSize)
        
        let sampleArgumentComplexes: [DSPDoubleComplex] =
            Vector<DSPDoubleComplex>.expi(sampleArguments)
        
        let halfFFTSamples =
            Vector<DSPDoubleComplex>
                .multiply(sampleArgumentComplexes, sampleMagnitudes)
        
        let fftSamples = halfFFTSamples + [.init(real: 0, imag: 0)] + Vector.conjugate(halfFFTSamples).reversed().dropLast(1)
        
        let interleavedDFT =
            try? vDSP.DiscreteFourierTransform(
                previous: nil, count: 2 * realSize,
                direction: .inverse, transformType: .complexComplex,
                ofType: DSPDoubleComplex.self)
        let interleavedOutput = interleavedDFT?.transform(input: fftSamples)
        
        let thePolynomial =
            Polynomial(coefficients: Vector.divide(Vector.reals(interleavedOutput!), Double(2 * realSize)))
        return DigitalTransferFunction(zInverseExpression: .init(numerator: thePolynomial, denominator: .one), sampleRate: sampleRate)
    }
    
    
    static func LinearPhaseFIRFilter(frequencyResponse: ((AudioFrequency) -> AudioGain), sampleRate: AudioFrequency, demandedFrequencyResolutionInHertz: Double) -> DigitalTransferFunction?
    {
        LinearPhaseFIRFilter(frequencyResponse: frequencyResponse, sampleRate: sampleRate, sampleSize: Int(ceil(sampleRate.inHertz / demandedFrequencyResolutionInHertz / 4)))
    }
    static func LinearPhaseFIRFilter(frequencyResponse: ((AudioFrequency) -> AudioGain), sampleRate: AudioFrequency, maxDelay: TimeInterval) -> DigitalTransferFunction?
    {
        LinearPhaseFIRFilter(frequencyResponse: frequencyResponse, sampleRate: sampleRate, sampleSize: Int(ceil(sampleRate.inHertz * maxDelay * 2 + 1)))
    }
    static func LinearPhaseFIRFilter(frequencyResponse: ((AudioFrequency) -> AudioGain), sampleRate: AudioFrequency, demandedFrequencyResolutionInHertz: Double, maxDelay: TimeInterval) -> DigitalTransferFunction?
    {
        LinearPhaseFIRFilter(frequencyResponse: frequencyResponse, sampleRate: sampleRate, sampleSize: Int(ceil(max(sampleRate.inHertz / demandedFrequencyResolutionInHertz / 4, sampleRate.inHertz * maxDelay * 2 + 1))))
    }
}


