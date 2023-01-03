//
//  Complex.swift
//  
//
//  Created by Albertus Liberius on 2023-01-03.
//

import Foundation
/*
public protocol ParallelizableFloatingPoint: BinaryFloatingPoint{}
extension Float: ParallelizableFloatingPoint{}
extension Double: ParallelizableFloatingPoint{}
 */

// MARK: Definition

/// A full-fledged structure for a general complex number.
///
/// This structure is a doublet of given `Real` type, full-fledged operations and functions of which is implemented while the `Real` has also implementation for such operations.
public struct Complex<Real> {
    /// The real part of the value.
    /// - Remark: This comes the first place in the structure. This property, thus, has the same memory address to the structure itself.
    public var real: Real
    /// The imaginary part of the value.
    /// - Remark: This comes the second place in the structure. This property, thus, has one-place-advanced memory address (in the sense of `Real` type) to the structure itself.
    public var imag: Real
    /// The default initializer, initializing each real and imaginary parts by given two `Real` values.
    public init(real: Real, imag: Real) {
        self.real = real
        self.imag = imag
    }
}

extension Complex: CustomStringConvertible where Real: CustomStringConvertible{
    public var description: String{
        if Real.self is any FloatingPoint.Type{
            if (imag as! (any FloatingPoint)).isZero{
                return real.description
            }else if (real as! (any FloatingPoint)).isZero{
                return imag.description + "𝒊"
            }else{
                return "(" + real.description + ((imag as! Double).sign == .minus ? "-" : "+") + (imag as! Double).magnitude.description + "𝒊)"
            }
        }else{
            return "Complex<\(Real.self)>(" + real.description + "," + imag.description + ")"
        }
    }
}


// MARK: - ExpressibleByFloatLiteral
extension Complex: ExpressibleByFloatLiteral where Real: ExpressibleByFloatLiteral{
    public init(floatLiteral value: Real.FloatLiteralType) {
        self.real = Real(floatLiteral: value)
        self.imag = Real(floatLiteral: 0.0 as! Real.FloatLiteralType) // _ExpressibleByBuiltinFloatLiteral = {Float, Double, Float80}
    }
}


// MARK: - ExpressibleByIntegerLiteral
extension Complex: ExpressibleByIntegerLiteral where Real: ExpressibleByIntegerLiteral{
    /// Initialize the structure all by zeros only if `Real` is `ExpressibleByIntegerLiteral`.
    public init(){
        self.real = 0
        self.imag = 0
    }
    public init(integerLiteral value: Real.IntegerLiteralType) {
        self.real = Real(integerLiteral: value)
        self.imag = 0
    }
}

// MARK: - Equatable
extension Complex: Equatable where Real: Equatable{
    public static func == (lhs: Complex<Real>, rhs: Complex<Real>) -> Bool{
        (lhs.real == rhs.real) && (lhs.imag == rhs.imag)
    }
}

// MARK: - Hashable
extension Complex: Hashable where Real: Hashable{
    public func hash(into hasher: inout Hasher) {
        hasher.combine(real)
        hasher.combine(imag)
    }
}

// MARK: - AdditiveArithmetic
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
    
    /// The zero value.
    public static var zero: Complex<Real>{
        .init(real: .zero, imag: .zero)
    }
}


// MARK: - Numeric
extension Complex where Real: Numeric {
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
    
    
    /// The multiplicative identity value, one.
    ///
    /// The value is initialized by the integer literal "1", as this is defined only if `Real` conforms to `Numeric` where `Numeric` inherits from `ExpressibleByIntegerLiteral`.
    public static var one: Complex<Real>{
        .init(real: 1, imag: .zero)
    }
    
    /// The imaginary unit with magnitude 1, 𝒊.
    public static var I: Complex<Real>{
        .init(real: .zero, imag: 1)
    }
    
    public var squareMagnitude: Real.Magnitude{
        let realMagnitude = real.magnitude
        let imagMagnitude = imag.magnitude
        return realMagnitude * realMagnitude + imagMagnitude * imagMagnitude
    }
}
    
extension Complex: Numeric where Real: Numeric, Real.Magnitude: FloatingPoint {
    public var magnitude: Real.Magnitude{
        sqrt(squareMagnitude)
    }
}


// MARK: - SignedNumeric
extension Complex: SignedNumeric where Real: SignedNumeric, Real.Magnitude: FloatingPoint{
    public static prefix func - (_ op: Complex<Real>) -> Complex<Real>{
        .init(real: -op.real, imag: -op.imag)
    }
    public mutating func negate() {
        real.negate()
        imag.negate()
    }
}

// MARK: - Conjugate
extension Complex where Real: SignedNumeric{
    public var conjugate: Complex<Real>{
        .init(real: real, imag: -imag)
    }
}

extension Complex where Real: FloatingPoint{ // divisable
    public var inverse: Self{
        let sqrMag = squareMagnitude
        return .init(real: real / sqrMag, imag: (-imag) / sqrMag)
    }
    public static func / (lhs: Complex<Real>, rhs: Complex<Real>) -> Complex<Real>{
        return lhs * rhs.inverse
    }
    public static func /= (lhs: inout Complex<Real>, rhs: Complex<Real>){
        lhs = lhs / rhs
    }
}
