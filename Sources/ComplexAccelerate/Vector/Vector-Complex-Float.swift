//
//  Vector-Complex-Float.swift
//  
//
//  Created by Albertus Liberius on 2023-01-09.
//

import Foundation
import Accelerate

// MARK: Parallel Arithmetic
public extension Vector where Element == Complex<Float>{
    internal static func parallel<VectorA, VectorB>(
        _ vectorA: VectorA, _ vectorB: VectorB,
        vDSP_zv: (_ A: UnsafePointer<DSPSplitComplex>, _ IA: vDSP_Stride,
                  _ B: UnsafePointer<DSPSplitComplex>, _ IB: vDSP_Stride,
                  _ Out: UnsafePointer<DSPSplitComplex>, _ IOut: vDSP_Stride, _ N: vDSP_Length) -> ()
    ) -> [Complex<Float>]
    where VectorA: AccelerateBuffer, VectorB: AccelerateBuffer, VectorA.Element == Element, VectorB.Element == Element{
        let count = min(vectorA.count, vectorB.count)
        return vectorA.withDSPSplitComplexPointer { splitA in
            return vectorB.withDSPSplitComplexPointer { splitB in
                return [Complex<Float>](unsafeUninitializedCapacity: count) { buffer, initializedCount in
                    buffer.withDSPSplitComplexPointer { splitO in
                        vDSP_zv(splitA, 2, splitB, 2, splitO, 2, vDSP_Length(count))
                    }
                    initializedCount = count
                }
            } ?? []
        } ?? []
    }
    static func add<VectorA, VectorB>(_ vectorA: VectorA, _ vectorB: VectorB) -> [Complex<Float>]
    where VectorA: AccelerateBuffer, VectorB: AccelerateBuffer, VectorA.Element == Element, VectorB.Element == Element{
        parallel(vectorA, vectorB) { A, IA, B, IB, Out, IOut, N in
            Accelerate.vDSP_zvadd(A, IA, B, IB, Out, IOut, N)
        }
    }
    static func subtract<VectorA, VectorB>(_ vectorA: VectorA, _ vectorB: VectorB) -> [Complex<Float>]
    where VectorA: AccelerateBuffer, VectorB: AccelerateBuffer, VectorA.Element == Element, VectorB.Element == Element{
        parallel(vectorA, vectorB) { A, IA, B, IB, Out, IOut, N in
            Accelerate.vDSP_zvsub(A, IA, B, IB, Out, IOut, N)
        }
    }
    static func multiply<VectorA, VectorB>(_ vectorA: VectorA, _ vectorB: VectorB) -> [Complex<Float>]
    where VectorA: AccelerateBuffer, VectorB: AccelerateBuffer, VectorA.Element == Element, VectorB.Element == Element{
        parallel(vectorA, vectorB) { A, IA, B, IB, Out, IOut, N in
            Accelerate.vDSP_zvmul(A, IA, B, IB, Out, IOut, N, 1)
        }
    }
    
    static func multiply<VectorA, VectorB>(conjugate vectorA: VectorA, _ vectorB: VectorB) -> [Complex<Float>]
    where VectorA: AccelerateBuffer, VectorB: AccelerateBuffer, VectorA.Element == Element, VectorB.Element == Element{
        parallel(vectorA, vectorB) { A, IA, B, IB, Out, IOut, N in
            Accelerate.vDSP_zvmul(A, IA, B, IB, Out, IOut, N, -1)
        }
    }
    
    static func multiply<VectorA, VectorB>(_ realVector: VectorA, _ complexVector: VectorB) -> [Complex<Float>]
    where VectorA: AccelerateBuffer, VectorB: AccelerateBuffer, VectorA.Element == Float, VectorB.Element == Complex<Float>{
        let count = min(realVector.count, complexVector.count)
        return realVector.withUnsafeBufferPointer { realBuffer in
            return complexVector.withUnsafeBufferPointer { complexBuffer in
                if let realPtr = realBuffer.baseAddress{
                    if let cmplxPtr = complexBuffer.baseAddress{
                        return cmplxPtr.withMemoryRebound(to: Float.self, capacity: count) { cmplxRawPtr in
                            return [Complex<Float>](unsafeUninitializedCapacity: count) { outBuffer, initializedCount in
                                outBuffer.withMemoryRebound(to: Float.self) { outRawBuffer in
                                    vDSP_vmul(realPtr, 1, cmplxRawPtr, 2, outRawBuffer.baseAddress!, 2, vDSP_Length(count))
                                    vDSP_vmul(realPtr, 1, cmplxRawPtr + 1, 2, outRawBuffer.baseAddress! + 1, 2, vDSP_Length(count))
                                }
                                initializedCount = count
                            }
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
    
    @inline(__always)
    static func multiply<VectorA, VectorB>(_ complexVector: VectorA, _ realVector: VectorB) -> [Complex<Float>]
    where VectorA: AccelerateBuffer, VectorB: AccelerateBuffer, VectorA.Element == Complex<Float>, VectorB.Element == Float{
        multiply(realVector, complexVector)
    }
    
    static func divide<VectorA, VectorB>(_ vectorA: VectorA, _ vectorB: VectorB) -> [Complex<Float>]
    where VectorA: AccelerateBuffer, VectorB: AccelerateBuffer, VectorA.Element == Element, VectorB.Element == Element{
        parallel(vectorA, vectorB) { A, IA, B, IB, Out, IOut, N in
            Accelerate.vDSP_zvdiv(B, IB, A, IA, Out, IOut, N)
        }
    }
}
