//
//  Complex-Functions.swift
//  
//
//  Created by Albertus Liberius on 2023-01-03.
//

import Foundation
import Accelerate


public func abs<Real>(_ z: Complex<Real>) -> Real where Real: FloatingPoint{
    z.magnitude
}

/// The principal argument of the given complex number, which defined to run in (-𝜋, 𝜋].
///
/// In complex analysis, the argument of a complex number is multi-branch: arg(𝑧) := 2𝜋𝑛𝒊 + Arg(𝑧) for any integer 𝑛.
/// This function returns the argument from the principal branch, Arg(𝑧), which runs from -𝜋 to 𝜋.
/// This function is defined by the system `atan2`, so the range of the return value contains 𝜋 but does not contain -𝜋.
/// - Parameter z: A complex number.
/// - Returns: The principal argument of the input complex number, obtained by system `atan2`.
public func arg(_ z: Complex<Float>) -> Float{
    atan2f(z.imag, z.real)
}

/// The principal argument of the given complex number, which defined to run in (-𝜋, 𝜋].
///
/// In complex analysis, the argument of a complex number is multi-branch: arg(𝑧) := 2𝜋𝑛𝒊 + Arg(𝑧) for any integer 𝑛.
/// This function returns the argument from the principal branch, Arg(𝑧), which runs from -𝜋 to 𝜋.
/// This function is defined by the system `atan2`, so the range of the return value contains 𝜋 but does not contain -𝜋.
/// - Parameter z: A complex number.
/// - Returns: The principal argument of the input complex number, obtained by system `atan2`.
public func arg(_ z: Complex<Double>) -> Double{
    atan2(z.imag, z.real)
}

/// The principal logarithm of a complex number.
///
/// In complex analysis, the logarithm is defined by ln(𝑧) := ln|𝑧| + 𝒊 arg(𝑧).
/// From this multi-branch function, we pick the principal branch for this computation, which can be naturally obtained by the system func `atan2`:
/// Ln(𝑧) := ln|𝑧| + 𝒊 Arg(𝑧).
///
/// See ``arg(_:)-275qb`` for more explanation on branch selection.
/// - Parameter z: A complex number.
/// - Returns: The principal logarithm of the given complex number: Ln(𝑧) := ln|𝑧| + 𝒊 Arg(𝑧).
public func log(_ z: Complex<Float>) -> Complex<Float>{
    Complex<Float>(real: logf(abs(z)), imag: arg(z))
}

/// The principal logarithm of a complex number.
///
/// In complex analysis, the logarithm is defined by ln(𝑧) := ln|𝑧| + 𝒊 arg(𝑧).
/// From this multi-branch function, we pick the principal branch for this computation, which can be naturally obtained by the system func `atan2`:
/// Ln(𝑧) := ln|𝑧| + 𝒊 Arg(𝑧).
///
/// See ``arg(_:)-1rv27`` for more explanation on branch selection.
/// - Parameter z: A complex number.
/// - Returns: The principal logarithm of the given complex number: Ln(𝑧) := ln|𝑧| + 𝒊 Arg(𝑧).
public func log(_ z: Complex<Double>) -> Complex<Double>{
    Complex<Double>(real: log(abs(z)), imag: arg(z))
}

/// The complex natural exponential function.
///
/// The fundamental exponential function in complex analysis is defined by the euler's formula:
/// `exp(a+bi) = exp(a) * (cos(b) + i sin(b))`.
public func exp(_ z: Complex<Float>) -> Complex<Float>{
    [Complex<Float>](unsafeUninitializedCapacity: 1) { buffer, initializedCount in
        buffer.withMemoryRebound(to: Float.self) { buffer in
            let cossin = [Float](unsafeUninitializedCapacity: 2) { buffer, initializedCount in
                __sincosf(z.imag, buffer.baseAddress! + 1, buffer.baseAddress!)
                initializedCount = 2
            }
            var mag = expf(z.real)
            vDSP_vsmul(cossin, 1, &mag, buffer.baseAddress!, 1, vDSP_Length(2))
        }
        initializedCount = 1
    }[0]
}

