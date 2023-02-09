//
//  Vector-Double.swift
//  
//
//  Created by Albertus Liberius on 2023-01-09.
//

import Foundation
import Accelerate


public extension Vector where Element == Double{
    
    // MARK: Create Vector
    
    static func zeros(count: Int) -> [Double]
    {
        guard count > 0 else{
            return []
        }
        return [Element](unsafeUninitializedCapacity: count) { buffer, initializedCount in
            guard let ptr = buffer.baseAddress else{
                return
            }
            vDSP_vclrD(ptr, 1, vDSP_Length(count))
            initializedCount = count
        }
    }
    
    static func create(repeating: Double, count: Int) -> [Double]
    {
        guard count > 0 else{
            return []
        }
        return [Element](unsafeUninitializedCapacity: count) { buffer, initializedCount in
            guard let oPtr = buffer.baseAddress else{
                return
            }
            withUnsafePointer(to: repeating) { iPtr in
                vDSP_vfillD(iPtr, oPtr, 1, vDSP_Length(count))
            }
            initializedCount = count
        }
    }
    static func arithmeticProgression(initialValue: Double, increment: Double, count: Int) -> [Double]
    {
        if count <= 0{
            return []
        }
        return vDSP.ramp(withInitialValue: initialValue, increment: increment, count: count)
    }
    static func arithmeticProgression(initialValue: Double, to finalValue: Double, count: Int) -> [Double]
    {
        arithmeticProgression(initialValue: initialValue, increment: (finalValue - initialValue) / Double(count - 1), count: count)
    }
    static func geometricProgression(initialValue: Double, ratio: Double, count: Int) -> [Double]
    {
        vForce.exp(vDSP.ramp(withInitialValue: Foundation.log(initialValue), increment: Foundation.log(ratio), count: count))
    }
    static func geometricProgression(initialValue: Double, to finalValue: Double, count: Int) -> [Double]
    {
        vForce.exp(arithmeticProgression(initialValue: Foundation.log(initialValue), to: Foundation.log(finalValue), count: count))
    }
    
    // MARK: - Parallel Arithmetic
    
    internal static func parallel<VectorA, VectorB, R>(_ vectorA: VectorA, _ vectorB: VectorB, operation: (UnsafeBufferPointer<Double>, UnsafeBufferPointer<Double>) -> R) -> R
    where VectorA: AccelerateBuffer, VectorB: AccelerateBuffer, VectorA.Element == Element, VectorB.Element == Element{
        let count = min(vectorA.count, vectorB.count)
        return vectorA.withUnsafeBufferPointer { bufferA in
            vectorB.withUnsafeBufferPointer { bufferB in
                let newBufferA = UnsafeBufferPointer(start: bufferA.baseAddress, count: count)
                let newBufferB = UnsafeBufferPointer(start: bufferB.baseAddress, count: count)
                return operation(newBufferA, newBufferB)
            }
        }
    }
    static func add<VectorA, VectorB>(_ vectorA: VectorA, _ vectorB: VectorB) -> [Double]
    where VectorA: AccelerateBuffer, VectorB: AccelerateBuffer, VectorA.Element == Element, VectorB.Element == Element{
        parallel(vectorA, vectorB) { Accelerate.vDSP.add($0, $1) }
    }
    static func subtract<VectorA, VectorB>(_ vectorA: VectorA, _ vectorB: VectorB) -> [Double]
    where VectorA: AccelerateBuffer, VectorB: AccelerateBuffer, VectorA.Element == Element, VectorB.Element == Element{
        parallel(vectorA, vectorB) { Accelerate.vDSP.subtract($0, $1) }
    }
    static func multiply<VectorA, VectorB>(_ vectorA: VectorA, _ vectorB: VectorB) -> [Double]
    where VectorA: AccelerateBuffer, VectorB: AccelerateBuffer, VectorA.Element == Element, VectorB.Element == Element{
        parallel(vectorA, vectorB) { Accelerate.vDSP.multiply($0, $1) }
    }
    static func divide<VectorA, VectorB>(_ vectorA: VectorA, _ vectorB: VectorB) -> [Double]
    where VectorA: AccelerateBuffer, VectorB: AccelerateBuffer, VectorA.Element == Element, VectorB.Element == Element{
        parallel(vectorA, vectorB) { Accelerate.vDSP.divide($0, $1) }
    }
    
    // MARK: - Signs
    
