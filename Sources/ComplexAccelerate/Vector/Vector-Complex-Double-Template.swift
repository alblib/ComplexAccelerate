//
//  Vector-Complex-Double-Template.swift
//  
//
//  Created by Albertus Liberius on 2023-01-11.
//

import Foundation
import Accelerate

// MARK: Template


extension Vector where Element: GenericComplex, Element.Real == Double{
    
    // MARK: Binary Operations
    
    static func __zvzv_zv<_ZV, __ZV>
    (   _ vA: _ZV, _ vB: __ZV, vAStep: vDSP_Stride = 1, vBStep: vDSP_Stride = 1,
        vDSP_zv: (_ A: UnsafePointer<DSPDoubleSplitComplex>, _ IA: vDSP_Stride,
                  _ B: UnsafePointer<DSPDoubleSplitComplex>, _ IB: vDSP_Stride,
                  _ Out: UnsafePointer<DSPDoubleSplitComplex>, _ IOut: vDSP_Stride, _ N: vDSP_Length) -> ()
    ) -> [Element]
    where _ZV: AccelerateBuffer, __ZV: AccelerateBuffer, _ZV.Element == Element, __ZV.Element == Element
    {
        let count = min(vA.count, vB.count)
        return [Element](unsafeUninitializedCapacity: count) { buffer, initializedCount in
            vA.withDSPDoubleSplitComplexPointer { splitA in
                vB.withDSPDoubleSplitComplexPointer { splitB in
                    buffer.withDSPDoubleSplitComplexPointer { splitO in
                        vDSP_zv(splitA, 2 * vAStep, splitB, 2 * vBStep, splitO, 2, vDSP_Length(count))
                    }
                }
            }
            initializedCount = count
        }
    }
    
    static func __zvrv_zv<_ZV, _RV>
    (   _ vA: _ZV, _ vB: _RV,
        vDSP_zrv: (_ A: UnsafePointer<DSPDoubleSplitComplex>, _ IA: vDSP_Stride,
                   _ B: UnsafePointer<Double>, _ IB: vDSP_Stride,
                   _ Out: UnsafePointer<DSPDoubleSplitComplex>, _ IOut: vDSP_Stride, _ N: vDSP_Length) -> ()
    ) -> [Element]
    where _ZV: AccelerateBuffer, _RV: AccelerateBuffer, _ZV.Element == Element, _RV.Element == Element.Real
    {
        let count = min(vA.count, vB.count)
        return [Element](unsafeUninitializedCapacity: count) { buffer, initializedCount in
            vA.withDSPDoubleSplitComplexPointer { splitA in
                vB.withRealPointer { ptrB in
                    buffer.withDSPDoubleSplitComplexPointer { splitO in
                        vDSP_zrv(splitA, 2, ptrB, 1, splitO, 2, vDSP_Length(count))
                    }
                }
            }
            initializedCount = count
        }
    }
    
    static func __zvzv_zs<_ZV, __ZV>
    (   _ vA: _ZV, _ vB: __ZV,
        vDSP_z: (_ A: UnsafePointer<DSPDoubleSplitComplex>, _ IA: vDSP_Stride,
                 _ B: UnsafePointer<DSPDoubleSplitComplex>, _ IB: vDSP_Stride,
                 _ Out: UnsafePointer<DSPDoubleSplitComplex>, _ N: vDSP_Length) -> ()
    ) -> Element
    where _ZV: AccelerateBuffer, __ZV: AccelerateBuffer, _ZV.Element == Element, __ZV.Element == Element
    {
        let count = min(vA.count, vB.count)
        let result = [Element](unsafeUninitializedCapacity: 1) { buffer, initializedCount in
            vA.withDSPDoubleSplitComplexPointer { splitA in
                vB.withDSPDoubleSplitComplexPointer { splitB in
                    buffer.withDSPDoubleSplitComplexPointer { splitO in
                        vDSP_z(splitA, 2, splitB, 2, splitO, vDSP_Length(count))
                    }
                }
            }
            initializedCount = 1
        }
        return result[0]
    }
    
    // MARK: Unary Operations
    
