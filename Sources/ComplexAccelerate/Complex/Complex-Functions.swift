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

public func pow(_ base: Complex<Float>, _ exponent: Complex<Float>) -> Complex<Float> {
    exp(log(base) * exponent)
}

public func pow(_ base: Complex<Double>, _ exponent: Complex<Double>) -> Complex<Double> {
    exp(log(base) * exponent)
}

/// The principal square root of a complex number.
public func sqrt(_ z: Complex<Float>) -> Complex<Float>{
    var logged = log(z)
    logged.real /= 2
    logged.imag /= 2
    return exp(logged)
}

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

/// Defines the complex function cosh⁻¹(𝑧) := ㏑(𝑧 + √(𝑧² - 1)) which analytically extends to `acosh`.
///
/// This function defines the analytic continuation of the inverse hyperbolic cosine function to the complex domain that is chosen to be the conventional principal branch among multi-branch complex logarithm.
///
/// While ``cosh(_:)-b4lw`` and ``cos(_:)-4s8m5`` are directly connected, this function and ``acos(_:)-4rx38`` are not directly connected since they are the inverse functions of different branches.
/// For more discussion on this topic, see <doc:Complex-Functions-HyperbolicAndTrigonometric>.
public func acosh(_ z: Complex<Float>) -> Complex<Float>{
    log(sqrt(z * z - 1) + z)
}

/// Defines the complex function cosh⁻¹(𝑧) := ㏑(𝑧 + √(𝑧² - 1)) which analytically extends to `acosh`.
///
/// This function defines the analytic continuation of the inverse hyperbolic cosine function to the complex domain that is chosen to be the conventional principal branch among multi-branch complex logarithm.
///
/// While ``cosh(_:)-1hn2v`` and ``cos(_:)-1tcd4`` are directly connected, this function and ``acos(_:)-9caet`` are not directly connected since they are the inverse functions of different branches.
/// For more discussion on this topic, see <doc:Complex-Functions-HyperbolicAndTrigonometric>.
public func acosh(_ z: Complex<Double>) -> Complex<Double>{
    log(sqrt(z * z - 1) + z)
}

/// Defines the complex function sinh⁻¹(𝑧) := ㏑(𝑧 + √(𝑧² + 1)) which analytically extends to `asinh`.
///
/// This function defines the analytic continuation of the inverse hyperbolic sine function to the complex domain that is chosen to be the conventional principal branch among multi-branch complex logarithm.
///
/// While ``sinh(_:)-7q9zp`` and ``sin(_:)-9uhtf`` are directly connected, this function and ``asin(_:)-42hn9`` are not directly connected since they are the inverse functions of different branches.
/// For more discussion on this topic, see <doc:Complex-Functions-HyperbolicAndTrigonometric>.
public func asinh(_ z: Complex<Float>) -> Complex<Float>{
    log(sqrt(z * z + 1) + z)
}

/// Defines the complex function sinh⁻¹(𝑧) := ㏑(𝑧 + √(𝑧² + 1)) which analytically extends to `asinh`.
///
/// This function defines the analytic continuation of the inverse hyperbolic sine function to the complex domain that is chosen to be the conventional principal branch among multi-branch complex logarithm.
///
/// While ``sinh(_:)-45gxc`` and ``sin(_:)-2qzc4`` are directly connected, this function and ``asin(_:)-71gfk`` are not directly connected since they are the inverse functions of different branches.
/// For more discussion on this topic, see <doc:Complex-Functions-HyperbolicAndTrigonometric>.
public func asinh(_ z: Complex<Double>) -> Complex<Double>{
    log(sqrt(z * z + 1) + z)
}

/// Defines the complex function tanh⁻¹(𝑧) := ㏑(√((1 + 𝑧) / (1 - 𝑧))) which analytically extends to `atanh`.
public func atanh(_ z: Complex<Float>) -> Complex<Float>{
    log(sqrt((1 + z) / (1 - z)))
}
/// Defines the complex function tanh⁻¹(𝑧) := ㏑(√((1 + 𝑧) / (1 - 𝑧))) which analytically extends to `atanh`.
public func atanh(_ z: Complex<Double>) -> Complex<Double>{
    log(sqrt((1 + z) / (1 - z)))
}

