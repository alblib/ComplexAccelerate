//
//  DSPComplex.swift
//  
//
//  Created by Albertus Liberius on 2023-01-01.
//

import Foundation
import Accelerate

extension DSPComplex: CustomStringConvertible{
    public var description: String{
        return "(" + real.description + (imag.sign == .minus ? "-" : "+") + abs(imag).description + "𝒊)" //"𝑖"
    }
}

extension DSPComplex: ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral{
    public init(integerLiteral value: Int) {
        self.init(real: Float(value), imag: 0)
    }
    public init(floatLiteral value: Float) {
        self.init(real: value, imag: 0)
    }
}


func * (lhs: Float, rhs: DSPComplex) -> DSPComplex{
    return DSPComplex(real: lhs * rhs.real, imag: lhs * rhs.imag)
}

func * (lhs: DSPComplex, rhs: Float) -> DSPComplex{
    return DSPComplex(real: lhs.real * rhs, imag: lhs.imag * rhs)
}

func * (lhs: DSPComplex, rhs: DSPComplex) -> DSPComplex{
    return DSPComplex(
        real: lhs.real * rhs.real - lhs.imag * rhs.imag,
        imag: lhs.imag * rhs.real + lhs.real * rhs.imag)
}



func / (lhs: Float, rhs: DSPComplex) -> DSPComplex{
    let denominator = rhs.real * rhs.real + rhs.imag * rhs.imag
    return DSPComplex(real: lhs * rhs.real / denominator,
                      imag: -lhs * rhs.imag / denominator)
}

func / (lhs: DSPComplex, rhs: Float) -> DSPComplex{
    return DSPComplex(real: lhs.real / rhs, imag: lhs.imag / rhs)
}

func / (lhs: DSPComplex, rhs: DSPComplex) -> DSPComplex{
    let denominator = rhs.real * rhs.real + rhs.imag * rhs.imag
    let rhsInverse = DSPComplex(real: rhs.real / denominator,
                      imag: -rhs.imag / denominator)
    return lhs * rhsInverse
}