    static func __zv_zv<_ZV>
    (   _ vA: _ZV,
        vDSP_zv: (_ A: UnsafePointer<DSPDoubleSplitComplex>, _ IA: vDSP_Stride,
                  _ Out: UnsafePointer<DSPDoubleSplitComplex>, _ IOut: vDSP_Stride, _ N: vDSP_Length) -> ()
    ) -> [Element]
    where _ZV: AccelerateBuffer, _ZV.Element == Element
    {
        let count = vA.count
        return [Element](unsafeUninitializedCapacity: count) { buffer, initializedCount in
            vA.withDSPDoubleSplitComplexPointer { splitA in
                buffer.withDSPDoubleSplitComplexPointer { splitO in
                    vDSP_zv(splitA, 2, splitO, 2, vDSP_Length(count))
                }
            }
            initializedCount = count
        }
    }
    
    static func __zv_rv<_ZV>
    (   _ vA: _ZV,
        vDSP_zv: (_ A: UnsafePointer<DSPDoubleSplitComplex>, _ IA: vDSP_Stride,
                  _ Out: UnsafeMutablePointer<Double>, _ IOut: vDSP_Stride, _ N: vDSP_Length) -> ()
    ) -> [Element.Real]
    where _ZV: AccelerateBuffer, _ZV.Element == Element
    {
        let count = vA.count
        return [Element.Real](unsafeUninitializedCapacity: count) { buffer, initializedCount in
            vA.withDSPDoubleSplitComplexPointer { splitA in
                buffer.withRealMutablePointer { ptrO in
                    vDSP_zv(splitA, 2, ptrO, 1, vDSP_Length(count))
                }
            }
            initializedCount = count
        }
    }
    
    // MARK: merge and split
    
    /// Splits an array of complex numbers into the array of the real components and the array of the imaginary components.
    ///
    /// - Note: This function is a wrapper of `vDSP_ctozD` function in `Accelerate` framework.
    /// - Parameter vA: The array of complex numbers in form of structure `DSPDoubleComplex`.
    /// - Returns: The pair `(reals: [Double], imaginaries: [Double])` of the array of real parts and the array of imaginary parts, which can be dereferenced by calling the member `.reals` and `.imaginaries`.
    /// - Remark: No exception guaranteed.
    static func _split<_ZV>(_ vA: _ZV) -> (reals: [Element.Real], imaginaries: [Element.Real])
    where _ZV: AccelerateBuffer, _ZV.Element == Element
    {
        let count = vA.count
        var real: [Element.Real] = []
        var imag: [Element.Real] = []
        real = [Element.Real](unsafeUninitializedCapacity: count, initializingWith: { realBuffer, realInitializedCount in
            imag = [Element.Real](unsafeUninitializedCapacity: count, initializingWith: { imagBuffer, imagInitializedCount in
                var splitComplex = DSPDoubleSplitComplex(realp: realBuffer.baseAddress!, imagp: imagBuffer.baseAddress!)
                vA.withUnsafeBufferPointer { inputBuffer in
                    inputBuffer.withMemoryRebound(to: DSPDoubleComplex.self) { DSPBuffer in
                        vDSP_ctozD(DSPBuffer.baseAddress!, 2, &splitComplex, 1, vDSP_Length(count)) // to move 1 in DSPComplex, input vDSP_Stride = 2
                    }
                }
                imagInitializedCount = count
            })
            realInitializedCount = count
        })
        return (reals: real, imaginaries: imag)
    }
    
    /// Combine an array of real parts and an array of imaginary parts to make the array of complex numbers.
    /// - Parameters:
    ///     - reals: The real parts of the complex numbers in order.
    ///     - imaginaries: The imaginary parts of the complex numbers in order.
    /// - Returns: The array of `DSPDoubleComplex` combining the array of the real parts and the array of the imaginary parts.
    /// - Note: This function is a wrapper of `vDSP_ztocD` function in `Accelerate` framework.
    /// - Remark: No exception guaranteed. The output array size is confined to the smaller one from the two inputs.
    static func _merge(reals: [Element.Real], imaginaries: [Element.Real]) -> [Element]{
        let count = min(reals.count, imaginaries.count)
        return [Element](unsafeUninitializedCapacity: count) { buffer, initializedCount in
            reals.withUnsafeBufferPointer { realBuffer in
                imaginaries.withUnsafeBufferPointer { imagBuffer in
                    var splitComplex = DSPDoubleSplitComplex(realp: UnsafeMutablePointer<Element.Real>(mutating: realBuffer.baseAddress!), imagp: UnsafeMutablePointer<Element.Real>(mutating: imagBuffer.baseAddress!))
                    buffer.withMemoryRebound(to: DSPDoubleComplex.self) { OBuffer in
                        vDSP_ztocD(&splitComplex, 1, OBuffer.baseAddress!, 2, vDSP_Length(count))
                    }
                }
            }
            initializedCount = count
        }
    }
    
}

