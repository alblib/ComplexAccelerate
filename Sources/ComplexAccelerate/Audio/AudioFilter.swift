//
//  AudioFilter.swift
//  
//
//  Created by Albertus Liberius on 2022-12-03.
//

import Foundation
import Accelerate

public struct AudioFilter{
    public var sampleRate: AudioFrequency{
        didSet{
            if analogTransferFunctionInS != nil {
                let zTransform = 2 * sampleRate.inHertz * PolynomialFraction<Double>(numerator: .init(coefficients: [1, -1]), denominator: .init(coefficients: [1, 1]))
                digitalTransferFunctionInZInverse = analogTransferFunctionInS!.substitute(variable: zTransform)
            }
        }
    }
    public var analogTransferFunctionInS: PolynomialFraction<Double>?{
        didSet{
            if analogTransferFunctionInS != nil {
                let zTransform = 2 * sampleRate.inHertz * PolynomialFraction<Double>(numerator: .init(coefficients: [1, -1]), denominator: .init(coefficients: [1, 1]))
                digitalTransferFunctionInZInverse = analogTransferFunctionInS!.substitute(variable: zTransform)
            }
        }
    }
    public var digitalTransferFunctionInZInverse: PolynomialFraction<Double> = .one{
        didSet{
            analogTransferFunctionInS = nil
        }
    }
    @frozen public enum `Type`{
        case analog
        case digital
    }
    public var type: Type{
        analogTransferFunctionInS == nil ? .digital : .analog
    }
    
    public init(analogInS: PolynomialFraction<Double>, sampleRate: AudioFrequency){
        self.analogTransferFunctionInS = analogInS
        self.sampleRate = sampleRate
        
        let zTransform = 2 * sampleRate.inHertz * PolynomialFraction<Double>(numerator: .init(coefficients: [1, -1]), denominator: .init(coefficients: [1, 1]))
        digitalTransferFunctionInZInverse = analogTransferFunctionInS!.substitute(variable: zTransform)
    }
    public init(digitalInZInverse: PolynomialFraction<Double>, sampleRate: AudioFrequency){
        self.analogTransferFunctionInS = nil
        self.sampleRate = sampleRate
        self.digitalTransferFunctionInZInverse = digitalInZInverse
    }
}

extension AudioFilter: CustomStringConvertible{
    public var description: String{
        switch type{
        case .analog:
            let formatter = PolynomialFormatter(variable: "𝑠")
            return "𝐻(𝑠) = " + formatter.string(from: analogTransferFunctionInS!)
        case .digital:
            let formatter = PolynomialFormatter(variable: .init("𝑧", exponent: -1))
            return "𝐻(𝑧) = " + formatter.string(from: digitalTransferFunctionInZInverse)
        }
    }
}

// MARK: Properties
extension AudioFilter{
    public var bassGain: AudioGain{
        AudioGain(byAmplitude: vDSP.sum(self.digitalTransferFunctionInZInverse.numerator.coefficients) / vDSP.sum(self.digitalTransferFunctionInZInverse.denominator.coefficients))
    }
    public var bassGroupDelay: TimeInterval{
        func nAnSum(_ array: [Double]) -> Double{
            vDSP.dot(vDSP.ramp(withInitialValue: 0, increment: 1, count: array.count), array)
        }
        func sum(_ array: [Double]) -> Double{
            vDSP.sum(array)
        }
        
        let sumOfAi = sum(self.digitalTransferFunctionInZInverse.denominator.coefficients)
        let sumOfBi = sum(self.digitalTransferFunctionInZInverse.numerator.coefficients)
        let sumOfiAi = nAnSum(self.digitalTransferFunctionInZInverse.denominator.coefficients)
        let sumOfiBi = nAnSum(self.digitalTransferFunctionInZInverse.numerator.coefficients)
        return (sumOfiBi / sumOfBi - sumOfiAi / sumOfAi) / sampleRate.inHertz
    }
}


extension AudioFilter{
    
    /// Calculates the values of the transfer function 𝐻(𝑧 = exp(2𝜋𝑖𝑓/𝑓ₛ)) parallely with given input frequencies [𝑓].
    ///
    /// If the taps of the filter is more than the size of the set of the input frequencies, it is better to use ``frequencyResponse(_:)-50sj``.
    public func frequencyResponse(_ frequencies: [AudioFrequency]) -> [DSPDoubleComplex]{
        let sampleSize = frequencies.count
        let tapSize = max(digitalTransferFunctionInZInverse.numerator.coefficients.count, digitalTransferFunctionInZInverse.denominator.coefficients.count)
            return []
    }
}