/// The complex natural exponential function.
///
/// The fundamental exponential function in complex analysis is defined by the euler's formula:
/// `exp(a+bi) = exp(a) * (cos(b) + i sin(b))`.
public func exp(_ z: Complex<Double>) -> Complex<Double>{
    [Complex<Double>](unsafeUninitializedCapacity: 1) { buffer, initializedCount in
        buffer.withMemoryRebound(to: Double.self) { buffer in
            let cossin = [Double](unsafeUninitializedCapacity: 2) { buffer, initializedCount in
                __sincos(z.imag, buffer.baseAddress! + 1, buffer.baseAddress!)
                initializedCount = 2
            }
            var mag = exp(z.real)
            vDSP_vsmulD(cossin, 1, &mag, buffer.baseAddress!, 1, vDSP_Length(2))
        }
        initializedCount = 1
    }[0]
}

/// The power function.
///
/// The power function is defined by `pow(base, exponent) := exp(log(base) * exponent)`.
/// This function uses the principal log function value to calculate the result.
/// See ``log(_:)-52em1`` and ``exp(_:)-5wjft`` for more details on the definition.
public func pow(_ base: Complex<Float>, _ exponent: Complex<Float>) -> Complex<Float> {
    exp(log(base) * exponent)
}

/// The power function.
///
/// The power function is defined by `pow(base, exponent) := exp(log(base) * exponent)`.
/// This function uses the principal log function value to calculate the result.
/// See ``log(_:)-3ushm`` and ``exp(_:)-2bq5g`` for more details on the definition.
public func pow(_ base: Complex<Double>, _ exponent: Complex<Double>) -> Complex<Double> {
    exp(log(base) * exponent)
}

/// The principal square root of a complex number.
///
/// This function is defined by `pow(z, 0.5)`. See ``pow(_:_:)-20qqx`` for the definition of power function.
public func sqrt(_ z: Complex<Float>) -> Complex<Float>{
    var logged = log(z)
    logged.real /= 2
    logged.imag /= 2
    return exp(logged)
}

/// The principal square root of a complex number.
///
/// This function is defined by `pow(z, 0.5)`. See ``pow(_:_:)-1b8gk`` for the definition of power function.
public func sqrt(_ z: Complex<Double>) -> Complex<Double>{
    var logged = log(z)
    logged.real /= 2
    logged.imag /= 2
    return exp(logged)
}
/// Defines the hyperbolic cosine function cosh(𝑧) := (exp(𝒊𝑧) + exp(-𝒊𝑧)) / 2 in complex domain.
public func cosh(_ z: Complex<Float>) -> Complex<Float>{
    var result = exp(z) + exp(-z)
    result.real /= 2
    result.imag /= 2
    return result
}
/// Defines the hyperbolic cosine function cosh(𝑧) := (exp(𝒊𝑧) + exp(-𝒊𝑧)) / 2 in complex domain.
public func cosh(_ z: Complex<Double>) -> Complex<Double>{
    var result = exp(z) + exp(-z)
    result.real /= 2
    result.imag /= 2
    return result
}

/// Defines the hyperbolic sine function sinh(𝑧) := (exp(𝒊𝑧) - exp(-𝒊𝑧)) / 2 in complex domain.
public func sinh(_ z: Complex<Float>) -> Complex<Float>{
    var result = exp(z) - exp(-z)
    result.real /= 2
    result.imag /= 2
    return result
}
/// Defines the hyperbolic sine function sinh(𝑧) := (exp(𝒊𝑧) - exp(-𝒊𝑧)) / 2 in complex domain.
public func sinh(_ z: Complex<Double>) -> Complex<Double>{
    var result = exp(z) - exp(-z)
    result.real /= 2
    result.imag /= 2
    return result
}

/// Defines the hyperbolic tangent function tanh(𝑧) := sinh(𝑧) / cosh(𝑧) in complex domain.
public func tanh(_ z: Complex<Float>) -> Complex<Float>{
    let expP = exp(z)
    let expM = exp(-z)
    let numerator = expP - expM
    let denominator = expP + expM
    return numerator / denominator
}