// MARK: - Arithmetics
    
extension Vector where Element: GenericComplex, Element.Real == Double{
    
    
    // MARK: Signs zv -> rv or zv
    
    static func _abs<_ZV>(_ vA: _ZV) -> [Element.Real]
    where _ZV: AccelerateBuffer, _ZV.Element == Element
    {
        __zv_rv(vA) { A, IA, Out, IOut, N in
            vDSP_zvabsD(A, IA, Out, IOut, N)
        }
    }
    static func _neg<_ZV>(_ vA: _ZV) -> [Element]
    where _ZV: AccelerateBuffer, _ZV.Element == Element
    {
        __zv_zv(vA) { A, IA, Out, IOut, N in
            vDSP_zvnegD(A, IA, Out, IOut, N)
        }
    }
    static func _arg<_ZV>(_ vA: _ZV) -> [Element.Real]
    where _ZV: AccelerateBuffer, _ZV.Element == Element
    {
        __zv_rv(vA) { A, IA, Out, IOut, N in
            vDSP_zvphasD(A, IA, Out, IOut, N)
        }
    }
    
    // MARK: Parallel Binary Arithmetic zv + zv -> zv
    
    
    static func _add<_ZV, __ZV>(_ vA: _ZV, _ vB: __ZV) -> [Element]
    where _ZV: AccelerateBuffer, __ZV: AccelerateBuffer, _ZV.Element == Element, __ZV.Element == Element
    {
        __zvzv_zv(vA, vB) { A, IA, B, IB, Out, IOut, N in
            vDSP_zvaddD(A, IA, B, IB, Out, IOut, N)
        }
    }
    
    static func _sub<_ZV, __ZV>(_ vA: _ZV, _ vB: __ZV) -> [Element]
    where _ZV: AccelerateBuffer, __ZV: AccelerateBuffer, _ZV.Element == Element, __ZV.Element == Element
    {
        __zvzv_zv(vA, vB) { A, IA, B, IB, Out, IOut, N in
            vDSP_zvsubD(A, IA, B, IB, Out, IOut, N)
        }
    }
    
    static func _mul<_ZV, __ZV>(_ vA: _ZV, _ vB: __ZV) -> [Element]
    where _ZV: AccelerateBuffer, __ZV: AccelerateBuffer, _ZV.Element == Element, __ZV.Element == Element
    {
        __zvzv_zv(vA, vB) { A, IA, B, IB, Out, IOut, N in
            vDSP_zvmulD(A, IA, B, IB, Out, IOut, N, 1)
        }
    }
    
    static func _mul<_ZV, __ZV>(conj vA: _ZV, _ vB: __ZV) -> [Element]
    where _ZV: AccelerateBuffer, __ZV: AccelerateBuffer, _ZV.Element == Element, __ZV.Element == Element
    {
        __zvzv_zv(vA, vB) { A, IA, B, IB, Out, IOut, N in
            vDSP_zvmulD(A, IA, B, IB, Out, IOut, N, -1)
        }
    }
    static func _div<_ZV, __ZV>(_ vA: _ZV, _ vB: __ZV) -> [Element]
    where _ZV: AccelerateBuffer, __ZV: AccelerateBuffer, _ZV.Element == Element, __ZV.Element == Element
    {
        __zvzv_zv(vA, vB) { A, IA, B, IB, Out, IOut, N in
            vDSP_zvdivD(B, IB, A, IA, Out, IOut, N)
        }
    }
    
    
    // MARK: Parallel Binary Arithmetic zv + rv -> zv
    static func _add<_ZV, _RV>(_ vA: _ZV, _ vB: _RV) -> [Element]
    where _ZV: AccelerateBuffer, _RV: AccelerateBuffer, _ZV.Element == Element, _RV.Element == Element.Real
    {
        __zvrv_zv(vA, vB) { A, IA, B, IB, Out, IOut, N in
            vDSP_zrvaddD(A, IA, B, IB, Out, IOut, N)
        }
    }
    static func _sub<_ZV, _RV>(_ vA: _ZV, _ vB: _RV) -> [Element]
    where _ZV: AccelerateBuffer, _RV: AccelerateBuffer, _ZV.Element == Element, _RV.Element == Element.Real
    {
        __zvrv_zv(vA, vB) { A, IA, B, IB, Out, IOut, N in
            vDSP_zrvsubD(A, IA, B, IB, Out, IOut, N)
        }
    }
    static func _mul<_ZV, _RV>(_ vA: _ZV, _ vB: _RV) -> [Element]
    where _ZV: AccelerateBuffer, _RV: AccelerateBuffer, _ZV.Element == Element, _RV.Element == Element.Real
    {
        __zvrv_zv(vA, vB) { A, IA, B, IB, Out, IOut, N in
            vDSP_zrvmulD(A, IA, B, IB, Out, IOut, N)
        }
    }
    static func _div<_ZV, _RV>(_ vA: _ZV, _ vB: _RV) -> [Element]
    where _ZV: AccelerateBuffer, _RV: AccelerateBuffer, _ZV.Element == Element, _RV.Element == Element.Real
    {
        __zvrv_zv(vA, vB) { A, IA, B, IB, Out, IOut, N in
            vDSP_zrvdivD(A, IA, B, IB, Out, IOut, N)
        }
    }
    
