//
//  Vector.swift
//  
//
//  Created by Albertus Liberius on 2023-01-09.
//

import Foundation
import Accelerate

/// A generic namespace for parallel functions on floating-point real and complex numbers.
///
/// This is a namespace for `vDSP` and `vForce` parallelized operations on `Float`, `Double`, and `Complex`es.
/// This enumeration structure is specialized and specifically bound to `vDSP` functions directly only if `Element` is given by
/// * `Float`  (from the system `Swift` package)
/// * `Double`  (from the system `Swift` package)
/// * `Complex<Float>`
/// * `Complex<Double>`
/// * `DSPComplex` (from Apple's `Accelerate` package), or
/// * `DSPDoubleComplex` (from Apple's `Accelerate` package).
/// for major massive parallel calculations. Other subsidiary features may be implemented in specializations for some other types.
///
/// This enumeration structure features
/// * Generics with General Implementation and Specialization for parallelizable types,
/// * Dynamic Specialization in even General Implementation to Optimize Indirect-type calls, and
/// * Error-proof, preventing exception as possible.
///
/// ### General Implementation and Calling Specialization Directly
///
/// Even if `Element` is not given as above, if `Element` conforms to certain protocols,
/// a general implementation based on for-loop and protocol-provided functions is given.
/// To call the parallel functions without ambiguity, speficify the generic argument explicitly and directly e.g. `Vector<Complex<Double>>.someFunction()`.
/// ```swift
/// extension Double: Numeric {}
/// let a: [Double] = [1, 2, 3]
///
/// /* Direct Call:
///    calls Vector<Double>.multiply(Double, Double)
///    i.e. Accelerate.vDSP.multiply(Double, Double). */
/// Vector<Double>.multiply(a, a)
///
/// /* calls Vector<Double>.multiply(Double, Double),
///    inferred by direct declaration of argument a: [Double]. */
/// Vector.multiply(a, a)
///
/// /*　Indirect Call:
///    Calls the general function
///    Vector<Numeric>.multiply(Numeric, Numeric)
///    not Vector<Double>.multiply(Double, Double). */
/// test(array: a)
/// func test(array: [Number]) where Number: Numeric{
///     Vector.multiply(array, array)
/// }
/// ```
/// ### Dynamic(runtime) Specialization
/// If generic argument typename is not assigned directly, `Swift` compiler does not call the specialization.
/// For such indirect reference, this structure also implements dynamic specialization in the general case.
/// The definition `Vector<Element>.someFunction()` for general `Element` runs conditional statement to test the input type in runtime.
/// ```swift
/// public struct Vector<Element>{
///     func someFunction(input: Element){
///         if Element.self is Float.Type{
///             ...
///         }else if Element.self is Double.Type{
///             ...
///         }...
///     }
/// }
/// ```
/// The explicit specializations of `Vector` are implemented for 6 types so 6 conditions are tested in the general implementation.
/// So, to shorten the execution time, use direct call as possible.
/// > Note: Dynamic specialization guarantees to call vDSP and other vecLib functions as possible, but to shorten execution time, please use direct specialization with explicit type name as possible.
///
/// ### Error-proof
/// Functions in this namespace are specified to avoid exceptions as possible.
///
/// In vector operations, the most annoying case to prevent guaranteeing error-proof is the dimension mismatch.
/// `vDSP` binary operations requires two array having same dimension.
/// In `Vector`, functions operates only on common parts of each vector, so the result would be the lesser of the dimensions of the two input vectors.
/// 
/// Also, when you generate a vector, there can be a user mistake that assigns the dimension negative.
/// This implementation also prevents this and returns empty vector in such case.
///
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
        if Element.self is Float.Type{
            return Vector<Float>.create(repeating: repeating as! Float, count: count) as! [Element]
        }else if Element.self is Double.Type{
            return Vector<Double>.create(repeating: repeating as! Double, count: count) as! [Element]
        }else if Element.self is DSPComplex.Type{
            return Vector<DSPComplex>.create(repeating: repeating as! DSPComplex, count: count) as! [Element]
        }else if Element.self is DSPDoubleComplex.Type{
            return Vector<DSPDoubleComplex>.create(repeating: repeating as! DSPDoubleComplex, count: count) as! [Element]
        }else if Element.self is Complex<Float>.Type{
            return Vector<Complex<Float>>.create(repeating: repeating as! Complex<Float>, count: count) as! [Element]
        }else if Element.self is Complex<Double>.Type{
            return Vector<Complex<Double>>.create(repeating: repeating as! Complex<Double>, count: count) as! [Element]
        }else{
            if count < 0 {
                return []
            }
            return [Element](repeating: repeating, count: count)
        }
    }
}

