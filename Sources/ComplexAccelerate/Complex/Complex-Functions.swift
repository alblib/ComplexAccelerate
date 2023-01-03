//
//  Complex-Functions.swift
//  
//
//  Created by Albertus Liberius on 2023-01-03.
//

import Foundation
import Accelerate
import simd


public func abs<Real>(_ z: Complex<Real>) -> Real where Real: FloatingPoint{
    z.magnitude
}

public func arg(_ z: Complex<Float>) -> Float{
    atan2f(z.imag, z.real)
}

public func arg(_ z: Complex<Double>) -> Double{
    atan2(z.imag, z.real)
}

public func log(_ z: Complex<Float>) -> Complex<Float>{
    Complex<Float>(real: logf(abs(z)), imag: arg(z))
}

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

public func cosh(_ z: Complex<Float>) -> Complex<Float>{
    var result = exp(z) + exp(-z)
    result.real /= 2
    result.imag /= 2
    return result
}
public func cosh(_ z: Complex<Double>) -> Complex<Double>{
    var result = exp(z) + exp(-z)
    result.real /= 2
    result.imag /= 2
    return result
}


public func sinh(_ z: Complex<Float>) -> Complex<Float>{
    var result = exp(z) - exp(-z)
    result.real /= 2
    result.imag /= 2
    return result
}
public func sinh(_ z: Complex<Double>) -> Complex<Double>{
    var result = exp(z) - exp(-z)
    result.real /= 2
    result.imag /= 2
    return result
}

public func tanh(_ z: Complex<Float>) -> Complex<Float>{
    let expP = exp(z)
    let expM = exp(-z)
    let numerator = expP - expM
    let denominator = expP + expM
    return numerator / denominator
}

public func tanh(_ z: Complex<Double>) -> Complex<Double>{
    let expP = exp(z)
    let expM = exp(-z)
    let numerator = expP - expM
    let denominator = expP + expM
    return numerator / denominator
}

public func coth(_ z: Complex<Float>) -> Complex<Float>{
    let expP = exp(z)
    let expM = exp(-z)
    let numerator = expP + expM
    let denominator = expP - expM
    return numerator / denominator
}

public func coth(_ z: Complex<Double>) -> Complex<Double>{
    let expP = exp(z)
    let expM = exp(-z)
    let numerator = expP + expM
    let denominator = expP - expM
    return numerator / denominator
}

/// Defines the complex function ㏑(z + √(z^2 - 1)) which analytically extends to `acosh`.
public func acosh(_ z: Complex<Float>) -> Complex<Float>{
    log(sqrt(z * z - 1) + z)
}

/// Defines the complex function ㏑(z + √(z^2 - 1)) which analytically extends to `acosh`.
public func acosh(_ z: Complex<Double>) -> Complex<Double>{
    log(sqrt(z * z - 1) + z)
}

/// Defines the complex function ㏑(z + √(z^2 + 1)) which analytically extends to `asinh`.
public func asinh(_ z: Complex<Float>) -> Complex<Float>{
    log(sqrt(z * z + 1) + z)
}

/// Defines the complex function ㏑(z + √(z^2 + 1)) which analytically extends to `asinh`.
public func asinh(_ z: Complex<Double>) -> Complex<Double>{
    log(sqrt(z * z + 1) + z)
}

/// Defines the complex function ㏑(√((1 + z) / (1 - z))) which analytically extends to `atanh`.
public func atanh(_ z: Complex<Float>) -> Complex<Float>{
    log(sqrt((1 + z) / (1 - z)))
}
/// Defines the complex function ㏑(√((1 + z) / (1 - z))) which analytically extends to `atanh`.
public func atanh(_ z: Complex<Double>) -> Complex<Double>{
    log(sqrt((1 + z) / (1 - z)))
}

/// Defines the complex function ㏑(√((z + 1) / (z - 1))) which analytically extends to `acoth`.
public func acoth(_ z: Complex<Float>) -> Complex<Float>{
    log(sqrt((z + 1) / (z - 1)))
}
/// Defines the complex function ㏑(√((z + 1) / (z - 1))) which analytically extends to `acoth`.
public func acoth(_ z: Complex<Double>) -> Complex<Double>{
    log(sqrt((z + 1) / (z - 1)))
}

public func cos(_ z: Complex<Float>) -> Complex<Float>{
    cosh(.init(real: -z.imag, imag: z.real))
}
public func cos(_ z: Complex<Double>) -> Complex<Double>{
    cosh(.init(real: -z.imag, imag: z.real))
}
public func sin(_ z: Complex<Float>) -> Complex<Float>{
    let id = sinh(.init(real: -z.imag, imag: z.real))
    return .init(real: id.imag, imag: -id.real)
}
public func sin(_ z: Complex<Double>) -> Complex<Double>{
    let id = sinh(.init(real: -z.imag, imag: z.real))
    return .init(real: id.imag, imag: -id.real)
}
public func tan(_ z: Complex<Float>) -> Complex<Float>{
    let id = tanh(.init(real: -z.imag, imag: z.real))
    return .init(real: id.imag, imag: -id.real)
}
public func tan(_ z: Complex<Double>) -> Complex<Double>{
    let id = tanh(.init(real: -z.imag, imag: z.real))
    return .init(real: id.imag, imag: -id.real)
}
public func cot(_ z: Complex<Float>) -> Complex<Float>{
    let id = coth(.init(real: -z.imag, imag: z.real))
    return .init(real: -id.imag, imag: id.real)
}
public func cot(_ z: Complex<Double>) -> Complex<Double>{
    let id = coth(.init(real: -z.imag, imag: z.real))
    return .init(real: -id.imag, imag: id.real)
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
