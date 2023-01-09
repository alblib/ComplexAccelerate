//
//  Vector-Double.swift
//  
//
//  Created by Albertus Liberius on 2023-01-09.
//

import Foundation
import Accelerate


// MARK: Parallel Arithmetic
public extension Vector where Element == Double{
    internal static func parallel<VectorA, VectorB>(_ vectorA: VectorA, _ vectorB: VectorB, operation: (UnsafeBufferPointer<Double>, UnsafeBufferPointer<Double>) -> [Double]) -> [Double]
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
}