    // MARK: Binary Arithmetic zv + z -> zv
    
    static func _add<_ZV>(_ vA: _ZV, scalar: Element) -> [Element]
    where _ZV: AccelerateBuffer, _ZV.Element == Element
    {
        withUnsafePointer(to: scalar) { sPtr in
            let sB = UnsafeBufferPointer(start: sPtr, count: 1)
            return __zvzv_zv(vA, sB, vBStep: 0) { A, IA, B, IB, Out, IOut, N in
                vDSP_zvaddD(A, IA, B, IB, Out, IOut, N)
            }
        }
    }
    
    static func _sub<_ZV>(_ vA: _ZV, scalar: Element) -> [Element]
    where _ZV: AccelerateBuffer, _ZV.Element == Element
    {
        withUnsafePointer(to: scalar) { sPtr in
            let sB = UnsafeBufferPointer(start: sPtr, count: 1)
            return __zvzv_zv(vA, sB, vBStep: 0) { A, IA, B, IB, Out, IOut, N in
                vDSP_zvsubD(A, IA, B, IB, Out, IOut, N)
            }
        }
    }
    static func _sub<_ZV>(scalar: Element, _ vB: _ZV) -> [Element]
    where _ZV: AccelerateBuffer, _ZV.Element == Element
    {
        withUnsafePointer(to: scalar) { sPtr in
            let sA = UnsafeBufferPointer(start: sPtr, count: 1)
            return __zvzv_zv(sA, vB, vAStep: 0) { A, IA, B, IB, Out, IOut, N in
                vDSP_zvsubD(A, IA, B, IB, Out, IOut, N)
            }
        }
    }
    
    static func _mul<_ZV>(_ vA: _ZV, scalar: Element) -> [Element]
    where _ZV: AccelerateBuffer, _ZV.Element == Element
    {
        withUnsafePointer(to: scalar) { sPtr in
            let sB = UnsafeBufferPointer(start: sPtr, count: 1)
            return __zvzv_zv(vA, sB, vBStep: 0) { A, IA, B, IB, Out, IOut, N in
                vDSP_zvmulD(A, IA, B, IB, Out, IOut, N, 1)
            }
        }
    }
    
    static func _mul<_ZV>(conj vA: _ZV, scalar: Element) -> [Element]
    where _ZV: AccelerateBuffer, _ZV.Element == Element
    {
        withUnsafePointer(to: scalar) { sPtr in
            let sB = UnsafeBufferPointer(start: sPtr, count: 1)
            return __zvzv_zv(vA, sB, vBStep: 0) { A, IA, B, IB, Out, IOut, N in
                vDSP_zvmulD(A, IA, B, IB, Out, IOut, N, -1)
            }
        }
    }
    
    static func _div<_ZV>(_ vA: _ZV, scalar: Element) -> [Element]
    where _ZV: AccelerateBuffer, _ZV.Element == Element
    {
        withUnsafePointer(to: scalar) { sPtr in
            let sB = UnsafeBufferPointer(start: sPtr, count: 1)
            return __zvzv_zv(vA, sB, vBStep: 0) { A, IA, B, IB, Out, IOut, N in
                vDSP_zvdivD(B, IB, A, IA, Out, IOut, N)
            }
        }
    }
    
