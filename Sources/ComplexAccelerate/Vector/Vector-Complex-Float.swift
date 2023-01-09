//
//  Vector-Complex-Float.swift
//  
//
//  Created by Albertus Liberius on 2023-01-09.
//

import Foundation
import Accelerate

public extension Vector where Element == Complex<Float>{
    
    internal static func parallelComplexUnary<VectorA>(
        _ vector: VectorA,
        vDSP_zv: (_ A: UnsafePointer<DSPSplitComplex>, _ IA: vDSP_Stride,
                  _ Out: UnsafePointer<DSPSplitComplex>, _ IOut: vDSP_Stride, _ N: vDSP_Length) -> ()
    ) -> [Complex<Float>]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        let count = vector.count
        return vector.withDSPSplitComplexPointer { splitA in
            return [Complex<Float>](unsafeUninitializedCapacity: count) { buffer, initializedCount in
                buffer.withDSPSplitComplexPointer { splitO in
                    vDSP_zv(splitA, 2, splitO, 2, vDSP_Length(count))
                }
                initializedCount = count
            }
        } ?? []
    }
    
    internal static func parallelComplexUnaryRealOut<VectorA>(
        _ vector: VectorA,
        vDSP_zv: (_ A: UnsafePointer<DSPSplitComplex>, _ IA: vDSP_Stride,
                  _ Out: UnsafeMutablePointer<Float>, _ IOut: vDSP_Stride, _ N: vDSP_Length) -> ()
    ) -> [Float]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        let count = vector.count
        return vector.withDSPSplitComplexPointer { splitA in
            return [Float](unsafeUninitializedCapacity: count) { buffer, initializedCount in
                buffer.withRealMutablePointer { splitO in
                    vDSP_zv(splitA, 2, splitO, 1, vDSP_Length(count))
                }
                initializedCount = count
            }
        } ?? []
    }
    
    internal static func parallelComplexBinary<VectorA, VectorB>(
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
    
    internal static func parallelComplexBinary<ComplexVector, RealVector>(
        _ vectorA: ComplexVector, _ vectorB: RealVector,
        vDSP_zrv: (_ A: UnsafePointer<DSPSplitComplex>, _ IA: vDSP_Stride,
                   _ B: UnsafePointer<Float>, _ IB: vDSP_Stride,
                   _ Out: UnsafePointer<DSPSplitComplex>, _ IOut: vDSP_Stride, _ N: vDSP_Length) -> ()
    ) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == Element, RealVector.Element == Element.Real{
        let count = min(vectorA.count, vectorB.count)
        return vectorA.withDSPSplitComplexPointer { splitA in
            return vectorB.withRealPointer { ptrB in
                return [Element](unsafeUninitializedCapacity: count) { buffer, initializedCount in
                    buffer.withDSPSplitComplexPointer { splitO in
                        vDSP_zrv(splitA, 2, ptrB, 1, splitO, 2, vDSP_Length(count))
                    }
                    initializedCount = count
                }
            } ?? []
        } ?? []
    }
    
    
    // MARK: Parallel Arithmetic
    
    static func add<VectorA, VectorB>(_ vectorA: VectorA, _ vectorB: VectorB) -> [Complex<Float>]
    where VectorA: AccelerateBuffer, VectorB: AccelerateBuffer, VectorA.Element == Element, VectorB.Element == Element{
        parallelComplexBinary(vectorA, vectorB) { A, IA, B, IB, Out, IOut, N in
            Accelerate.vDSP_zvadd(A, IA, B, IB, Out, IOut, N)
        }
    }
    
    static func add<ComplexVector, RealVector>(_ complexVector: ComplexVector, _ realVector: RealVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>, RealVector.Element == Float{
        parallelComplexBinary(complexVector, realVector) { A, IA, B, IB, Out, IOut, N in
            Accelerate.vDSP_zrvadd(A, IA, B, IB, Out, IOut, N)
        }
    }
    
    @inline(__always)
    static func add<RealVector, ComplexVector>(_ realVector: RealVector, _ complexVector: ComplexVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>, RealVector.Element == Float{
        add(complexVector, realVector)
    }
    
    
    static func subtract<VectorA, VectorB>(_ vectorA: VectorA, _ vectorB: VectorB) -> [Complex<Float>]
    where VectorA: AccelerateBuffer, VectorB: AccelerateBuffer, VectorA.Element == Element, VectorB.Element == Element{
        parallelComplexBinary(vectorA, vectorB) { A, IA, B, IB, Out, IOut, N in
            Accelerate.vDSP_zvsub(A, IA, B, IB, Out, IOut, N)
        }
    }
    
    static func subtract<ComplexVector, RealVector>(_ complexVector: ComplexVector, _ realVector: RealVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>, RealVector.Element == Float{
        parallelComplexBinary(complexVector, realVector) { A, IA, B, IB, Out, IOut, N in
            Accelerate.vDSP_zrvsub(A, IA, B, IB, Out, IOut, N)
        }
    }
    
    static func multiply<VectorA, VectorB>(_ vectorA: VectorA, _ vectorB: VectorB) -> [Complex<Float>]
    where VectorA: AccelerateBuffer, VectorB: AccelerateBuffer, VectorA.Element == Element, VectorB.Element == Element{
        parallelComplexBinary(vectorA, vectorB) { A, IA, B, IB, Out, IOut, N in
            Accelerate.vDSP_zvmul(A, IA, B, IB, Out, IOut, N, 1)
        }
    }
    
    static func multiply<VectorA, VectorB>(conjugate vectorA: VectorA, _ vectorB: VectorB) -> [Complex<Float>]
    where VectorA: AccelerateBuffer, VectorB: AccelerateBuffer, VectorA.Element == Element, VectorB.Element == Element{
        parallelComplexBinary(vectorA, vectorB) { A, IA, B, IB, Out, IOut, N in
            Accelerate.vDSP_zvmul(A, IA, B, IB, Out, IOut, N, -1)
        }
    }
    
    static func multiply<ComplexVector, RealVector>(_ complexVector: ComplexVector, _ realVector: RealVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>, RealVector.Element == Float{
        parallelComplexBinary(complexVector, realVector) { A, IA, B, IB, Out, IOut, N in
            Accelerate.vDSP_zrvmul(A, IA, B, IB, Out, IOut, N)
        }
    }
    
    @inline(__always)
    static func multiply<RealVector, ComplexVector>(_ realVector: RealVector, _ complexVector: ComplexVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>, RealVector.Element == Float{
        multiply(complexVector, realVector)
    }
    
    static func divide<VectorA, VectorB>(_ vectorA: VectorA, _ vectorB: VectorB) -> [Complex<Float>]
    where VectorA: AccelerateBuffer, VectorB: AccelerateBuffer, VectorA.Element == Element, VectorB.Element == Element{
        parallelComplexBinary(vectorA, vectorB) { A, IA, B, IB, Out, IOut, N in
            Accelerate.vDSP_zvdiv(B, IB, A, IA, Out, IOut, N)
        }
    }
    
    static func divide<ComplexVector, RealVector>(_ complexVector: ComplexVector, _ realVector: RealVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>, RealVector.Element == Float{
        parallelComplexBinary(complexVector, realVector) { A, IA, B, IB, Out, IOut, N in
            Accelerate.vDSP_zrvdiv(A, IA, B, IB, Out, IOut, N)
        }
    }
    
    
    // MARK: Signs
    
    
    static func absolute<VectorA>(_ vector: VectorA) -> [Float]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        parallelComplexUnaryRealOut(vector) { A, IA, Out, IOut, N in
            vDSP_zvabs(A, IA, Out, IOut, N)
        }
    }
    
    static func negative<VectorA>(_ vector: VectorA) -> [Complex<Float>]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        parallelComplexUnary(vector) { A, IA, Out, IOut, N in
            vDSP_zvneg(A, IA, Out, IOut, N)
        }
    }
    
}
