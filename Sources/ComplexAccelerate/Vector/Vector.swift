//
//  Vector.swift
//  
//
//  Created by Albertus Liberius on 2023-01-09.
//

import Foundation
import Accelerate

public enum Vector<Element>{}




public extension Vector where Element: AdditiveArithmetic{
    static func add<VectorA, VectorB>(_ vectorA: VectorA, _ vectorB: VectorB) -> [Element]
    where VectorA: AccelerateBuffer, VectorB: AccelerateBuffer, VectorA.Element == Element, VectorB.Element == Element{
        let count = min(vectorA.count, vectorB.count)
        return vectorA.withUnsafeBufferPointer { bufferA in
            vectorB.withUnsafeBufferPointer { bufferB in
                if var ptrA = bufferA.baseAddress{
                    if var ptrB = bufferB.baseAddress{
                        return [Element](unsafeUninitializedCapacity: count) { buffer, initializedCount in
                            var resultPtr: UnsafeMutablePointer<Element> = buffer.baseAddress!
                            for _ in 0..<count{
                                resultPtr.initialize(to: ptrA.pointee + ptrB.pointee)
                                ptrA += 1
                                ptrB += 1
                                resultPtr += 1
                            }
                            initializedCount = count
                        }
                    }
                }
                return []
            }
        }
    }
    static func subtract<VectorA, VectorB>(_ vectorA: VectorA, _ vectorB: VectorB) -> [Element]
    where VectorA: AccelerateBuffer, VectorB: AccelerateBuffer, VectorA.Element == Element, VectorB.Element == Element{
        let count = min(vectorA.count, vectorB.count)
        return vectorA.withUnsafeBufferPointer { bufferA in
            vectorB.withUnsafeBufferPointer { bufferB in
                if var ptrA = bufferA.baseAddress{
                    if var ptrB = bufferB.baseAddress{
                        return [Element](unsafeUninitializedCapacity: count) { buffer, initializedCount in
                            var resultPtr: UnsafeMutablePointer<Element> = buffer.baseAddress!
                            for _ in 0..<count{
                                resultPtr.initialize(to: ptrA.pointee - ptrB.pointee)
                                ptrA += 1
                                ptrB += 1
                                resultPtr += 1
                            }
                            initializedCount = count
                        }
                    }
                }
                return []
            }
        }
    }
}

public extension Vector where Element: Numeric{
    static func multiply<VectorA, VectorB>(_ vectorA: VectorA, _ vectorB: VectorB) -> [Element]
    where VectorA: AccelerateBuffer, VectorB: AccelerateBuffer, VectorA.Element == Element, VectorB.Element == Element{
        let count = min(vectorA.count, vectorB.count)
        return vectorA.withUnsafeBufferPointer { bufferA in
            vectorB.withUnsafeBufferPointer { bufferB in
                if var ptrA = bufferA.baseAddress{
                    if var ptrB = bufferB.baseAddress{
                        return [Element](unsafeUninitializedCapacity: count) { buffer, initializedCount in
                            var resultPtr: UnsafeMutablePointer<Element> = buffer.baseAddress!
                            for _ in 0..<count{
                                resultPtr.initialize(to: ptrA.pointee * ptrB.pointee)
                                ptrA += 1
                                ptrB += 1
                                resultPtr += 1
                            }
                            initializedCount = count
                        }
                    }
                }
                return []
            }
        }
    }
}


public extension Vector where Element == Int32{
    
    static func add<VectorA, VectorB>(_ vectorA: VectorA, _ vectorB: VectorB) -> [Int32]
    where VectorA: AccelerateBuffer, VectorB: AccelerateBuffer, VectorA.Element == Int32, VectorB.Element == Int32 {
        let count = min(vectorA.count, vectorB.count)
        return vectorA.withUnsafeBufferPointer { bufferA in
            return vectorB.withUnsafeBufferPointer { bufferB in
                if let ptrA = bufferA.baseAddress{
                    if let ptrB = bufferB.baseAddress{
                        return [Int32](unsafeUninitializedCapacity: count) { buffer, initializedCount in
                            vDSP_vaddi(ptrA, 1, ptrB, 1, buffer.baseAddress!, 1, vDSP_Length(count))
                            initializedCount = count
                        }
                    }else{
                        return []
                    }
                }else{
                    return []
                }
            }
        }
    }
    
    static func add<VectorA>(_ scalar: Int32, _ vector: VectorA) -> [Int32]
    where VectorA: AccelerateBuffer, VectorA.Element == Int32 {
        let count = vector.count
        return vector.withUnsafeBufferPointer { iBuffer in
            if let ptr = iBuffer.baseAddress{
                return [Int32](unsafeUninitializedCapacity: count) { oBuffer, initializedCount in
                    withUnsafePointer(to: scalar) { scalarPtr in
                        vDSP_vsaddi(ptr, 1, scalarPtr, oBuffer.baseAddress!, 1, vDSP_Length(count))
                    }
                    initializedCount = count
                }
            }else{
                return []
            }
        }
    }
    
    @inline(__always)
    static func add<VectorA>(_ vector: VectorA, _ scalar: Int32) -> [Int32]
    where VectorA: AccelerateBuffer, VectorA.Element == Int32 {
        add(scalar, vector)
    }
}