    static func _div<_ZV>(scalar: Element, _ vB: _ZV) -> [Element]
    where _ZV: AccelerateBuffer, _ZV.Element == Element
    {
        withUnsafePointer(to: scalar) { sPtr in
            let sA = UnsafeBufferPointer(start: sPtr, count: 1)
            return __zvzv_zv(sA, vB, vAStep: 0) { A, IA, B, IB, Out, IOut, N in
                vDSP_zvdivD(B, IB, A, IA, Out, IOut, N)
            }
        }
    }
    
    // MARK: Binary Arithmetic zv + r -> zv
    
    static func _mul<_ZV>(_ vA: _ZV, scalar: Element.Real) -> [Element]
    where _ZV: AccelerateBuffer, _ZV.Element == Element
    {
        let count = vA.count
        if count == 0{
            return []
        }
        let doubleCount = 2 * count
        return [Element](unsafeUninitializedCapacity: vA.count) { buffer, initializedCount in
            vA.withUnsafeBufferPointer { numeratorComplexBuffer in
                numeratorComplexBuffer.baseAddress!.withMemoryRebound(to: Element.Real.self, capacity: doubleCount) { numeratorFloatPtr in
                    buffer.baseAddress!.withMemoryRebound(to: Element.Real.self, capacity: doubleCount) { outputFloatPtr in
                        withUnsafePointer(to: scalar) { denominatorPtr in
                            vDSP_vsmulD(numeratorFloatPtr, 1, denominatorPtr, outputFloatPtr, 1, vDSP_Length(doubleCount))
                        }
                    }
                }
            }
            initializedCount = vA.count
        }
    }
    
    static func _div<_ZV>(_ vA: _ZV, scalar: Element.Real) -> [Element]
    where _ZV: AccelerateBuffer, _ZV.Element == Element
    {
        let count = vA.count
        if count == 0{
            return []
        }
        let doubleCount = 2 * count
        return [Element](unsafeUninitializedCapacity: vA.count) { buffer, initializedCount in
            vA.withUnsafeBufferPointer { numeratorComplexBuffer in
                numeratorComplexBuffer.baseAddress!.withMemoryRebound(to: Element.Real.self, capacity: doubleCount) { numeratorFloatPtr in
                    buffer.baseAddress!.withMemoryRebound(to: Element.Real.self, capacity: doubleCount) { outputFloatPtr in
                        withUnsafePointer(to: scalar) { denominatorPtr in
                            vDSP_vsdivD(numeratorFloatPtr, 1, denominatorPtr, outputFloatPtr, 1, vDSP_Length(doubleCount))
                        }
                    }
                }
            }
            initializedCount = vA.count
        }
    }
    // MARK: Times I
    
    static func _timesI<_ZV>(_ vA: _ZV) -> [Element]
    where _ZV: AccelerateBuffer, _ZV.Element == Element
    {
        let splited = _split(vA)
        return _merge(reals: vDSP.negative(splited.imaginaries), imaginaries: splited.reals)
    }
    static func _timesNegI<_ZV>(_ vA: _ZV) -> [Element]
    where _ZV: AccelerateBuffer, _ZV.Element == Element
    {
        let splited = _split(vA)
        return _merge(reals: splited.imaginaries, imaginaries: vDSP.negative(splited.reals))
    }
}

// MARK: - Vector Reduction

extension Vector where Element: GenericComplex, Element.Real == Double{
    
    // MARK: Array Summation
    static func _sum<_ZV>(_ vA: _ZV) -> Element
    where _ZV: AccelerateBuffer, _ZV.Element == Element
    {
        let length = vDSP_Length(vA.count)
        let result = [Element](unsafeUninitializedCapacity: 1) { buffer, initializedCount in
            buffer.withMemoryRebound(to: Element.Real.self) { resultFloatBuffer in
                vA.withDSPDoubleSplitComplex { splitComplex in
                    vDSP_sveD(splitComplex.realp, 2, resultFloatBuffer.baseAddress!, length)
                    vDSP_sveD(splitComplex.imagp, 2, resultFloatBuffer.baseAddress! + 1, length)
                } ?? {
                    let resultProperlySizedBuffer = UnsafeMutableBufferPointer(start: resultFloatBuffer.baseAddress!, count: 2)
                    resultProperlySizedBuffer.initialize(repeating: 0)
                }()
            }
            initializedCount = 1
        }
        return result.first!
    }
    static func _sum_sqMag<_ZV>(_ vA: _ZV) -> Element.Real
    where _ZV: AccelerateBuffer, _ZV.Element == Element
    {
        vA.withUnsafeBufferPointer { complexBuffer in
            complexBuffer.withMemoryRebound(to: Element.Real.self) { doubleBuffer in
                if let ptr = doubleBuffer.baseAddress{
                    var result: Element.Real = 0
                    vDSP_svesqD(ptr, 1, &result, vDSP_Length(2 * vA.count))
                    return result
                }else{
                    return 0
                }
            }
        }
    }
    