/// Defines the complex function coth⁻¹(𝑧) := ㏑(√((𝑧 + 1) / (𝑧 - 1))) which analytically extends to `acoth`.
public func acoth(_ z: Complex<Float>) -> Complex<Float>{
    log(sqrt((z + 1) / (z - 1)))
}
/// Defines the complex function coth⁻¹(𝑧) := ㏑(√((𝑧 + 1) / (𝑧 - 1))) which analytically extends to `acoth`.
public func acoth(_ z: Complex<Double>) -> Complex<Double>{
    log(sqrt((z + 1) / (z - 1)))
}

// MARK: - Trigonometric Functions

/// Defines cos(𝑧) := cosh(𝒊𝑧) which analytically extends to the known real function `cos`.
public func cos(_ z: Complex<Float>) -> Complex<Float>{
    cosh(.init(real: -z.imag, imag: z.real))
}
/// Defines cos(𝑧) := cosh(𝒊𝑧) which analytically extends to the known real function `cos`.
public func cos(_ z: Complex<Double>) -> Complex<Double>{
    cosh(.init(real: -z.imag, imag: z.real))
}
/// Defines sin(𝑧) := -𝒊 sinh(𝒊𝑧) which analytically extends to the known real function `sin`.
public func sin(_ z: Complex<Float>) -> Complex<Float>{
    let id = sinh(.init(real: -z.imag, imag: z.real))
    return .init(real: id.imag, imag: -id.real)
}
/// Defines sin(𝑧) := -𝒊 sinh(𝒊𝑧) which analytically extends to the known real function `sin`.
public func sin(_ z: Complex<Double>) -> Complex<Double>{
    let id = sinh(.init(real: -z.imag, imag: z.real))
    return .init(real: id.imag, imag: -id.real)
}
/// Defines tan(𝑧) := -𝒊 tanh(𝒊𝑧) which analytically extends to the known real function `tan`.
public func tan(_ z: Complex<Float>) -> Complex<Float>{
    let id = tanh(.init(real: -z.imag, imag: z.real))
    return .init(real: id.imag, imag: -id.real)
}
/// Defines tan(𝑧) := -𝒊 tanh(𝒊𝑧) which analytically extends to the known real function `tan`.
public func tan(_ z: Complex<Double>) -> Complex<Double>{
    let id = tanh(.init(real: -z.imag, imag: z.real))
    return .init(real: id.imag, imag: -id.real)
}
/// Defines cot(𝑧) := 𝒊 coth(𝒊𝑧) which analytically extends to the known real function `cot`.
public func cot(_ z: Complex<Float>) -> Complex<Float>{
    let id = coth(.init(real: -z.imag, imag: z.real))
    return .init(real: -id.imag, imag: id.real)
}
/// Defines cot(𝑧) := 𝒊 coth(𝒊𝑧) which analytically extends to the known real function `cot`.
public func cot(_ z: Complex<Double>) -> Complex<Double>{
    let id = coth(.init(real: -z.imag, imag: z.real))
    return .init(real: -id.imag, imag: id.real)
}

// MARK: - Inverse Trigonometric Functions

/// Defines cos⁻¹(𝑧) := 𝒊 ㏑(𝑧 - √(𝑧² - 1)) which analytically extends to the known real function `acos`.
///
/// This function defines the analytic continuation of the arc cosine function to the complex domain that is chosen to be the conventional principal branch among multi-branch complex logarithm.
///
/// While ``cos(_:)-1tcd4`` and ``cosh(_:)-b4lw`` are directly connected, this function and ``acosh(_:)-5mgxh`` are not directly connected since they are the inverse functions of different branches.
/// For more discussion on this topic, see <doc:Complex-Functions-HyperbolicAndTrigonometric>.
public func acos(_ z: Complex<Float>) -> Complex<Float>{
    let yetITimed = log(z - sqrt(z * z - 1))
    return .init(real: -yetITimed.imag, imag: yetITimed.real)
}