    @inline(__always)
    static func absolute<VectorA>(_ vector: VectorA) -> [Double]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        Accelerate.vDSP.absolute(vector)
    }
    
    @inline(__always)
    static func negative<VectorA>(_ vector: VectorA) -> [Double]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        Accelerate.vDSP.negative(vector)
    }
    
    @inline(__always)
    static func negativeAbsolute<VectorA>(_ vector: VectorA) -> [Double]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        Accelerate.vDSP.negativeAbsolute(vector)
    }
    
    @inline(__always)
    static func square<VectorA>(_ vector: VectorA) -> [Double]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        Accelerate.vDSP.square(vector)
    }
    
    // MARK: Arithmetic between scalars
    
    @inline(__always)
    static func add<VectorA>(_ vector: VectorA, _ scalar: Double) -> [Double]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vDSP.add(scalar, vector)
    }
    @inline(__always)
    static func add<VectorB>(_ scalar: Double, _ vector: VectorB) -> [Double]
    where VectorB: AccelerateBuffer, VectorB.Element == Element{
        vDSP.add(scalar, vector)
    }
    
    @inline(__always)
    static func subtract<VectorA>(_ vector: VectorA, _ scalar: Double) -> [Double]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vDSP.add(-scalar, vector)
    }
    @inline(__always)
    static func subtract<VectorB>(_ scalar: Double, _ vector: VectorB) -> [Double]
    where VectorB: AccelerateBuffer, VectorB.Element == Element{
        vDSP.add(scalar, vDSP.negative(vector))
    }
    @inline(__always)
    static func multiply<VectorA>(_ vector: VectorA, _ scalar: Double) -> [Double]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vDSP.multiply(scalar, vector)
    }
    @inline(__always)
    static func multiply<VectorB>(_ scalar: Double, _ vector: VectorB) -> [Double]
    where VectorB: AccelerateBuffer, VectorB.Element == Element{
        vDSP.multiply(scalar, vector)
    }
    @inline(__always)
    static func divide<VectorA>(_ vector: VectorA, _ scalar: Double) -> [Double]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vDSP.divide(vector, scalar)
    }
    @inline(__always)
    static func divide<VectorB>(_ scalar: Double, _ vector: VectorB) -> [Double]
    where VectorB: AccelerateBuffer, VectorB.Element == Element{
        vDSP.divide(scalar, vector)
    }
    
    // MARK: Vector Calcalus
    
    @inline(__always)
    static func sum<VectorA>(_ vector: VectorA) -> Double
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vDSP.sum(vector)
    }
    @inline(__always)
    static func sumOfSquares<VectorA>(_ vector: VectorA) -> Double
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vDSP.sumOfSquares(vector)
    }
    @inline(__always)
    static func sumOfMagnitudes<VectorA>(_ vector: VectorA) -> Double
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vDSP.sumOfMagnitudes(vector)
    }
    /// Returns the mean of the given array.
    @inline(__always)
    static func mean<VectorA>(_ vector: VectorA) -> Double
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vDSP.mean(vector)
    }
    @inline(__always)
    static func meanSquare<VectorA>(_ vector: VectorA) -> Double
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vDSP.meanSquare(vector)
    }
    @inline(__always)
    static func meanMagnitude<VectorA>(_ vector: VectorA) -> Double
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vDSP.meanMagnitude(vector)
    }
    @inline(__always)
    static func rootMeanSquare<VectorA>(_ vector: VectorA) -> Double
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vDSP.rootMeanSquare(vector)
    }
    @inline(__always)
    static func dot<U, V>(_ vectorA: U, _ vectorB: V) -> Double
    where U: AccelerateBuffer, V: AccelerateBuffer, U.Element == Element, V.Element == Element{
        parallel(vectorA, vectorB) { vDSP.dot($0,$1) }
    }
    
    
    // MARK: - Logs and Powers
    
    /// Returns the natural logarithm for each element in an array.
    @inlinable
    static func log<ArrayType>(_ array: ArrayType) -> [Double]
    where ArrayType: AccelerateBuffer, ArrayType.Element == Element{
        vForce.log(array)
    }
    /// Returns the logarithm with base 10 for each element in an array.
    @inlinable
    static func log10<ArrayType>(_ array: ArrayType) -> [Double]
    where ArrayType: AccelerateBuffer, ArrayType.Element == Element{
        vForce.log10(array)
    }
    /// Returns the logarithm with base 2 for each element in an array.
    @inlinable
    static func log2<ArrayType>(_ array: ArrayType) -> [Double]
    where ArrayType: AccelerateBuffer, ArrayType.Element == Element{
        vForce.log2(array)
    }
    
    /// Returns the natural exponential function value for each element in an array.
    @inlinable
    static func exp<ArrayType>(_ array: ArrayType) -> [Double]
    where ArrayType: AccelerateBuffer, ArrayType.Element == Element{
        vForce.exp(array)
    }
    /// Returns the 2, raised to the power of each element in an array.
    @inlinable
    static func exp2<ArrayType>(_ array: ArrayType) -> [Double]
    where ArrayType: AccelerateBuffer, ArrayType.Element == Element{
        vForce.exp2(array)
    }
    /// Returns the 10, raised to the power of each element in an array.
    @inlinable
    static func exp10<ArrayType>(_ array: ArrayType) -> [Double]
    where ArrayType: AccelerateBuffer, ArrayType.Element == Element{
        return vForce.exp(vDSP.multiply(Foundation.log(10), array))
    }
    
    static func pow<Bases, Exponents>(bases: Bases, exponents: Exponents) -> [Double]
    where Bases: AccelerateBuffer, Exponents: AccelerateBuffer, Bases.Element == Element, Exponents.Element == Element
    {
        let count = min(bases.count, exponents.count)
        let count32 = Int32(count)
        return bases.withUnsafeBufferPointer { basesBuffer in
            exponents.withUnsafeBufferPointer { expsBuffer in
                withUnsafePointer(to: count32) { countPtr in
                    [Element](unsafeUninitializedCapacity: count) { buffer, initializedCount in
                        vvpow(buffer.baseAddress!, expsBuffer.baseAddress!, basesBuffer.baseAddress!, countPtr)
                        initializedCount = count
                    }
                }
            }
        }
    }
    
    static func pow<Exponents>(base: Double, exponents: Exponents) -> [Double]
    where Exponents: AccelerateBuffer, Exponents.Element == Element
    {
        vForce.exp(vDSP.multiply(Foundation.log(base), exponents))
    }
    
    static func pow<Bases>(bases: Bases, exponent: Double) -> [Double]
    where Bases: AccelerateBuffer, Bases.Element == Element
    {
        vForce.exp(vDSP.multiply(exponent, vForce.log(bases)))
    }
    
    static func reciprocal<VectorA>(_ vector: VectorA) -> [Double]
    where VectorA: AccelerateBuffer, VectorA.Element == Element
    {
        vForce.reciprocal(vector)
    }
    
    static func sqrt<VectorA>(_ vector: VectorA) -> [Double]
    where VectorA: AccelerateBuffer, VectorA.Element == Element
    {
        vForce.sqrt(vector)
    }
    static func rsqrt<VectorA>(_ vector: VectorA) -> [Double]
    where VectorA: AccelerateBuffer, VectorA.Element == Element
    {
        vForce.rsqrt(vector)
    }
    
    // MARK: - Trigonometric Functions
    
    @inlinable
    static func cos<VectorA>(_ vector: VectorA) -> [Double]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vForce.cos(vector)
    }
    
    @inlinable
    static func sin<VectorA>(_ vector: VectorA) -> [Double]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vForce.sin(vector)
    }
    
    @inlinable
    static func tan<VectorA>(_ vector: VectorA) -> [Double]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vForce.tan(vector)
    }
    
    @inlinable
    static func cot<VectorA>(_ vector: VectorA) -> [Double]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vDSP.divide(1, vForce.tan(vector))
    }
    
    
    @inlinable
    static func acos<VectorA>(_ vector: VectorA) -> [Double]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vForce.acos(vector)
    }
    
    @inlinable
    static func asin<VectorA>(_ vector: VectorA) -> [Double]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vForce.asin(vector)
    }
    
    @inlinable
    static func atan<VectorA>(_ vector: VectorA) -> [Double]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vForce.atan(vector)
    }
    
    @inlinable
    static func acot<VectorA>(_ vector: VectorA) -> [Double]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vForce.atan(vDSP.divide(1, vector))
    }
    
    // MARK: - Hyperbolic Functions
    
    @inlinable
    static func cosh<VectorA>(_ vector: VectorA) -> [Double]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vForce.cosh(vector)
    }
    
    @inlinable
    static func sinh<VectorA>(_ vector: VectorA) -> [Double]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vForce.sinh(vector)
    }
    
    @inlinable
    static func tanh<VectorA>(_ vector: VectorA) -> [Double]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vForce.tanh(vector)
    }
    
    @inlinable
    static func coth<VectorA>(_ vector: VectorA) -> [Double]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vDSP.divide(1, vForce.tanh(vector))
    }
    
    
    @inlinable
    static func acosh<VectorA>(_ vector: VectorA) -> [Double]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vForce.acosh(vector)
    }
    
    @inlinable
    static func asinh<VectorA>(_ vector: VectorA) -> [Double]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vForce.asinh(vector)
    }
    
    @inlinable
    static func atanh<VectorA>(_ vector: VectorA) -> [Double]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vForce.atanh(vector)
    }
    
    @inlinable
    static func acoth<VectorA>(_ vector: VectorA) -> [Double]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vForce.atanh(vDSP.divide(1, vector))
    }
}