/// Defines the hyperbolic tangent function tanh(𝑧) := sinh(𝑧) / cosh(𝑧) in complex domain.
public func tanh(_ z: Complex<Double>) -> Complex<Double>{
    let expP = exp(z)
    let expM = exp(-z)
    let numerator = expP - expM
    let denominator = expP + expM
    return numerator / denominator
}

/// Defines the hyperbolic cotangent function coth(𝑧) := cosh(𝑧) / sinh(𝑧) in complex domain.
public func coth(_ z: Complex<Float>) -> Complex<Float>{
    let expP = exp(z)
    let expM = exp(-z)
    let numerator = expP + expM
    let denominator = expP - expM
    return numerator / denominator
}

/// Defines the hyperbolic cotangent function coth(𝑧) := cosh(𝑧) / sinh(𝑧) in complex domain.
public func coth(_ z: Complex<Double>) -> Complex<Double>{
    let expP = exp(z)
    let expM = exp(-z)
    let numerator = expP + expM
    let denominator = expP - expM
    return numerator / denominator
}

/// Defines the complex function cosh⁻¹(𝑧) := Ln (𝑧 + √(𝑧² - 1)) which analytically extends to `acosh`.
///
/// This function defines the complex inverse hyperbolic cosine function cosh⁻¹(𝑧) := Ln (𝑧 + √(𝑧² - 1)). To see definition of 'Ln', see ``log(_:)-52em1``.
///
/// This function defines the analytic continuation of the inverse hyperbolic cosine function `acosh` to the complex domain and chooses the branch that is farthest from the real function domain, which is conventional branch for the complex function.
///
/// While ``cosh(_:)-b4lw`` and ``cos(_:)-4s8m5`` are directly connected, this function and ``acos(_:)-4rx38`` are not directly connected since they have different branch configurations to match the real domain defnitions.
/// For more discussion on this topic, see
/// [Inverse Hyperbolic Cosine](https://mathworld.wolfram.com/InverseHyperbolicCosine.html)
public func acosh(_ z: Complex<Float>) -> Complex<Float>{
    log(sqrt(z * z - 1) + z)
}

/// Defines the complex function cosh⁻¹(𝑧) := Ln (𝑧 + √(𝑧² - 1)) which analytically extends to `acosh`.
///
/// This function defines the complex inverse hyperbolic cosine function cosh⁻¹(𝑧) := Ln (𝑧 + √(𝑧² - 1)). To see definition of 'Ln', see ``log(_:)-3ushm``.
///
/// This function defines the analytic continuation of the inverse hyperbolic cosine function `acosh` to the complex domain and chooses the branch that is farthest from the real function domain, which is conventional branch for the complex function.
///
/// While ``cosh(_:)-1hn2v`` and ``cos(_:)-1tcd4`` are directly connected, this function and ``acos(_:)-9caet`` are not directly connected since they have different branch configurations to match the real domain defnitions.
/// For more discussion on this topic, see
/// [Inverse Hyperbolic Cosine](https://mathworld.wolfram.com/InverseHyperbolicCosine.html).
public func acosh(_ z: Complex<Double>) -> Complex<Double>{
    log(sqrt(z * z - 1) + z)
}

/// Defines the complex function sinh⁻¹(𝑧) := Ln (𝑧 + √(𝑧² + 1)) which analytically extends to `asinh`.
///
/// This function is defined by sinh⁻¹(𝑧) := Ln(𝑧 + √(𝑧² + 1)) while the all branches of the inverse functions of the hyperbolic sine function is represented by ln(𝑧 ± √(𝑧² + 1)) = 2 𝜋 𝑖 𝑛 + ln(𝑧 ± √(𝑧² + 1)) = 2 𝜋 𝑖 𝑛 ± Ln(𝑧 + √(𝑧² + 1)), for all integer 𝑛.
/// See ``log(_:)-52em1`` for the definition of the principal log 'Ln'.
public func asinh(_ z: Complex<Float>) -> Complex<Float>{
    log(sqrt(z * z + 1) + z)
}