/// Defines cos⁻¹(𝑧) := 𝒊 ㏑(𝑧 - √(𝑧² - 1)) which analytically extends to the known real function `acos`.
///
/// This function defines the analytic continuation of the arc cosine function to the complex domain that is chosen to be the conventional principal branch among multi-branch complex logarithm.
///
/// While ``cos(_:)-1tcd4`` and ``cosh(_:)-1hn2v`` are directly connected, this function and ``acosh(_:)-3rgdk`` are not directly connected since they are the inverse functions of different branches.
/// For more discussion on this topic, see <doc:Complex-Functions-HyperbolicAndTrigonometric>.
public func acos(_ z: Complex<Double>) -> Complex<Double>{
    let yetITimed = log(z - sqrt(z * z - 1))
    return .init(real: -yetITimed.imag, imag: yetITimed.real)
}

/// Defines sin⁻¹(𝑧) := -𝒊 ㏑(𝒊𝑧 + √(1 - 𝑧²)) which analytically extends to the known real function `asin`.
///
/// This function defines the analytic continuation of the arc sine function to the complex domain that is chosen to be the conventional principal branch among multi-branch complex logarithm.
///
/// While ``sin(_:)-9uhtf`` and ``sinh(_:)-7q9zp`` are directly connected, this function and ``asinh(_:)-4p7bd`` are not directly connected since they are the inverse functions of different branches.
/// For more discussion on this topic, see <doc:Complex-Functions-HyperbolicAndTrigonometric>.
public func asin(_ z: Complex<Float>) -> Complex<Float>{
    let iz = Complex<Float>(real: -z.imag, imag: z.real)
    let stillITimed = log(iz + sqrt(1 - z * z))
    return .init(real: stillITimed.imag, imag: -stillITimed.real)
}

/// Defines sin⁻¹(𝑧) := -𝒊 ㏑(𝒊𝑧 + √(1 - 𝑧²)) which analytically extends to the known real function `asin`.
///
/// This function defines the analytic continuation of the arc sine function to the complex domain that is chosen to be the conventional principal branch among multi-branch complex logarithm.
///
/// While ``sin(_:)-2qzc4`` and ``sinh(_:)-45gxc`` are directly connected, this function and ``asinh(_:)-1p72s`` are not directly connected since they are the inverse functions of different branches.
/// For more discussion on this topic, see <doc:Complex-Functions-HyperbolicAndTrigonometric>.
public func asin(_ z: Complex<Double>) -> Complex<Double>{
    let iz = Complex<Double>(real: -z.imag, imag: z.real)
    let stillITimed = log(iz + sqrt(1 - z * z))
    return .init(real: stillITimed.imag, imag: -stillITimed.real)
}

/// Defines tan⁻¹(𝑧) := tanh⁻¹(𝒊𝑧) / 𝒊 which analytically extends to the known real function `atan`.
///
/// Trigonometric functions and hyperbolic functions are connected and basically equivalent in complex level.
/// The inverse tangent function in complex domain is defined by tan⁻¹(𝑧) := tanh⁻¹(𝒊𝑧) / 𝒊.
/// See ``atanh(_:)-88065`` for the definition of tanh⁻¹.
public func atan(_ z: Complex<Float>) -> Complex<Float>{
    let atanhIz = atanh(.init(real: -z.imag, imag: z.real))
    return .init(real: atanhIz.imag, imag: -atanhIz.real)
}


