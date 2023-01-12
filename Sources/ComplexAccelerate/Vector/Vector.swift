//
//  Vector.swift
//  
//
//  Created by Albertus Liberius on 2023-01-09.
//

import Foundation
import Accelerate

public enum Vector<Element>{
    
    static func loop<VectorA>(_ vector: VectorA, operation: (Element) -> Element ) -> [Element]
    where VectorA: AccelerateBuffer, VectorA.Element == Element
    {
        let count = vector.count
        return vector.withUnsafeBufferPointer { bufferA in
            if var ptrA = bufferA.baseAddress{
                return [Element](unsafeUninitializedCapacity: count) { buffer, initializedCount in
                    var resultPtr: UnsafeMutablePointer<Element> = buffer.baseAddress!
                    for _ in 0..<count{
                        resultPtr.initialize(to: operation(ptrA.pointee))
                        ptrA += 1
                        resultPtr += 1
                    }
                    initializedCount = count
                }
            }
            return []
        }
    }
    static func loop<VectorA, VectorB>(_ vectorA: VectorA, _ vectorB: VectorB, operation: (Element, Element) -> Element ) -> [Element]
    where VectorA: AccelerateBuffer, VectorB: AccelerateBuffer, VectorA.Element == Element, VectorB.Element == Element
    {
        let count = min(vectorA.count, vectorB.count)
        return vectorA.withUnsafeBufferPointer { bufferA in
            vectorB.withUnsafeBufferPointer { bufferB in
                if var ptrA = bufferA.baseAddress{
                    if var ptrB = bufferB.baseAddress{
                        return [Element](unsafeUninitializedCapacity: count) { buffer, initializedCount in
                            var resultPtr: UnsafeMutablePointer<Element> = buffer.baseAddress!
                            for _ in 0..<count{
                                resultPtr.initialize(to: operation(ptrA.pointee, ptrB.pointee))
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

public extension Vector where Element: AdditiveArithmetic{
    static func add<VectorA, VectorB>(_ vectorA: VectorA, _ vectorB: VectorB) -> [Element]
    where VectorA: AccelerateBuffer, VectorB: AccelerateBuffer, VectorA.Element == Element, VectorB.Element == Element{
        loop(vectorA, vectorB) { $0 + $1 }
    }
    
    static func subtract<VectorA, VectorB>(_ vectorA: VectorA, _ vectorB: VectorB) -> [Element]
    where VectorA: AccelerateBuffer, VectorB: AccelerateBuffer, VectorA.Element == Element, VectorB.Element == Element{
        loop(vectorA, vectorB) { $0 - $1 }
    }
    static func create(initialValue: Element, increment: Element, count: Int) -> [Element]{
        if count <= 0{
            return []
        }
        return [Element](unsafeUninitializedCapacity: count) { buffer, initializedCount in
            var val = initialValue
            var ptr = buffer.baseAddress!
            ptr.initialize(to: val)
            for _ in 1..<count{
                ptr += 1
                val += increment
                ptr.initialize(to: val)
            }
            initializedCount = count
        }
    }
}

public extension Vector where Element: Numeric{
    static func multiply<VectorA, VectorB>(_ vectorA: VectorA, _ vectorB: VectorB) -> [Element]
    where VectorA: AccelerateBuffer, VectorB: AccelerateBuffer, VectorA.Element == Element, VectorB.Element == Element{
        loop(vectorA, vectorB) { $0 * $1 }
    }
    static func create(initialValue: Element, multiplyingBy factor: Element, count: Int) -> [Element]{
        if count <= 0{
            return []
        }
        return [Element](unsafeUninitializedCapacity: count) { buffer, initializedCount in
            var val = initialValue
            var ptr = buffer.baseAddress!
            ptr.initialize(to: val)
            for _ in 1..<count{
                ptr += 1
                val *= factor
                ptr.initialize(to: val)
            }
            initializedCount = count
        }
    }
}

public extension Vector where Element: SignedNumeric{
    static func negative<VectorA>(_ vector: VectorA) -> [Element]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        loop(vector) {-$0}
    }
}

