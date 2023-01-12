//
//  Complex.swift
//  
//
//  Created by Albertus Liberius on 2023-01-03.
//

import Foundation



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
                let realDescription = real.description
                if realDescription.hasSuffix(".0"){
                    return String(realDescription.prefix(realDescription.count - 2))
                }else{
                    return realDescription
                }
            }else if (real as! (any FloatingPoint)).isZero{
                let imagDescription = imag.description
                if imagDescription == "1.0"{
                    return "𝒊"
                }else if imagDescription.hasSuffix(".0"){
                    return imagDescription.prefix(imagDescription.count - 2) + "𝒊"
                }else{
                    return imagDescription + "𝒊"
                }
            }else{
                return "(" + real.description + ((imag as! (any FloatingPoint)).sign == .minus ? "-" : "+") + ((imag as! (any FloatingPoint)).magnitude as! Real).description + "𝒊)"
            }
        }else{
            return "Complex<\(Real.self)>(" + real.description + "," + imag.description + ")"
        }
    }
}


// MARK: - ExpressibleByFloatLiteral
extension Complex: ExpressibleByFloatLiteral where Real: ExpressibleByFloatLiteral, Real.FloatLiteralType: ExpressibleByIntegerLiteral{
    public init(floatLiteral value: Real.FloatLiteralType) {
        self.real = Real(floatLiteral: value)
        let zero: Real.FloatLiteralType = 0
        self.imag = Real(floatLiteral: zero) // _ExpressibleByBuiltinFloatLiteral = {Float, Double, Float80}
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
    
    /// The imaginary unit with magnitude one, 𝑖.
    public static var I: Complex<Real>{
        .init(real: .zero, imag: 1)
    }
    
    /// The squared norm of the complex number.
    ///
    /// The value is defined only if the base field `Real` has definition of addition and multiplication.
    /// `Real.Magnitude` is also required to be defined, concerning the `Real` type is not only a scalar type but also able to be a type with conjugate.
    /// *e.g.* a quaternion as `Complex<Complex<Real>>`.
    ///
    /// For general [Cayley-Dickson construction](https://en.wikipedia.org/wiki/Cayley–Dickson_construction) 𝑎 + 𝑏 𝑖,
    /// the squared norm is defined |𝑧|² = 𝑎* 𝑎 + 𝑏* 𝑏 = |𝑎|² + |𝑏|².
    /// Thus, this function is also defined as (``real``.`magnitude`)² + (``imag``.`magnitude`)².
    ///
    /// If `Real` is `FloatingPoint` and thus applicable for `sqrt`, ``magnitude`` is defined.
    public var squareMagnitude: Real.Magnitude{
        let realMagnitude = real.magnitude
        let imagMagnitude = imag.magnitude
        return realMagnitude * realMagnitude + imagMagnitude * imagMagnitude
    }
}
    
extension Complex: Numeric where Real: Numeric, Real.Magnitude: FloatingPoint {
    /// The magnitude of the complex number.
    ///
    /// This value is defined by the square root of ``squareMagnitude``, so the square root must be defined on `Real`, which is the requirement of the existence of this property.
    /// Also, this is identical to ``abs(_:)``.
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
    /// The complex conjugate. Automatic daisy chain is not available.
    ///
    /// - Returns: 𝑎 − 𝑏 𝑖 when `self` is 𝑎 + 𝑏 𝑖.
    ///
    /// Returns 𝑎 − 𝑏 𝑖 when `self` is 𝑎 + 𝑏 𝑖. Thus, `Real` is required to be `SignedNumeric`.
    /// There is no way to guarantee existence of conjugate operation for generic type, the generalized conjugate 𝑎* − 𝑏* 𝑖 is not defined.
    /// To define such conjugate in the case `Real` is conjugatable, define like `.init(real: .real.conjugate, imag: -.imag.conjugate)`.
    /// > Important: Daisy chain of conjugate is not defined. You must define manually.
    /// In the case `Real` is scalar *e.g.* `Complex<Float>` or `Complex<Double>`, you can ignore this tip.
    public var conjugate: Complex<Real>{
        .init(real: real, imag: -imag)
    }
}

extension Complex where Real: FloatingPoint{ // divisable
    /// Inverse of the complex number.
    ///
    /// This property returns the inverse of the `self` complex number. This function is defined by ``conjugate`` `/` ``squareMagnitude``.
    /// > Important: If `Real` is not scalar like `Float` or `Double` but conjugatable, this property does not guarantee to return the inverse. See ``conjugate`` and ``squareMagnitude`` for the detailed specifications.
    /// - Returns: The inverse of the complex number `self` only if `Real` is scalar.
    public var inverse: Complex<Real>{
        let sqrMag = squareMagnitude
        return .init(real: real / sqrMag, imag: (-imag) / sqrMag)
    }
    public static func / (lhs: Complex<Real>, rhs: Complex<Real>) -> Complex<Real>{
        return lhs * rhs.inverse
    }
    public static func /= (lhs: inout Complex<Real>, rhs: Complex<Real>){
        lhs = lhs / rhs
    }
    public var isZero: Bool{
        real.isZero && imag.isZero
    }
}