    static func _mean<_ZV>(_ vA: _ZV) -> Element
    where _ZV: AccelerateBuffer, _ZV.Element == Element{
        let len = vDSP_Length(vA.count)
        let result = [Element](unsafeUninitializedCapacity: 1) { buffer, initializedCount in
            buffer.withMemoryRebound(to: Element.Real.self) { doubleBuffer in
                vA.withDSPDoubleSplitComplex { splitComplex in
                    vDSP_meanvD(splitComplex.realp, 2, doubleBuffer.baseAddress!, len)
                    vDSP_meanvD(splitComplex.imagp, 2, doubleBuffer.baseAddress! + 1, len)
                }
            }
            initializedCount = 1
        }
        return result.first!
    }
    
    static func _mean_sqMag<_ZV>(_ vA: _ZV) -> Element.Real
    where _ZV: AccelerateBuffer, _ZV.Element == Element{
        var result: Element.Real = .zero
        vA.withDSPDoubleSplitComplex { splitComplex in
            vDSP_measqvD(splitComplex.realp, 1, &result, vDSP_Length(2 * vA.count))
        }
        return 2 * result
    }
    static func _rmsMag<_ZV>(_ vA: _ZV) -> Element.Real
    where _ZV: AccelerateBuffer, _ZV.Element == Element{
        var result: Element.Real = .zero
        vA.withDSPDoubleSplitComplex { splitComplex in
            vDSP_rmsqvD(splitComplex.realp, 1, &result, vDSP_Length(2 * vA.count))
        }
        return sqrt(Element.Real(2)) * result
    }
    
    // MARK: Dot Product
    
    static func _dot<_ZV, __ZV>(_ vA: _ZV, _ vB: __ZV) -> Element
    where _ZV: AccelerateBuffer, __ZV: AccelerateBuffer, _ZV.Element == Element, __ZV.Element == Element
    {
        let count = min(vA.count, vB.count)
        var result = Element(real: .zero, imag: .zero)
        vA.withDSPDoubleSplitComplexPointer { ptrA in
            vB.withDSPDoubleSplitComplexPointer { ptrB in
                result.withDSPDoubleSplitComplexMutablePointer { ptrResult in
                    vDSP_zdotprD(ptrA, 2, ptrB, 2, ptrResult, vDSP_Length(count))
                }
            }
        }
        return result
    }
    
    static func _dot<_ZV, __ZV>(conj vA: _ZV, _ vB: __ZV) -> Element
    where _ZV: AccelerateBuffer, __ZV: AccelerateBuffer, _ZV.Element == Element, __ZV.Element == Element
    {
        let count = min(vA.count, vB.count)
        var result = Element(real: .zero, imag: .zero)
        vA.withDSPDoubleSplitComplexPointer { ptrA in
            vB.withDSPDoubleSplitComplexPointer { ptrB in
                result.withDSPDoubleSplitComplexMutablePointer { ptrResult in
                    vDSP_zidotprD(ptrA, 2, ptrB, 2, ptrResult, vDSP_Length(count))
                }
            }
        }
        return result
    }
    
    static func _dot<_ZV, _RV>(_ vA: _ZV, _ vB: _RV) -> Element
    where _ZV: AccelerateBuffer, _RV: AccelerateBuffer, _ZV.Element == Element, _RV.Element == Element.Real
    {
        let count = min(vA.count, vB.count)
        var result = Element(real: .zero, imag: .zero)
        vA.withDSPDoubleSplitComplexPointer { ptrA in
            vB.withRealPointer { ptrB in
                result.withDSPDoubleSplitComplexMutablePointer { ptrResult in
                    vDSP_zrdotprD(ptrA, 2, ptrB, 1, ptrResult, vDSP_Length(count))
                }
            }
        }
        return result
    }
    
}

// MARK: - Complex Analysis

extension Vector where Element: GenericComplex, Element.Real == Double{
    
    // MARK: Logs and Exps