/// Defines the complex function sinh⁻¹(𝑧) := Ln (𝑧 + √(𝑧² + 1)) which analytically extends to `asinh`.
///
/// This function is defined by sinh⁻¹(𝑧) := Ln(𝑧 + √(𝑧² + 1)) while the all branches of the inverse functions of the hyperbolic sine function is represented by ln(𝑧 ± √(𝑧² + 1)) = 2 𝜋 𝑖 𝑛 + ln(𝑧 ± √(𝑧² + 1)) = 2 𝜋 𝑖 𝑛 ± Ln(𝑧 + √(𝑧² + 1)), for all integer 𝑛.
/// See ``log(_:)-3ushm`` for the definition of the principal log 'Ln'.
public func asinh(_ z: Complex<Double>) -> Complex<Double>{
    log(sqrt(z * z + 1) + z)
}

/// Defines the complex function tanh⁻¹(𝑧) := Ln (√((1 + 𝑧) / (1 - 𝑧))) which analytically extends to `atanh`.
///
/// See ``log(_:)-52em1`` for the definition of the principal log 'Ln'.
public func atanh(_ z: Complex<Float>) -> Complex<Float>{
    log(sqrt((1 + z) / (1 - z)))
}
/// Defines the complex function tanh⁻¹(𝑧) := Ln (√((1 + 𝑧) / (1 - 𝑧))) which analytically extends to `atanh`.
///
/// See ``log(_:)-3ushm`` for the definition of the principal log 'Ln'.
public func atanh(_ z: Complex<Double>) -> Complex<Double>{
    log(sqrt((1 + z) / (1 - z)))
}

/// Defines the complex function coth⁻¹(𝑧) := Ln (√((𝑧 + 1) / (𝑧 - 1))) which analytically extends to `acoth`.
///
/// See ``log(_:)-52em1`` for the definition of the principal log 'Ln'.
public func acoth(_ z: Complex<Float>) -> Complex<Float>{
    log(sqrt((z + 1) / (z - 1)))
}
/// Defines the complex function coth⁻¹(𝑧) := Ln (√((𝑧 + 1) / (𝑧 - 1))) which analytically extends to `acoth`.
///
/// See ``log(_:)-3ushm`` for the definition of the principal log 'Ln'.
public func acoth(_ z: Complex<Double>) -> Complex<Double>{
    log(sqrt((z + 1) / (z - 1)))
}

// MARK: - Trigonometric Functions

/// Defines cos 𝑧 := cosh 𝑖 𝑧 which analytically extends to the known real function `cos`.
public func cos(_ z: Complex<Float>) -> Complex<Float>{
    cosh(.init(real: -z.imag, imag: z.real))
}
/// Defines cos 𝑧 := cosh 𝑖 𝑧 which analytically extends to the known real function `cos`.
public func cos(_ z: Complex<Double>) -> Complex<Double>{
    cosh(.init(real: -z.imag, imag: z.real))
}
/// Defines sin 𝑧 := − 𝑖 sinh 𝑖 𝑧 which analytically extends to the known real function `sin`.
public func sin(_ z: Complex<Float>) -> Complex<Float>{
    let id = sinh(.init(real: -z.imag, imag: z.real))
    return .init(real: id.imag, imag: -id.real)
}
/// Defines sin 𝑧 := − 𝑖 sinh 𝑖 𝑧 which analytically extends to the known real function `sin`.
public func sin(_ z: Complex<Double>) -> Complex<Double>{
    let id = sinh(.init(real: -z.imag, imag: z.real))
    return .init(real: id.imag, imag: -id.real)
}
/// Defines tan 𝑧 := − 𝑖 tanh 𝑖 𝑧 which analytically extends to the known real function `tan`.
public func tan(_ z: Complex<Float>) -> Complex<Float>{
    let id = tanh(.init(real: -z.imag, imag: z.real))
    return .init(real: id.imag, imag: -id.real)
}
/// Defines tan 𝑧 := − 𝑖 tanh 𝑖 𝑧 which analytically extends to the known real function `tan`.
public func tan(_ z: Complex<Double>) -> Complex<Double>{
    let id = tanh(.init(real: -z.imag, imag: z.real))
    return .init(real: id.imag, imag: -id.real)
}
/// Defines cot 𝑧 := 𝑖 coth 𝑖 𝑧 which analytically extends to the known real function `cot`.
public func cot(_ z: Complex<Float>) -> Complex<Float>{
    let id = coth(.init(real: -z.imag, imag: z.real))
    return .init(real: -id.imag, imag: id.real)
}
/// Defines cot 𝑧 := 𝑖 coth 𝑖 𝑧 which analytically extends to the known real function `cot`.
public func cot(_ z: Complex<Double>) -> Complex<Double>{
    let id = coth(.init(real: -z.imag, imag: z.real))
    return .init(real: -id.imag, imag: id.real)
}