public extension Vector where Element: AdditiveArithmetic{
    static func zeros(count: Int) -> [Element]{
        if Element.self is Float.Type{
            return Vector<Float>.zeros(count: count) as! [Element]
        }else if Element.self is Double.Type{
            return Vector<Double>.zeros(count: count) as! [Element]
        }else if Element.self is DSPComplex.Type{
            return Vector<DSPComplex>.zeros(count: count) as! [Element]
        }else if Element.self is DSPDoubleComplex.Type{
            return Vector<DSPDoubleComplex>.zeros(count: count) as! [Element]
        }else if Element.self is Complex<Float>.Type{
            return Vector<Complex<Float>>.zeros(count: count) as! [Element]
        }else if Element.self is Complex<Double>.Type{
            return Vector<Complex<Double>>.zeros(count: count) as! [Element]
        }else{
            
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
    }
    static func add<VectorA, VectorB>(_ vectorA: VectorA, _ vectorB: VectorB) -> [Element]
    where VectorA: AccelerateBuffer, VectorB: AccelerateBuffer, VectorA.Element == Element, VectorB.Element == Element{
        if Element.self is Float.Type{
            return vectorA.withUnsafeBufferPointer { bufferA in
                bufferA.withMemoryRebound(to: Float.self) { bufferA in
                    vectorB.withUnsafeBufferPointer { bufferB in
                        bufferB.withMemoryRebound(to: Float.self) { bufferB in
                            return Vector<Float>.add(bufferA, bufferB) as! [Element]
                        }
                    }
                }
            }
        }else if Element.self is Double.Type{
            return vectorA.withUnsafeBufferPointer { bufferA in
                bufferA.withMemoryRebound(to: Double.self) { bufferA in
                    vectorB.withUnsafeBufferPointer { bufferB in
                        bufferB.withMemoryRebound(to: Double.self) { bufferB in
                            return Vector<Double>.add(bufferA, bufferB) as! [Element]
                        }
                    }
                }
            }
        }else if Element.self is DSPComplex.Type{
            return vectorA.withUnsafeBufferPointer { bufferA in
                bufferA.withMemoryRebound(to: DSPComplex.self) { bufferA in
                    vectorB.withUnsafeBufferPointer { bufferB in
                        bufferB.withMemoryRebound(to: DSPComplex.self) { bufferB in
                            return Vector<DSPComplex>.add(bufferA, bufferB) as! [Element]
                        }
                    }
                }
            }
        }else if Element.self is DSPDoubleComplex.Type{
            return vectorA.withUnsafeBufferPointer { bufferA in
                bufferA.withMemoryRebound(to: DSPDoubleComplex.self) { bufferA in
                    vectorB.withUnsafeBufferPointer { bufferB in
                        bufferB.withMemoryRebound(to: DSPDoubleComplex.self) { bufferB in
                            return Vector<DSPDoubleComplex>.add(bufferA, bufferB) as! [Element]
                        }
                    }
                }
            }
        }else if Element.self is Complex<Float>.Type{
            return vectorA.withUnsafeBufferPointer { bufferA in
                bufferA.withMemoryRebound(to: Complex<Float>.self) { bufferA in
                    vectorB.withUnsafeBufferPointer { bufferB in
                        bufferB.withMemoryRebound(to: Complex<Float>.self) { bufferB in
                            return Vector<Complex<Float>>.add(bufferA, bufferB) as! [Element]
                        }
                    }
                }
            }
        }else if Element.self is Complex<Double>.Type{
            return vectorA.withUnsafeBufferPointer { bufferA in
                bufferA.withMemoryRebound(to: Complex<Double>.self) { bufferA in
                    vectorB.withUnsafeBufferPointer { bufferB in
                        bufferB.withMemoryRebound(to: Complex<Double>.self) { bufferB in
                            return Vector<Complex<Double>>.add(bufferA, bufferB) as! [Element]
                        }
                    }
                }
            }
        }else{
            return loop(vectorA, vectorB) { $0 + $1 }
        }
    }
    
    static func add<VectorB>(_ scalar: Element, _ vector: VectorB) -> [Element]
    where VectorB: AccelerateBuffer, VectorB.Element == Element{
        if Element.self is Float.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: Float.self) { buffer in
                    return Vector<Float>.add(scalar as! Float, buffer) as! [Element]
                }
            }
        }else if Element.self is Double.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: Double.self) { buffer in
                    return Vector<Double>.add(scalar as! Double, buffer) as! [Element]
                }
            }
        }else if Element.self is DSPComplex.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: DSPComplex.self) { buffer in
                    return Vector<DSPComplex>.add(scalar as! DSPComplex, buffer) as! [Element]
                }
            }
        }else if Element.self is DSPDoubleComplex.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: DSPDoubleComplex.self) { buffer in
                    return Vector<DSPDoubleComplex>.add(scalar as! DSPDoubleComplex, buffer) as! [Element]
                }
            }
        }else if Element.self is Complex<Float>.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: Complex<Float>.self) { buffer in
                    return Vector<Complex<Float>>.add(scalar as! Complex<Float>, buffer) as! [Element]
                }
            }
        }else if Element.self is Complex<Double>.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: Complex<Double>.self) { buffer in
                    return Vector<Complex<Double>>.add(scalar as! Complex<Double>, buffer) as! [Element]
                }
            }
        }else{
            
            return [Element](unsafeUninitializedCapacity: vector.count) { buffer, initializedCount in
                guard var ptr = buffer.baseAddress else{
                    return
                }
                vector.withUnsafeBufferPointer { iBuffer in
                    guard var iPtr = iBuffer.baseAddress else{
                        return
                    }
                    for _ in 0..<vector.count{
                        ptr.initialize(to: scalar + iPtr.pointee)
                        ptr += 1
                        iPtr += 1
                    }
                }
                initializedCount = vector.count
            }
            
        }
    }
    
    static func add<VectorA>(_ vector: VectorA, _ scalar: Element) -> [Element]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        if Element.self is Float.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: Float.self) { buffer in
                    return Vector<Float>.add(buffer, scalar as! Float) as! [Element]
                }
            }
        }else if Element.self is Double.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: Double.self) { buffer in
                    return Vector<Double>.add(buffer, scalar as! Double) as! [Element]
                }
            }
        }else if Element.self is DSPComplex.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: DSPComplex.self) { buffer in
                    return Vector<DSPComplex>.add(buffer, scalar as! DSPComplex) as! [Element]
                }
            }
        }else if Element.self is DSPDoubleComplex.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: DSPDoubleComplex.self) { buffer in
                    return Vector<DSPDoubleComplex>.add(buffer, scalar as! DSPDoubleComplex) as! [Element]
                }
            }
        }else if Element.self is Complex<Float>.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: Complex<Float>.self) { buffer in
                    return Vector<Complex<Float>>.add(buffer, scalar as! Complex<Float>) as! [Element]
                }
            }
        }else if Element.self is Complex<Double>.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: Complex<Double>.self) { buffer in
                    return Vector<Complex<Double>>.add(buffer, scalar as! Complex<Double>) as! [Element]
                }
            }
        }else{
            
            return [Element](unsafeUninitializedCapacity: vector.count) { buffer, initializedCount in
                guard var ptr = buffer.baseAddress else{
                    return
                }
                vector.withUnsafeBufferPointer { iBuffer in
                    guard var iPtr = iBuffer.baseAddress else{
                        return
                    }
                    for _ in 0..<vector.count{
                        ptr.initialize(to: iPtr.pointee + scalar)
                        ptr += 1
                        iPtr += 1
                    }
                }
                initializedCount = vector.count
            }
            
        }
    }
    
    
    static func subtract<VectorA, VectorB>(_ vectorA: VectorA, _ vectorB: VectorB) -> [Element]
    where VectorA: AccelerateBuffer, VectorB: AccelerateBuffer, VectorA.Element == Element, VectorB.Element == Element{
        if Element.self is Float.Type{
            return vectorA.withUnsafeBufferPointer { bufferA in
                bufferA.withMemoryRebound(to: Float.self) { bufferA in
                    vectorB.withUnsafeBufferPointer { bufferB in
                        bufferB.withMemoryRebound(to: Float.self) { bufferB in
                            return Vector<Float>.subtract(bufferA, bufferB) as! [Element]
                        }
                    }
                }
            }
        }else if Element.self is Double.Type{
            return vectorA.withUnsafeBufferPointer { bufferA in
                bufferA.withMemoryRebound(to: Double.self) { bufferA in
                    vectorB.withUnsafeBufferPointer { bufferB in
                        bufferB.withMemoryRebound(to: Double.self) { bufferB in
                            return Vector<Double>.subtract(bufferA, bufferB) as! [Element]
                        }
                    }
                }
            }
        }else if Element.self is DSPComplex.Type{
            return vectorA.withUnsafeBufferPointer { bufferA in
                bufferA.withMemoryRebound(to: DSPComplex.self) { bufferA in
                    vectorB.withUnsafeBufferPointer { bufferB in
                        bufferB.withMemoryRebound(to: DSPComplex.self) { bufferB in
                            return Vector<DSPComplex>.subtract(bufferA, bufferB) as! [Element]
                        }
                    }
                }
            }
        }else if Element.self is DSPDoubleComplex.Type{
            return vectorA.withUnsafeBufferPointer { bufferA in
                bufferA.withMemoryRebound(to: DSPDoubleComplex.self) { bufferA in
                    vectorB.withUnsafeBufferPointer { bufferB in
                        bufferB.withMemoryRebound(to: DSPDoubleComplex.self) { bufferB in
                            return Vector<DSPDoubleComplex>.subtract(bufferA, bufferB) as! [Element]
                        }
                    }
                }
            }
        }else if Element.self is Complex<Float>.Type{
            return vectorA.withUnsafeBufferPointer { bufferA in
                bufferA.withMemoryRebound(to: Complex<Float>.self) { bufferA in
                    vectorB.withUnsafeBufferPointer { bufferB in
                        bufferB.withMemoryRebound(to: Complex<Float>.self) { bufferB in
                            return Vector<Complex<Float>>.subtract(bufferA, bufferB) as! [Element]
                        }
                    }
                }
            }
        }else if Element.self is Complex<Double>.Type{
            return vectorA.withUnsafeBufferPointer { bufferA in
                bufferA.withMemoryRebound(to: Complex<Double>.self) { bufferA in
                    vectorB.withUnsafeBufferPointer { bufferB in
                        bufferB.withMemoryRebound(to: Complex<Double>.self) { bufferB in
                            return Vector<Complex<Double>>.subtract(bufferA, bufferB) as! [Element]
                        }
                    }
                }
            }
        }else{
            return loop(vectorA, vectorB) { $0 - $1 }
        }
    }
    
    
    static func subtract<VectorB>(_ scalar: Element, _ vector: VectorB) -> [Element]
    where VectorB: AccelerateBuffer, VectorB.Element == Element{
        if Element.self is Float.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: Float.self) { buffer in
                    return Vector<Float>.subtract(scalar as! Float, buffer) as! [Element]
                }
            }
        }else if Element.self is Double.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: Double.self) { buffer in
                    return Vector<Double>.subtract(scalar as! Double, buffer) as! [Element]
                }
            }
        }else if Element.self is DSPComplex.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: DSPComplex.self) { buffer in
                    return Vector<DSPComplex>.subtract(scalar as! DSPComplex, buffer) as! [Element]
                }
            }
        }else if Element.self is DSPDoubleComplex.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: DSPDoubleComplex.self) { buffer in
                    return Vector<DSPDoubleComplex>.subtract(scalar as! DSPDoubleComplex, buffer) as! [Element]
                }
            }
        }else if Element.self is Complex<Float>.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: Complex<Float>.self) { buffer in
                    return Vector<Complex<Float>>.subtract(scalar as! Complex<Float>, buffer) as! [Element]
                }
            }
        }else if Element.self is Complex<Double>.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: Complex<Double>.self) { buffer in
                    return Vector<Complex<Double>>.subtract(scalar as! Complex<Double>, buffer) as! [Element]
                }
            }
        }else{
            
            return [Element](unsafeUninitializedCapacity: vector.count) { buffer, initializedCount in
                guard var ptr = buffer.baseAddress else{
                    return
                }
                vector.withUnsafeBufferPointer { iBuffer in
                    guard var iPtr = iBuffer.baseAddress else{
                        return
                    }
                    for _ in 0..<vector.count{
                        ptr.initialize(to: scalar - iPtr.pointee)
                        ptr += 1
                        iPtr += 1
                    }
                }
                initializedCount = vector.count
            }
            
        }
    }
    
    static func subtract<VectorA>(_ vector: VectorA, _ scalar: Element) -> [Element]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        if Element.self is Float.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: Float.self) { buffer in
                    return Vector<Float>.subtract(buffer, scalar as! Float) as! [Element]
                }
            }
        }else if Element.self is Double.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: Double.self) { buffer in
                    return Vector<Double>.subtract(buffer, scalar as! Double) as! [Element]
                }
            }
        }else if Element.self is DSPComplex.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: DSPComplex.self) { buffer in
                    return Vector<DSPComplex>.subtract(buffer, scalar as! DSPComplex) as! [Element]
                }
            }
        }else if Element.self is DSPDoubleComplex.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: DSPDoubleComplex.self) { buffer in
                    return Vector<DSPDoubleComplex>.subtract(buffer, scalar as! DSPDoubleComplex) as! [Element]
                }
            }
        }else if Element.self is Complex<Float>.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: Complex<Float>.self) { buffer in
                    return Vector<Complex<Float>>.subtract(buffer, scalar as! Complex<Float>) as! [Element]
                }
            }
        }else if Element.self is Complex<Double>.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: Complex<Double>.self) { buffer in
                    return Vector<Complex<Double>>.subtract(buffer, scalar as! Complex<Double>) as! [Element]
                }
            }
        }else{
            
            return [Element](unsafeUninitializedCapacity: vector.count) { buffer, initializedCount in
                guard var ptr = buffer.baseAddress else{
                    return
                }
                vector.withUnsafeBufferPointer { iBuffer in
                    guard var iPtr = iBuffer.baseAddress else{
                        return
                    }
                    for _ in 0..<vector.count{
                        ptr.initialize(to: iPtr.pointee - scalar)
                        ptr += 1
                        iPtr += 1
                    }
                }
                initializedCount = vector.count
            }
            
        }
    }
    
    
    static func arithmeticProgression(initialValue: Element, increment: Element, count: Int) -> [Element]{
        if Element.self is Float.Type{
            return Vector<Float>.arithmeticProgression(initialValue: initialValue as! Float, increment: increment as! Float, count: count) as! [Element]
        }else if Element.self is Double.Type{
            return Vector<Double>.arithmeticProgression(initialValue: initialValue as! Double, increment: increment as! Double, count: count) as! [Element]
        }else if Element.self is DSPComplex.Type{
            return Vector<DSPComplex>.arithmeticProgression(initialValue: initialValue as! DSPComplex, increment: increment as! DSPComplex, count: count) as! [Element]
        }else if Element.self is DSPDoubleComplex.Type{
            return Vector<DSPDoubleComplex>.arithmeticProgression(initialValue: initialValue as! DSPDoubleComplex, increment: increment as! DSPDoubleComplex, count: count) as! [Element]
        }else if Element.self is Complex<Float>.Type{
            return Vector<Complex<Float>>.arithmeticProgression(initialValue: initialValue as! Complex<Float>, increment: increment as! Complex<Float>, count: count) as! [Element]
        }else if Element.self is Complex<Double>.Type{
            return Vector<Complex<Double>>.arithmeticProgression(initialValue: initialValue as! Complex<Double>, increment: increment as! Complex<Double>, count: count) as! [Element]
        }else{
            
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
}

public extension Vector where Element: Numeric{
    static func multiply<VectorA, VectorB>(_ vectorA: VectorA, _ vectorB: VectorB) -> [Element]
    where VectorA: AccelerateBuffer, VectorB: AccelerateBuffer, VectorA.Element == Element, VectorB.Element == Element{
        if Element.self is Float.Type{
            return vectorA.withUnsafeBufferPointer { bufferA in
                bufferA.withMemoryRebound(to: Float.self) { bufferA in
                    vectorB.withUnsafeBufferPointer { bufferB in
                        bufferB.withMemoryRebound(to: Float.self) { bufferB in
                            return Vector<Float>.multiply(bufferA, bufferB) as! [Element]
                        }
                    }
                }
            }
        }else if Element.self is Double.Type{
            return vectorA.withUnsafeBufferPointer { bufferA in
                bufferA.withMemoryRebound(to: Double.self) { bufferA in
                    vectorB.withUnsafeBufferPointer { bufferB in
                        bufferB.withMemoryRebound(to: Double.self) { bufferB in
                            return Vector<Double>.multiply(bufferA, bufferB) as! [Element]
                        }
                    }
                }
            }
        }else if Element.self is DSPComplex.Type{
            return vectorA.withUnsafeBufferPointer { bufferA in
                bufferA.withMemoryRebound(to: DSPComplex.self) { bufferA in
                    vectorB.withUnsafeBufferPointer { bufferB in
                        bufferB.withMemoryRebound(to: DSPComplex.self) { bufferB in
                            return Vector<DSPComplex>.multiply(bufferA, bufferB) as! [Element]
                        }
                    }
                }
            }
        }else if Element.self is DSPDoubleComplex.Type{
            return vectorA.withUnsafeBufferPointer { bufferA in
                bufferA.withMemoryRebound(to: DSPDoubleComplex.self) { bufferA in
                    vectorB.withUnsafeBufferPointer { bufferB in
                        bufferB.withMemoryRebound(to: DSPDoubleComplex.self) { bufferB in
                            return Vector<DSPDoubleComplex>.multiply(bufferA, bufferB) as! [Element]
                        }
                    }
                }
            }
        }else if Element.self is Complex<Float>.Type{
            return vectorA.withUnsafeBufferPointer { bufferA in
                bufferA.withMemoryRebound(to: Complex<Float>.self) { bufferA in
                    vectorB.withUnsafeBufferPointer { bufferB in
                        bufferB.withMemoryRebound(to: Complex<Float>.self) { bufferB in
                            return Vector<Complex<Float>>.multiply(bufferA, bufferB) as! [Element]
                        }
                    }
                }
            }
        }else if Element.self is Complex<Double>.Type{
            return vectorA.withUnsafeBufferPointer { bufferA in
                bufferA.withMemoryRebound(to: Complex<Double>.self) { bufferA in
                    vectorB.withUnsafeBufferPointer { bufferB in
                        bufferB.withMemoryRebound(to: Complex<Double>.self) { bufferB in
                            return Vector<Complex<Double>>.multiply(bufferA, bufferB) as! [Element]
                        }
                    }
                }
            }
        }else{
            return loop(vectorA, vectorB) { $0 * $1 }
        }
    }
    
    static func multiply<VectorA>(_ vector: VectorA, _ scalar: Element) -> [Element]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        if Element.self is Float.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: Float.self) { buffer in
                    return Vector<Float>.multiply(buffer, scalar as! Float) as! [Element]
                }
            }
        }else if Element.self is Double.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: Double.self) { buffer in
                    return Vector<Double>.multiply(buffer, scalar as! Double) as! [Element]
                }
            }
        }else if Element.self is DSPComplex.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: DSPComplex.self) { buffer in
                    return Vector<DSPComplex>.multiply(buffer, scalar as! DSPComplex) as! [Element]
                }
            }
        }else if Element.self is DSPDoubleComplex.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: DSPDoubleComplex.self) { buffer in
                    return Vector<DSPDoubleComplex>.multiply(buffer, scalar as! DSPDoubleComplex) as! [Element]
                }
            }
        }else if Element.self is Complex<Float>.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: Complex<Float>.self) { buffer in
                    return Vector<Complex<Float>>.multiply(buffer, scalar as! Complex<Float>) as! [Element]
                }
            }
        }else if Element.self is Complex<Double>.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: Complex<Double>.self) { buffer in
                    return Vector<Complex<Double>>.multiply(buffer, scalar as! Complex<Double>) as! [Element]
                }
            }
        }else{
            
            return [Element](unsafeUninitializedCapacity: vector.count) { buffer, initializedCount in
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
    }
    
    static func multiply<VectorB>(_ scalar: Element, _ vector: VectorB) -> [Element]
    where VectorB: AccelerateBuffer, VectorB.Element == Element{
        if Element.self is Float.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: Float.self) { buffer in
                    return Vector<Float>.multiply(scalar as! Float, buffer) as! [Element]
                }
            }
        }else if Element.self is Double.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: Double.self) { buffer in
                    return Vector<Double>.multiply(scalar as! Double, buffer) as! [Element]
                }
            }
        }else if Element.self is DSPComplex.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: DSPComplex.self) { buffer in
                    return Vector<DSPComplex>.multiply(scalar as! DSPComplex, buffer) as! [Element]
                }
            }
        }else if Element.self is DSPDoubleComplex.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: DSPDoubleComplex.self) { buffer in
                    return Vector<DSPDoubleComplex>.multiply(scalar as! DSPDoubleComplex, buffer) as! [Element]
                }
            }
        }else if Element.self is Complex<Float>.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: Complex<Float>.self) { buffer in
                    return Vector<Complex<Float>>.multiply(scalar as! Complex<Float>, buffer) as! [Element]
                }
            }
        }else if Element.self is Complex<Double>.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: Complex<Double>.self) { buffer in
                    return Vector<Complex<Double>>.multiply(scalar as! Complex<Double>, buffer) as! [Element]
                }
            }
        }else{
            
            return [Element](unsafeUninitializedCapacity: vector.count) { buffer, initializedCount in
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
    }
    static func absolute<VectorA>(_ vector: VectorA) -> [Element.Magnitude]
    where VectorA: AccelerateBuffer, VectorA.Element == Element
    {
        if Element.self is Float.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: Float.self) { buffer in
                    Vector<Float>.absolute(buffer) as! [Element.Magnitude]
                }
            }
        }else if Element.self is Double.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: Double.self) { buffer in
                    Vector<Double>.absolute(buffer) as! [Element.Magnitude]
                }
            }
        }else if Element.self is DSPComplex.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: DSPComplex.self) { buffer in
                    Vector<DSPComplex>.absolute(buffer) as! [Element.Magnitude]
                }
            }
        }else if Element.self is DSPDoubleComplex.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: DSPDoubleComplex.self) { buffer in
                    Vector<DSPDoubleComplex>.absolute(buffer) as! [Element.Magnitude]
                }
            }
        }else if Element.self is Complex<Float>.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: Complex<Float>.self) { buffer in
                    Vector<Complex<Float>>.absolute(buffer) as! [Element.Magnitude]
                }
            }
        }else if Element.self is Complex<Double>.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: Complex<Double>.self) { buffer in
                    Vector<Complex<Double>>.absolute(buffer) as! [Element.Magnitude]
                }
            }
        }else{
            return loop(vector) { $0.magnitude }
        }
    }
    static func geometricProgression(initialValue: Element, ratio: Element, count: Int) -> [Element]{
        
        if Element.self is Float.Type{
            return Vector<Float>.geometricProgression(initialValue: initialValue as! Float, ratio: ratio as! Float, count: count) as! [Element]
        }else if Element.self is Double.Type{
            return Vector<Double>.geometricProgression(initialValue: initialValue as! Double, ratio: ratio as! Double, count: count) as! [Element]
        }else if Element.self is DSPComplex.Type{
            return Vector<DSPComplex>.geometricProgression(initialValue: initialValue as! DSPComplex, ratio: ratio as! DSPComplex, count: count) as! [Element]
        }else if Element.self is DSPDoubleComplex.Type{
            return Vector<DSPDoubleComplex>.geometricProgression(initialValue: initialValue as! DSPDoubleComplex, ratio: ratio as! DSPDoubleComplex, count: count) as! [Element]
        }else if Element.self is Complex<Float>.Type{
            return Vector<Complex<Float>>.geometricProgression(initialValue: initialValue as! Complex<Float>, ratio: ratio as! Complex<Float>, count: count) as! [Element]
        }else if Element.self is Complex<Double>.Type{
            return Vector<Complex<Double>>.geometricProgression(initialValue: initialValue as! Complex<Double>, ratio: ratio as! Complex<Double>, count: count) as! [Element]
        }else{
            
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
}

public extension Vector where Element: SignedNumeric{
    static func negative<VectorA>(_ vector: VectorA) -> [Element]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        if Element.self is Float.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: Float.self) { buffer in
                    Vector<Float>.negative(buffer) as! [Element]
                }
            }
        }else if Element.self is Double.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: Double.self) { buffer in
                    Vector<Double>.negative(buffer) as! [Element]
                }
            }
        }else if Element.self is DSPComplex.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: DSPComplex.self) { buffer in
                    Vector<DSPComplex>.negative(buffer) as! [Element]
                }
            }
        }else if Element.self is DSPDoubleComplex.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: DSPDoubleComplex.self) { buffer in
                    Vector<DSPDoubleComplex>.negative(buffer) as! [Element]
                }
            }
        }else if Element.self is Complex<Float>.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: Complex<Float>.self) { buffer in
                    Vector<Complex<Float>>.negative(buffer) as! [Element]
                }
            }
        }else if Element.self is Complex<Double>.Type{
            return vector.withUnsafeBufferPointer { buffer in
                buffer.withMemoryRebound(to: Complex<Double>.self) { buffer in
                    Vector<Complex<Double>>.negative(buffer) as! [Element]
                }
            }
        }else{
            return loop(vector) {-$0}
        }
    }
}

