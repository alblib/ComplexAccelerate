//
//  Vector-Float.swift
//  
//
//  Created by Albertus Liberius on 2023-01-09.
//

import Foundation
import Accelerate

// MARK: Parallel Arithmetics

public extension Vector where Element == Float{
    internal static func parallel<VectorA, VectorB, R>(_ vectorA: VectorA, _ vectorB: VectorB, operation: (UnsafeBufferPointer<Float>, UnsafeBufferPointer<Float>) -> R) -> R
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
    static func add<VectorA, VectorB>(_ vectorA: VectorA, _ vectorB: VectorB) -> [Float]
    where VectorA: AccelerateBuffer, VectorB: AccelerateBuffer, VectorA.Element == Element, VectorB.Element == Element{
        parallel(vectorA, vectorB) { Accelerate.vDSP.add($0, $1) }
    }
    static func subtract<VectorA, VectorB>(_ vectorA: VectorA, _ vectorB: VectorB) -> [Float]
    where VectorA: AccelerateBuffer, VectorB: AccelerateBuffer, VectorA.Element == Element, VectorB.Element == Element{
        parallel(vectorA, vectorB) { Accelerate.vDSP.subtract($0, $1) }
    }
    static func multiply<VectorA, VectorB>(_ vectorA: VectorA, _ vectorB: VectorB) -> [Float]
    where VectorA: AccelerateBuffer, VectorB: AccelerateBuffer, VectorA.Element == Element, VectorB.Element == Element{
        parallel(vectorA, vectorB) { Accelerate.vDSP.multiply($0, $1) }
    }
    static func divide<VectorA, VectorB>(_ vectorA: VectorA, _ vectorB: VectorB) -> [Float]
    where VectorA: AccelerateBuffer, VectorB: AccelerateBuffer, VectorA.Element == Element, VectorB.Element == Element{
        parallel(vectorA, vectorB) { Accelerate.vDSP.divide($0, $1) }
    }
    
    // MARK: - Signs
    