// MARK: - Inverse Trigonometric Functions

/// Defines cos⁻¹ 𝑧 := 𝜋 / 2 + 𝑖 Ln (𝑖 𝑧 + √(1 - 𝑧²)) which analytically extends to the known real function `acos`.
///
/// This function defiens the complex inverse hyperbolic cosine function cos⁻¹ 𝑧 := 𝜋 / 2 + 𝑖 Ln (𝑖 𝑧 + √(1 - 𝑧²)). To see definition of 'Ln', see ``log(_:)-52em1``.
///
/// This function defines the analytic continuation of the arc cosine function to the complex domain that is chosen to be the farthest from the real domain of `acos`, which is conventional.
///
/// While ``cos(_:)-4s8m5`` and ``cosh(_:)-b4lw`` are directly connected, this function and ``acosh(_:)-5mgxh`` are not directly connected since their branch configurations are different.
/// For more discussion on this topic, see [MathWorld: Inverse Hyperbolic Cosine](https://mathworld.wolfram.com/InverseCosine.html).
public func acos(_ z: Complex<Float>) -> Complex<Float>{
    let yetITimed = log(.init(real: -z.imag, imag: z.real) + sqrt(z * z - 1))
    return .init(real: Float.pi / 2 - yetITimed.imag, imag: yetITimed.real)
}

/// Defines cos⁻¹ 𝑧 := 𝜋 / 2 + 𝑖 Ln (𝑖 𝑧 + √(1 - 𝑧²)) which analytically extends to the known real function `acos`.
///
/// This function defiens the complex inverse hyperbolic cosine function cos⁻¹ 𝑧 := 𝜋 / 2 + 𝑖 Ln (𝑖 𝑧 + √(1 - 𝑧²)). To see definition of 'Ln', see ``log(_:)-3ushm``.
///
/// This function defines the analytic continuation of the arc cosine function to the complex domain that is chosen to be the farthest from the real domain of `acos`, which is conventional.
///
/// While ``cos(_:)-1tcd4`` and ``cosh(_:)-b4lw`` are directly connected, this function and ``acosh(_:)-3rgdk`` are not directly connected since their branch configurations are different.
/// For more discussion on this topic, see [MathWorld: Inverse Hyperbolic Cosine](https://mathworld.wolfram.com/InverseCosine.html).
public func acos(_ z: Complex<Double>) -> Complex<Double>{
    let yetITimed = log(.init(real: -z.imag, imag: z.real) + sqrt(z * z - 1))
    return .init(real: Double.pi / 2 - yetITimed.imag, imag: yetITimed.real)
}