    static func _log<_ZV>(_ vA: _ZV) -> [Element]
    where _ZV: AccelerateBuffer, _ZV.Element == Element
    {
        _merge(reals: vForce.log(_abs(vA)), imaginaries: _arg(vA))
    }
    
    static func _exp<_ZV>(_ vA: _ZV) -> [Element]
    where _ZV: AccelerateBuffer, _ZV.Element == Element
    {
        let splited = _split(vA)
        let count = vA.count
        var count32 = Int32(count)
        var cos: [Element.Real] = []
        var sin: [Element.Real] = []
        cos = [Element.Real](unsafeUninitializedCapacity: vA.count) { cosBuffer, initializedCount in
            sin = [Element.Real](unsafeUninitializedCapacity: vA.count) { sinBuffer, initializedCount in
                vvsincos(sinBuffer.baseAddress!, cosBuffer.baseAddress!, splited.imaginaries, &count32)
                initializedCount = count
            }
            initializedCount = count
        }
        let mag = vForce.exp(splited.reals)
        let resultReals = vDSP.multiply(mag, cos)
        let resultImags = vDSP.multiply(mag, sin)
        return _merge(reals: resultReals, imaginaries: resultImags)
    }
    
    static func _expi<_ZV>(_ vA: _ZV) -> [Element]
    where _ZV: AccelerateBuffer, _ZV.Element == Element
    {
        let splited = _split(vA)
        let count = vA.count
        var count32 = Int32(count)
        var cos: [Element.Real] = []
        var sin: [Element.Real] = []
        cos = [Element.Real](unsafeUninitializedCapacity: vA.count) { cosBuffer, initializedCount in
            sin = [Element.Real](unsafeUninitializedCapacity: vA.count) { sinBuffer, initializedCount in
                vvsincos(sinBuffer.baseAddress!, cosBuffer.baseAddress!, splited.imaginaries, &count32)
                initializedCount = count
            }
            initializedCount = count
        }
        let mag = vForce.exp(splited.reals)
        let resultReals = vDSP.multiply(mag, vDSP.negative(sin))
        let resultImags = vDSP.multiply(mag, cos)
        return _merge(reals: resultReals, imaginaries: resultImags)
    }
    
    static func _expi<_RV>(_ vA: _RV) -> [Element]
    where _RV: AccelerateBuffer, _RV.Element == Element.Real
    {
        let count = vA.count
        var count32 = Int32(count)
        var cos: [Element.Real] = []
        var sin: [Element.Real] = []
        cos = [Element.Real](unsafeUninitializedCapacity: vA.count) { cosBuffer, initializedCount in
            sin = [Element.Real](unsafeUninitializedCapacity: vA.count) { sinBuffer, initializedCount in
                vA.withRealPointer { pointer in
                    vvsincos(sinBuffer.baseAddress!, cosBuffer.baseAddress!, pointer, &count32)
                }
                initializedCount = count
            }
            initializedCount = count
        }
        return _merge(reals: cos, imaginaries: sin)
    }
    
    // MARK: Powers
    
    static func _pow<_ZV, __ZV>(bases: _ZV, exponents: __ZV) -> [Element]
    where _ZV: AccelerateBuffer, __ZV: AccelerateBuffer, _ZV.Element == Element, __ZV.Element == Element
    {
        _exp(_mul(_log(bases), exponents))
    }
    
    static func _pow<_ZV, _RV>(bases: _ZV, exponents: _RV) -> [Element]
    where _ZV: AccelerateBuffer, _RV: AccelerateBuffer, _ZV.Element == Element, _RV.Element == Element.Real
    {
        _exp(_mul(_log(bases), exponents))
    }
    
    static func _pow<_RV, _ZV>(bases: _RV, exponents: _ZV) -> [Element]
    where _ZV: AccelerateBuffer, _RV: AccelerateBuffer, _ZV.Element == Element, _RV.Element == Element.Real
    {
        _exp(_mul(exponents, vForce.log(bases)))
    }
    
    static func _pow<_ZV>(bases: _ZV, exponent: Element) -> [Element]
    where _ZV: AccelerateBuffer, _ZV.Element == Element
    {
        _exp(_mul(_log(bases), scalar: exponent))
    }
    
    static func _pow<_ZV>(bases: _ZV, exponent: Element.Real) -> [Element]
    where _ZV: AccelerateBuffer, _ZV.Element == Element
    {
        _exp(_mul(_log(bases), scalar: exponent))
    }
    