/// Defines tan⁻¹(𝑧) := tanh⁻¹(𝒊𝑧) / 𝒊 which analytically extends to the known real function `atan`.
///
/// Trigonometric functions and hyperbolic functions are connected and basically equivalent in complex level.
/// The inverse tangent function in complex domain is defined by tan⁻¹(𝑧) := tanh⁻¹(𝒊𝑧) / 𝒊.
/// See ``atanh(_:)-6dnp1`` for the definition of tanh⁻¹.
public func atan(_ z: Complex<Double>) -> Complex<Double>{
    let atanhIz = atanh(.init(real: -z.imag, imag: z.real))
    return .init(real: atanhIz.imag, imag: -atanhIz.real)
}


/// Defines cot⁻¹(𝑧) := 𝒊 coth⁻¹(𝒊𝑧) which analytically extends to the known real function `acot`.
///
/// Trigonometric functions and hyperbolic functions are connected and basically equivalent in complex level.
/// The inverse cotangent function in complex domain is defined by cot⁻¹(𝑧) := 𝒊 coth⁻¹(𝒊𝑧).
/// See ``acoth(_:)-6vluc`` for the definition of coth⁻¹.
public func acot(_ z: Complex<Float>) -> Complex<Float>{
    let acothIz = acoth(.init(real: -z.imag, imag: z.real))
    return .init(real: -acothIz.imag, imag: acothIz.real)
}


/// Defines cot⁻¹(𝑧) := 𝒊 coth⁻¹(𝒊𝑧) which analytically extends to the known real function `acot`.
///
/// Trigonometric functions and hyperbolic functions are connected and basically equivalent in complex level.
/// The inverse cotangent function in complex domain is defined by cot⁻¹(𝑧) := 𝒊 coth⁻¹(𝒊𝑧).
/// See ``acoth(_:)-8g8a4`` for the definition of coth⁻¹.
public func acot(_ z: Complex<Double>) -> Complex<Double>{
    let acothIz = acoth(.init(real: -z.imag, imag: z.real))
    return .init(real: -acothIz.imag, imag: acothIz.real)
}

/*
// MARK: Gamma Function

// https://www.quora.com/How-do-I-calculate-the-gamma-function-of-a-complex-number
// https://mathworld.wolfram.com/LogGammaFunction.html

public func lgamma(_ z: Complex<Float>) -> Complex<Float>{
    var result = Complex<Float>(real: -z.real * Float.eulerGamma, imag: -z.imag * Float.eulerGamma)
    result -= log(z)
    var iteration = z - log(1+z)
    var k: Int = 1
    var resultSquareMagnitude = result.squareMagnitude
    var iterationSquareMagnitude = iteration.squareMagnitude
    while iterationSquareMagnitude / resultSquareMagnitude >= Float.ulpOfOne * Float.ulpOfOne{
        result += iteration
        resultSquareMagnitude = result.squareMagnitude
        k += 1
        let zOverK = Complex<Float>(real: z.real / Float(k), imag: z.imag / Float(k))
        iteration = zOverK - log(1+zOverK)
        iterationSquareMagnitude = iteration.squareMagnitude
        if resultSquareMagnitude < iterationSquareMagnitude{
            return .init(real: .infinity, imag: .nan)
        }
    }
    return result
}

public func lgamma(_ z: Complex<Double>) -> Complex<Double>{
    var result = Complex<Double>(real: -z.real * Double.eulerGamma, imag: -z.imag * Double.eulerGamma)
    result -= log(z)
    var iteration = z - log(1+z)
    var k: Int = 1
    var resultSquareMagnitude = result.squareMagnitude
    var iterationSquareMagnitude = iteration.squareMagnitude
    while iterationSquareMagnitude / resultSquareMagnitude >= Double.ulpOfOne * Double.ulpOfOne{
        result += iteration
        resultSquareMagnitude = result.squareMagnitude
        k += 1
        let zOverK = Complex<Double>(real: z.real / Double(k), imag: z.imag / Double(k))
        iteration = zOverK - log(1+zOverK)
        iterationSquareMagnitude = iteration.squareMagnitude
        if resultSquareMagnitude < iterationSquareMagnitude{
            return .init(real: .infinity, imag: .nan)
        }
    }
    return result
}


*/
