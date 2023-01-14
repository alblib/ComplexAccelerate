//
//  Vector.swift
//  
//
//  Created by Albertus Liberius on 2023-01-09.
//

import Foundation
import Accelerate

public enum Vector<Element>{
    internal static func loop<VectorA, R>(_ vector: VectorA, operation: (Element) -> R ) -> [R]
    where VectorA: AccelerateBuffer, VectorA.Element == Element
    {
        let count = vector.count
        return vector.withUnsafeBufferPointer { bufferA in
            if var ptrA = bufferA.baseAddress{
                return [R](unsafeUninitializedCapacity: count) { buffer, initializedCount in
                    var resultPtr: UnsafeMutablePointer<R> = buffer.baseAddress!
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
    internal static func loop<VectorA, VectorB>(_ vectorA: VectorA, _ vectorB: VectorB, operation: (Element, Element) -> Element ) -> [Element]
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
    public static func create(repeating: Element, count: Int) -> [Element]
    {
        [Element](unsafeUninitializedCapacity: count) { buffer, initializedCount in
            guard var oPtr = buffer.baseAddress else{
                return
            }
            for _ in  0..<count{
                oPtr.initialize(to: repeating)
                oPtr += 1
            }
            initializedCount = count
        }
    }
}

public extension Vector where Element: AdditiveArithmetic{
    static func zeros(count: Int) -> [Element]{
        guard count > 0 else{
            return []
        }
        return [Element](unsafeUninitializedCapacity: count) { buffer, initializedCount in
            guard var oPtr = buffer.baseAddress else{
                return
            }
            for _ in  0..<count{
                oPtr.initialize(to: Element.zero)
                oPtr += 1
            }
            initializedCount = count
        }
    }
    static func add<VectorA, VectorB>(_ vectorA: VectorA, _ vectorB: VectorB) -> [Element]
    where VectorA: AccelerateBuffer, VectorB: AccelerateBuffer, VectorA.Element == Element, VectorB.Element == Element{
        return loop(vectorA, vectorB) { $0 + $1 }
    }
    
    static func subtract<VectorA, VectorB>(_ vectorA: VectorA, _ vectorB: VectorB) -> [Element]
    where VectorA: AccelerateBuffer, VectorB: AccelerateBuffer, VectorA.Element == Element, VectorB.Element == Element{
        loop(vectorA, vectorB) { $0 - $1 }
    }
    static func arithmeticProgression(initialValue: Element, increment: Element, count: Int) -> [Element]{
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
    
    static func multiply<VectorA>(_ vector: VectorA, _ scalar: Element) -> [Element]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        [Element](unsafeUninitializedCapacity: vector.count) { buffer, initializedCount in
            guard var ptr = buffer.baseAddress else{
                return
            }
            vector.withUnsafeBufferPointer { iBuffer in
                guard var iPtr = iBuffer.baseAddress else{
                    return
                }
                for _ in 0..<vector.count{
                    ptr.initialize(to: iPtr.pointee * scalar)
                    ptr += 1
                    iPtr += 1
                }
            }
            initializedCount = vector.count
        }
    }
    
    static func multiply<VectorB>(_ scalar: Element, _ vector: VectorB) -> [Element]
    where VectorB: AccelerateBuffer, VectorB.Element == Element{
        [Element](unsafeUninitializedCapacity: vector.count) { buffer, initializedCount in
            guard var ptr = buffer.baseAddress else{
                return
            }
            vector.withUnsafeBufferPointer { iBuffer in
                guard var iPtr = iBuffer.baseAddress else{
                    return
                }
                for _ in 0..<vector.count{
                    ptr.initialize(to: scalar * iPtr.pointee)
                    ptr += 1
                    iPtr += 1
                }
            }
            initializedCount = vector.count
        }
    }
    static func absolute<VectorA>(_ vector: VectorA) -> [Element.Magnitude]
    where VectorA: AccelerateBuffer, VectorA.Element == Element
    {
        loop(vector) { $0.magnitude }
    }
    static func geometricProgression(initialValue: Element, ratio: Element, count: Int) -> [Element]{
        if count <= 0{
            return []
        }
        return [Element](unsafeUninitializedCapacity: count) { buffer, initializedCount in
            var val = initialValue
            var ptr = buffer.baseAddress!
            ptr.initialize(to: val)
            for _ in 1..<count{
                ptr += 1
                val *= ratio
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

