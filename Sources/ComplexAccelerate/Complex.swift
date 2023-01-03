//
//  Complex.swift
//  
//
//  Created by Albertus Liberius on 2023-01-03.
//

import Foundation

public protocol ParallelizableFloatingPoint: BinaryFloatingPoint{}
extension Float: ParallelizableFloatingPoint{}
extension Double: ParallelizableFloatingPoint{}

/// A full-fledged structure for a general complex number.
public struct Complex<Real> {
    public var real: Real
    public var imag: Real
    public init(real: Real, imag: Real) {
        self.real = real
        self.imag = imag
    }
}

extension Complex: ExpressibleByFloatLiteral where Real: ExpressibleByFloatLiteral{
    public init(floatLiteral value: Real.FloatLiteralType) {
        self.real = Real(floatLiteral: value)
        self.imag = Real(floatLiteral: 0.0 as! Real.FloatLiteralType) // _ExpressibleByBuiltinFloatLiteral = {Float, Double, Float80}
    }
}

extension Complex: ExpressibleByIntegerLiteral where Real: ExpressibleByIntegerLiteral{
    public init(){
        self.real = 0
        self.imag = 0
    }
    public init(integerLiteral value: Real.IntegerLiteralType) {
        self.real = Real(integerLiteral: value)
        self.imag = 0
    }
}

extension Complex: Equatable where Real: Equatable{
    public static func == (lhs: Complex<Real>, rhs: Complex<Real>) -> Bool{
        (lhs.real == rhs.real) && (lhs.imag == rhs.imag)
    }
}

extension Complex: Hashable where Real: Hashable{
    public func hash(into hasher: inout Hasher) {
        hasher.combine(real)
        hasher.combine(imag)
    }
}

extension Complex: AdditiveArithmetic where Real: AdditiveArithmetic{
    public static func + (lhs: Complex<Real>, rhs: Complex<Real>) -> Complex<Real> {
        .init(real: lhs.real + rhs.real, imag: lhs.imag + rhs.imag)
    }
    
    public static func += (lhs: inout Complex<Real>, rhs: Complex<Real>){
        lhs.real += rhs.real
        lhs.imag += rhs.imag
    }
    
    public static func - (lhs: Complex<Real>, rhs: Complex<Real>) -> Complex<Real> {
        .init(real: lhs.real - rhs.real, imag: lhs.imag - rhs.imag)
    }
    
    public static func -= (lhs: inout Complex<Real>, rhs: Complex<Real>){
        lhs.real -= rhs.real
        lhs.imag -= rhs.imag
    }
    
    public static var zero: Complex<Real>{
        .init(real: .zero, imag: .zero)
    }
}


extension Complex: Numeric where Real: Numeric, Real.Magnitude: FloatingPoint {
    public init?<T>(exactly source: T) where T : BinaryInteger {
        guard let exactly = Real(exactly: source) else{
            return nil
        }
        self.real = exactly
        self.imag = .zero
    }
    
    public static func * (lhs: Complex<Real>, rhs: Complex<Real>) -> Complex<Real> {
        .init(real: lhs.real * rhs.real - lhs.imag * rhs.imag, imag: lhs.real * rhs.imag + lhs.imag * rhs.real)
    }
    
    public static func *= (lhs: inout Complex<Real>, rhs: Complex<Real>) {
        lhs = lhs * rhs
    }
    
    
    public var magnitude: Real.Magnitude{
        let realMagnitude = real.magnitude
        let imagMagnitude = imag.magnitude
        return sqrt(realMagnitude * realMagnitude + imagMagnitude * imagMagnitude)
    }
    
    public static var one: Complex<Real>{
        .init(real: 1, imag: .zero)
    }
    
    public static var I: Complex<Real>{
        .init(real: .zero, imag: 1)
    }
}

extension Complex: SignedNumeric where Real: SignedNumeric, Real.Magnitude: FloatingPoint{
    public static prefix func - (_ op: Complex<Real>) -> Complex<Real>{
        .init(real: -op.real, imag: -op.imag)
    }
    public mutating func negate() {
        real.negate()
        imag.negate()
    }
}

