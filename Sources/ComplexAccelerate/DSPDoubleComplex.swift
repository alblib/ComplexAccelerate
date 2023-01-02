//
//  DSPDoubleComplex.swift
//  
//
//  Created by Albertus Liberius on 2023-01-02.
//

import Foundation
import Accelerate

extension DSPDoubleComplex: CustomStringConvertible{
    public var description: String{
        return "(" + real.description + (imag.sign == .minus ? "-" : "+") + abs(imag).description + "𝒊)" //"𝑖"
    }
}

extension DSPDoubleComplex: ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral{
    public init(integerLiteral value: Int) {
        self.init(real: Double(value), imag: 0)
    }
    public init(floatLiteral value: Double) {
        self.init(real: value, imag: 0)
    }
}

func * (lhs: Double, rhs: DSPDoubleComplex) -> DSPDoubleComplex{
    return DSPDoubleComplex(real: lhs * rhs.real, imag: lhs * rhs.imag)
}

func * (lhs: DSPDoubleComplex, rhs: Double) -> DSPDoubleComplex{
    return DSPDoubleComplex(real: lhs.real * rhs, imag: lhs.imag * rhs)
}

func * (lhs: DSPDoubleComplex, rhs: DSPDoubleComplex) -> DSPDoubleComplex{
    return DSPDoubleComplex(
        real: lhs.real * rhs.real - lhs.imag * rhs.imag,
        imag: lhs.imag * rhs.real + lhs.real * rhs.imag)
}

func / (lhs: Double, rhs: DSPDoubleComplex) -> DSPDoubleComplex{
    let denominator = rhs.real * rhs.real + rhs.imag * rhs.imag
    return DSPDoubleComplex(real: lhs * rhs.real / denominator,
                      imag: -lhs * rhs.imag / denominator)
}

func / (lhs: DSPDoubleComplex, rhs: Double) -> DSPDoubleComplex{
    return DSPDoubleComplex(real: lhs.real / rhs, imag: lhs.imag / rhs)
}

func / (lhs: DSPDoubleComplex, rhs: DSPDoubleComplex) -> DSPDoubleComplex{
    let denominator = rhs.real * rhs.real + rhs.imag * rhs.imag
    let rhsInverse = DSPDoubleComplex(real: rhs.real / denominator,
                      imag: -rhs.imag / denominator)
    return lhs * rhsInverse
}