    @inline(__always)
    static func absolute<VectorA>(_ vector: VectorA) -> [Float]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        Accelerate.vDSP.absolute(vector)
    }
    
    @inline(__always)
    static func negative<VectorA>(_ vector: VectorA) -> [Float]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        Accelerate.vDSP.negative(vector)
    }
    
    @inline(__always)
    static func negativeAbsolute<VectorA>(_ vector: VectorA) -> [Float]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        Accelerate.vDSP.negativeAbsolute(vector)
    }
    
    // MARK: Arithmetic between scalars
    
    
    @inline(__always)
    static func add<VectorA>(_ vector: VectorA, scalar: Float) -> [Float]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vDSP.add(scalar, vector)
    }
    @inline(__always)
    static func add<VectorA>(scalar: Float, _ vector: VectorA) -> [Float]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vDSP.add(scalar, vector)
    }
    
    @inline(__always)
    static func subtract<VectorA>(_ vector: VectorA, scalar: Float) -> [Float]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vDSP.add(-scalar, vector)
    }
    @inline(__always)
    static func subtract<VectorB>(scalar: Float, _ vector: VectorB) -> [Float]
    where VectorB: AccelerateBuffer, VectorB.Element == Element{
        vDSP.add(scalar, vDSP.negative(vector))
    }
    @inline(__always)
    static func multiply<VectorA>(_ vector: VectorA, scalar: Float) -> [Float]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vDSP.multiply(scalar, vector)
    }
    @inline(__always)
    static func multiply<VectorB>(scalar: Float, _ vector: VectorB) -> [Float]
    where VectorB: AccelerateBuffer, VectorB.Element == Element{
        vDSP.multiply(scalar, vector)
    }
    @inline(__always)
    static func divide<VectorA>(_ vector: VectorA, scalar: Float) -> [Float]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vDSP.divide(vector, scalar)
    }
    @inline(__always)
    static func divide<VectorB>(scalar: Float, _ vector: VectorB) -> [Float]
    where VectorB: AccelerateBuffer, VectorB.Element == Element{
        vDSP.divide(scalar, vector)
    }
    
    // MARK: Vector Calcalus
    
    @inline(__always)
    static func sum<VectorA>(_ vector: VectorA) -> Float
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vDSP.sum(vector)
    }
    @inline(__always)
    static func sumOfSquares<VectorA>(_ vector: VectorA) -> Float
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vDSP.sumOfSquares(vector)
    }
    @inline(__always)
    static func sumOfMagnitudes<VectorA>(_ vector: VectorA) -> Float
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vDSP.sumOfMagnitudes(vector)
    }
    /// Returns the mean of the given array.
    @inline(__always)
    static func mean<VectorA>(_ vector: VectorA) -> Float
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vDSP.mean(vector)
    }
    @inline(__always)
    static func meanSquare<VectorA>(_ vector: VectorA) -> Float
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vDSP.meanSquare(vector)
    }
    @inline(__always)
    static func meanMagnitude<VectorA>(_ vector: VectorA) -> Float
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vDSP.meanMagnitude(vector)
    }
    @inline(__always)
    static func rootMeanSquare<VectorA>(_ vector: VectorA) -> Float
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vDSP.rootMeanSquare(vector)
    }
    @inline(__always)
    static func dot<U, V>(_ vectorA: U, _ vectorB: V) -> Float
    where U: AccelerateBuffer, V: AccelerateBuffer, U.Element == Element, V.Element == Element{
        parallel(vectorA, vectorB) { vDSP.dot($0, $1) }
    }
    
    
    // MARK: - Log and Power
    
    /// Returns the natural logarithm for each element in an array.
    @inlinable
    static func log<ArrayType>(_ array: ArrayType) -> [Float]
    where ArrayType: AccelerateBuffer, ArrayType.Element == Element{
        vForce.log(array)
    }
    /// Returns the logarithm with base 10 for each element in an array.
    @inlinable
    static func log10<ArrayType>(_ array: ArrayType) -> [Float]
    where ArrayType: AccelerateBuffer, ArrayType.Element == Element{
        vForce.log10(array)
    }
    /// Returns the logarithm with base 2 for each element in an array.
    @inlinable
    static func log2<ArrayType>(_ array: ArrayType) -> [Float]
    where ArrayType: AccelerateBuffer, ArrayType.Element == Element{
        vForce.log2(array)
    }
    
    /// Returns the natural exponential function value for each element in an array.
    @inlinable
    static func exp<ArrayType>(_ array: ArrayType) -> [Float]
    where ArrayType: AccelerateBuffer, ArrayType.Element == Element{
        vForce.exp(array)
    }
    /// Returns the 2, raised to the power of each element in an array.
    @inlinable
    static func exp2<ArrayType>(_ array: ArrayType) -> [Float]
    where ArrayType: AccelerateBuffer, ArrayType.Element == Element{
        vForce.exp2(array)
    }
    /// Returns the 10, raised to the power of each element in an array.
    @inlinable
    static func exp10<ArrayType>(_ array: ArrayType) -> [Float]
    where ArrayType: AccelerateBuffer, ArrayType.Element == Element{
        return vForce.exp(vDSP.multiply(Foundation.log(10), array))
    }
    
    static func pow<Bases, Exponents>(bases: Bases, exponents: Exponents) -> [Float]
    where Bases: AccelerateBuffer, Exponents: AccelerateBuffer, Bases.Element == Element, Exponents.Element == Element
    {
        let count = min(bases.count, exponents.count)
        let count32 = Int32(count)
        return bases.withUnsafeBufferPointer { basesBuffer in
            exponents.withUnsafeBufferPointer { expsBuffer in
                withUnsafePointer(to: count32) { countPtr in
                    [Element](unsafeUninitializedCapacity: count) { buffer, initializedCount in
                        vvpowf(buffer.baseAddress!, expsBuffer.baseAddress!, basesBuffer.baseAddress!, countPtr)
                        initializedCount = count
                    }
                }
            }
        }
    }
    
    static func pow<Exponents>(base: Float, exponents: Exponents) -> [Float]
    where Exponents: AccelerateBuffer, Exponents.Element == Element
    {
        vForce.exp(vDSP.multiply(Foundation.logf(base), exponents))
    }
    
    static func pow<Bases>(bases: Bases, exponent: Float) -> [Float]
    where Bases: AccelerateBuffer, Bases.Element == Element
    {
        vForce.exp(vDSP.multiply(exponent, vForce.log(bases)))
    }
    
    // MARK: - Trigonometric Functions
    
    @inlinable
    static func cos<VectorA>(_ vector: VectorA) -> [Float]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vForce.cos(vector)
    }
    
    @inlinable
    static func sin<VectorA>(_ vector: VectorA) -> [Float]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vForce.sin(vector)
    }
    
    @inlinable
    static func tan<VectorA>(_ vector: VectorA) -> [Float]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vForce.tan(vector)
    }
    
    
    @inlinable
    static func acos<VectorA>(_ vector: VectorA) -> [Float]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vForce.acos(vector)
    }
    
    @inlinable
    static func asin<VectorA>(_ vector: VectorA) -> [Float]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vForce.asin(vector)
    }
    
    @inlinable
    static func atan<VectorA>(_ vector: VectorA) -> [Float]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        vForce.atan(vector)
    }
    
}