/// Defines sin⁻¹ 𝑧 := − 𝑖 sinh⁻¹ 𝑖 𝑧 which analytically extends to the known real function `asin`.
///
/// Trigonometric functions and hyperbolic functions are connected and basically equivalent in complex level.
/// The inverse sine function in complex domain is defined by sin⁻¹ 𝑧 := − 𝑖 sinh⁻¹ 𝑖 𝑧.
/// See ``asinh(_:)-4p7bd`` for the definition of sinh⁻¹.
public func asin(_ z: Complex<Float>) -> Complex<Float>{
    let iz = Complex<Float>(real: -z.imag, imag: z.real)
    let stillITimed = log(iz + sqrt(1 - z * z))
    return .init(real: stillITimed.imag, imag: -stillITimed.real)
}

/// Defines sin⁻¹ 𝑧 := − 𝑖 sinh⁻¹ 𝑖 𝑧 which analytically extends to the known real function `asin`.
///
/// Trigonometric functions and hyperbolic functions are connected and basically equivalent in complex level.
/// The inverse sine function in complex domain is defined by sin⁻¹ 𝑧 := − 𝑖 sinh⁻¹ 𝑖 𝑧.
/// See ``asinh(_:)-1p72s`` for the definition of sinh⁻¹.
public func asin(_ z: Complex<Double>) -> Complex<Double>{
    let iz = Complex<Double>(real: -z.imag, imag: z.real)
    let stillITimed = asinh(iz)
    return .init(real: stillITimed.imag, imag: -stillITimed.real)
}

/// Defines tan⁻¹ 𝑧 := − 𝑖 tanh⁻¹ 𝑖 𝑧 which analytically extends to the known real function `atan`.
///
/// Trigonometric functions and hyperbolic functions are connected and basically equivalent in complex level.
/// The inverse tangent function in complex domain is defined by tan⁻¹ 𝑧 := − 𝑖 tanh⁻¹ 𝑖 𝑧.
/// See ``atanh(_:)-88065`` for the definition of tanh⁻¹.
public func atan(_ z: Complex<Float>) -> Complex<Float>{
    let atanhIz = atanh(.init(real: -z.imag, imag: z.real))
    return .init(real: atanhIz.imag, imag: -atanhIz.real)
}


/// Defines tan⁻¹ 𝑧 := − 𝑖 tanh⁻¹ 𝑖 𝑧 which analytically extends to the known real function `atan`.
///
/// Trigonometric functions and hyperbolic functions are connected and basically equivalent in complex level.
/// The inverse tangent function in complex domain is defined by tan⁻¹ 𝑧 := − 𝑖 tanh⁻¹ 𝑖 𝑧.
/// See ``atanh(_:)-6dnp1`` for the definition of tanh⁻¹.
public func atan(_ z: Complex<Double>) -> Complex<Double>{
    let atanhIz = atanh(.init(real: -z.imag, imag: z.real))
    return .init(real: atanhIz.imag, imag: -atanhIz.real)
}


/// Defines cot⁻¹ 𝑧 := 𝑖 coth⁻¹ 𝑖 𝑧 which analytically extends to the known real function `acot`.
///
/// Trigonometric functions and hyperbolic functions are connected and basically equivalent in complex level.
/// The inverse cotangent function in complex domain is defined by cot⁻¹ 𝑧 := 𝑖 coth⁻¹ 𝑖 𝑧.
/// See ``acoth(_:)-6vluc`` for the definition of coth⁻¹.
public func acot(_ z: Complex<Float>) -> Complex<Float>{
    let acothIz = acoth(.init(real: -z.imag, imag: z.real))
    return .init(real: -acothIz.imag, imag: acothIz.real)
}


/// Defines cot⁻¹ 𝑧 := 𝑖 coth⁻¹ 𝑖 𝑧 which analytically extends to the known real function `acot`.
///
/// Trigonometric functions and hyperbolic functions are connected and basically equivalent in complex level.
/// The inverse cotangent function in complex domain is defined by cot⁻¹ 𝑧 := 𝑖 coth⁻¹ 𝑖 𝑧.
/// See ``acoth(_:)-8g8a4`` for the definition of coth⁻¹.
public func acot(_ z: Complex<Double>) -> Complex<Double>{
    let acothIz = acoth(.init(real: -z.imag, imag: z.real))
    return .init(real: -acothIz.imag, imag: acothIz.real)
}