    static func _pow<_ZV>(base: Element, exponents: _ZV) -> [Element]
    where _ZV: AccelerateBuffer, _ZV.Element == Element
    {
        let logBase = Element(real: Foundation.log(base.real * base.real + base.imag * base.imag) / 2, imag: atan2(base.imag, base.real))
        return _exp(_mul(exponents, scalar: logBase))
    }
    
    static func _sqrt<_ZV>(_ vA: _ZV) -> [Element]
    where _ZV: AccelerateBuffer, _ZV.Element == Element
    {
        _pow(bases: vA, exponent: 0.5)
    }
    
    // MARK: Hyperbolic Functions
    
    static func _cosh<_ZV>(_ vA: _ZV) -> [Element]
    where _ZV: AccelerateBuffer, _ZV.Element == Element
    {
        _div(_add(_exp(vA), _exp(_neg(vA))), scalar: 2)
    }
    static func _sinh<_ZV>(_ vA: _ZV) -> [Element]
    where _ZV: AccelerateBuffer, _ZV.Element == Element
    {
        _div(_sub(_exp(vA), _exp(_neg(vA))), scalar: 2)
    }
    
    static func _tanh<_ZV>(_ vA: _ZV) -> [Element]
    where _ZV: AccelerateBuffer, _ZV.Element == Element
    {
        _div(_sinh(vA), _cosh(vA))
    }
    
    //cosh⁻¹(𝑧) := Ln (𝑧 + √(𝑧² - 1))
    static func _acosh<_ZV>(_ vA: _ZV) -> [Element]
    where _ZV: AccelerateBuffer, _ZV.Element == Element
    {
        _log(_add(vA, _sqrt(_sub(_mul(vA, vA), scalar: Element(real: 1, imag: 0)))))
    }
    //sinh⁻¹(𝑧) := Ln (𝑧 + √(𝑧² + 1))
    static func _asinh<_ZV>(_ vA: _ZV) -> [Element]
    where _ZV: AccelerateBuffer, _ZV.Element == Element
    {
        _log(_add(vA, _sqrt(_add(_mul(vA, vA), scalar: Element(real: 1, imag: 0)))))
    }
    //tanh⁻¹(𝑧) := Ln (√((1 + 𝑧) / (1 - 𝑧)))
    static func _atanh<_ZV>(_ vA: _ZV) -> [Element]
    where _ZV: AccelerateBuffer, _ZV.Element == Element
    {
        _div(_sub(_log(_add(vA, scalar: Element(real: 1, imag: 0))), _log(_sub(scalar: Element(real: 1, imag: 0), vA))), scalar: 2)
    }
    
    // MARK: Trigonometric Functions
    static func _cos<_ZV>(_ vA: _ZV) -> [Element]
    where _ZV: AccelerateBuffer, _ZV.Element == Element
    {
        _div(_add(_expi(vA), _expi(_neg(vA))), scalar: 2)
    }
    static func _sin<_ZV>(_ vA: _ZV) -> [Element]
    where _ZV: AccelerateBuffer, _ZV.Element == Element
    {
        _div(_sub(_expi(vA), _expi(_neg(vA))), scalar: Element(real: 0, imag: 2))
    }
    
    static func _tan<_ZV>(_ vA: _ZV) -> [Element]
    where _ZV: AccelerateBuffer, _ZV.Element == Element
    {
        _div(_sin(vA), _cos(vA))
    }
    static func _acos<_ZV>(_ vA: _ZV) -> [Element]
    where _ZV: AccelerateBuffer, _ZV.Element == Element
    {
        let oneMinusZ2: [Element] = _sub(scalar: Element(real: 1, imag: 0), _mul(vA, vA))
        let iZPlusSqrtOneMinusZ2: [Element] = _add(_timesI(vA), _sqrt(oneMinusZ2))
        let beforeAddingPiOverTwo: [Element] = _timesI(_log(iZPlusSqrtOneMinusZ2))
        return _add(beforeAddingPiOverTwo, scalar: Element(real: Double.pi / 2, imag: 0))
    }
    static func _asin<_ZV>(_ vA: _ZV) -> [Element]
    where _ZV: AccelerateBuffer, _ZV.Element == Element
    {
        _timesNegI(_asinh(_timesI(vA)))
    }
    static func _atan<_ZV>(_ vA: _ZV) -> [Element]
    where _ZV: AccelerateBuffer, _ZV.Element == Element
    {
        _timesNegI(_atanh(_timesI(vA)))
    }
}
