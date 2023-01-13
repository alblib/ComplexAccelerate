//
//  Vector-Int.swift
//  
//
//  Created by Albertus Liberius on 2023-01-09.
//

import Foundation
import Accelerate


public extension Vector where Element == Int32{
    
    static func create(repeating: Int32, count: Int) -> [Int32]
    {
        guard count > 0 else{
            return []
        }
        return [Int32](unsafeUninitializedCapacity: count) { buffer, initializedCount in
            guard let ptr = buffer.baseAddress else{
                return
            }
            withUnsafePointer(to: repeating) { iPtr in
                vDSP_vfilli(iPtr, ptr, 1, vDSP_Length(count))
            }
            initializedCount = count
        }
        
    }
    
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
    
    static func absolute<VectorA>(_ vector: VectorA) -> [Int32]
    where VectorA: AccelerateBuffer, VectorA.Element == Int32 {
        let count = vector.count
        return vector.withUnsafeBufferPointer { iBuffer in
            if let ptr = iBuffer.baseAddress{
                return [Int32](unsafeUninitializedCapacity: count) { oBuffer, initializedCount in
                    vDSP_vabsi(ptr, 1, oBuffer.baseAddress!, 1, vDSP_Length(count))
                    initializedCount = count
                }
            }else{
                return []
            }
        }
    }
}
