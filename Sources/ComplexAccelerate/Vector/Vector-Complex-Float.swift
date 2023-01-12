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
    
    
    // MARK: Arithmetic between scalars
    
    static func add<VectorA>(_ vector: VectorA, _ scalar: Complex<Float>) -> [Complex<Float>]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        let count = vector.count
        return vector.withDSPSplitComplexPointer { vecPtr in
            scalar.withDSPSplitComplexPointer { ptPtr in
                [Element](unsafeUninitializedCapacity: count) { outBuffer, initializedCount in
                    outBuffer.withMemoryRebound(to: Element.Real.self) { outFloatBuffer in
                        vDSP_vsadd(vecPtr.pointee.realp, 2, ptPtr.pointee.realp, outFloatBuffer.baseAddress!, 2, vDSP_Length(count))
                        vDSP_vsadd(vecPtr.pointee.imagp, 2, ptPtr.pointee.imagp, outFloatBuffer.baseAddress! + 1, 2, vDSP_Length(count))
                    }
                    initializedCount = count
                }
            }
        } ?? []
    }
    
    @inline(__always)
    static func add<VectorB>(_ scalar: Complex<Float>, _ vector: VectorB) -> [Complex<Float>]
    where VectorB: AccelerateBuffer, VectorB.Element == Element{
        add(vector, scalar)
    }
    
    @inline(__always)
    static func subtract<VectorA>(_ vector: VectorA, _ scalar: Complex<Float>) -> [Complex<Float>]
    where VectorA: AccelerateBuffer, VectorA.Element == Element{
        add(vector, -scalar)
    }
    
    @inline(__always)
    static func subtract<VectorB>(_ scalar: Complex<Float>, _ vector: VectorB) -> [Complex<Float>]
    where VectorB: AccelerateBuffer, VectorB.Element == Element{
        add(negative(vector), scalar)
    }
    
    static func multiply<ComplexVector>(_ vector: ComplexVector, _ scalar: Float) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Element{
        vector.withDSPSplitComplex { splitComplex in
            [Element](unsafeUninitializedCapacity: vector.count) { buffer, initializedCount in
                buffer.withDSPSplitComplex { splitResult in
                    withUnsafePointer(to: scalar) { scalarPtr in
                        vDSP_vsmul(splitComplex.realp, 2, scalarPtr, splitResult.realp, 2, vDSP_Length(vector.count))
                        vDSP_vsmul(splitComplex.imagp, 2, scalarPtr, splitResult.imagp, 2, vDSP_Length(vector.count))
                    }
                }
                initializedCount = vector.count
            }
        } ?? []
    }
    
    @inline(__always)
    static func multiply<ComplexVector>(_ scalar: Float, _ vector: ComplexVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Element{
        multiply(vector, scalar)
    }
    
    static func multiply<ComplexVector>(_ vector: ComplexVector, _ scalar: Complex<Float>) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Element{
        vector.withDSPSplitComplexPointer { vPtr in
            scalar.withDSPSplitComplexPointer { sPtr in
                [Element](unsafeUninitializedCapacity: vector.count) { buffer, initializedCount in
                    buffer.withDSPSplitComplexPointer { pointer in
                        vDSP_zvmul(vPtr, 2, sPtr, 0, pointer, 2, vDSP_Length(vector.count), 1)
                    }
                    initializedCount = vector.count
                }
            }
        } ?? []
    }
    
    static func multiply<ComplexVector>(conjugate vector: ComplexVector, _ scalar: Complex<Float>) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Element{
        vector.withDSPSplitComplexPointer { vPtr in
            scalar.withDSPSplitComplexPointer { sPtr in
                [Element](unsafeUninitializedCapacity: vector.count) { buffer, initializedCount in
                    buffer.withDSPSplitComplexPointer { pointer in
                        vDSP_zvmul(vPtr, 2, sPtr, 0, pointer, 2, vDSP_Length(vector.count), -1)
                    }
                    initializedCount = vector.count
                }
            }
        } ?? []
    }
    
    
    // MARK: Vector Calcalus
    
    static func sum<U>(_ array: U) -> Complex<Float>
    where U: AccelerateBuffer, U.Element == Element{
        array.withDSPSplitComplexPointer { splitComplexPointer in
            var result: Element = .zero
            vDSP_sve(splitComplexPointer.pointee.realp, 2, &result.real, vDSP_Length(array.count))
            vDSP_sve(splitComplexPointer.pointee.imagp, 2, &result.imag, vDSP_Length(array.count))
            return result
        } ?? .zero
    }
    static func sumOfSquaredMagnitudes<ComplexArray>(_ array: ComplexArray) -> Float
    where ComplexArray: AccelerateBuffer, ComplexArray.Element == Element{
        array.withUnsafeBufferPointer { buffer in
            buffer.withMemoryRebound(to: Element.Real.self) { realBuffer in
                if let ptr = realBuffer.baseAddress{
                    var result: Element.Real = 0
                    vDSP_svesq(ptr, 1, &result, vDSP_Length(2 * array.count))
                    return result
                }else{
                    return 0
                }
            }
        }
    }
    /// Returns the mean of the given array.
    ///
    /// Returns the mean of the given array. For safety, this function returns zero when the input array is empty while mathematically the result should be `.nan`.
    /// - Remark: This function gives zero when the array is empty.
    static func mean<ComplexArray>(_ array: ComplexArray) -> Complex<Float>
    where ComplexArray: AccelerateBuffer, ComplexArray.Element == Element{
        var result: Element = .zero
        array.withDSPSplitComplex { splitComplex in
            vDSP_meanv(splitComplex.realp, 2, &result.real, vDSP_Length(array.count))
            vDSP_meanv(splitComplex.imagp, 2, &result.imag, vDSP_Length(array.count))
        }
        return result
    }
    
    /// Returns the mean of the squares of the magnitudes of each element of the given array.
    static func meanSquareMagnitude<ComplexArray>(_ array: ComplexArray) -> Float
    where ComplexArray: AccelerateBuffer, ComplexArray.Element == Element{
        var result: Element.Real = .zero
        array.withDSPSplitComplex { splitComplex in
            vDSP_measqv(splitComplex.realp, 1, &result, vDSP_Length(2 * array.count))
        }
        return 2 * result
    }
    static func rootMeanSquareMagnitude<ComplexArray>(_ array: ComplexArray) -> Float
    where ComplexArray: AccelerateBuffer, ComplexArray.Element == Element{
        var result: Element.Real = .zero
        array.withDSPSplitComplex { splitComplex in
            vDSP_rmsqv(splitComplex.realp, 1, &result, vDSP_Length(2 * array.count))
        }
        return sqrtf(2) * result
    }
    static func dot<U, V>(_ vectorA: U, _ vectorB: V) -> Complex<Float>
    where U: AccelerateBuffer, V: AccelerateBuffer, U.Element == Element, V.Element == Element{
        
        let count = min(vectorA.count, vectorB.count)
        var result: Element = .zero
        vectorA.withDSPSplitComplexPointer { ptrA in
            vectorB.withDSPSplitComplexPointer { ptrB in
                result.withDSPSplitComplexMutablePointer { ptrResult in
                    vDSP_zdotpr(ptrA, 2, ptrB, 2, ptrResult, vDSP_Length(count))
                }
            }
        }
        return result
    }
    static func dot<U, V>(conjugate vectorA: U, _ vectorB: V) -> Complex<Float>
    where U: AccelerateBuffer, V: AccelerateBuffer, U.Element == Element, V.Element == Element{
        let count = min(vectorA.count, vectorB.count)
        var result: Element = .zero
        vectorA.withDSPSplitComplexPointer { ptrA in
            vectorB.withDSPSplitComplexPointer { ptrB in
                result.withDSPSplitComplexMutablePointer { ptrResult in
                    vDSP_zidotpr(ptrA, 2, ptrB, 2, ptrResult, vDSP_Length(count))
                }
            }
        }
        return result
    }
    
    static func dot<ComplexVector, RealVector>(_ complexVector: ComplexVector, _ realVector: RealVector) -> Complex<Float>
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == Element, RealVector.Element == Float{
        let count = min(complexVector.count, realVector.count)
        var result: Element = .zero
        complexVector.withDSPSplitComplexPointer { ptrA in
            realVector.withRealPointer { ptrB in
                result.withDSPSplitComplexMutablePointer { ptrResult in
                    vDSP_zrdotpr(ptrA, 2, ptrB, 1, ptrResult, vDSP_Length(count))
                }
            }
        }
        return result
    }
    
    @inline(__always)
    static func dot<RealVector, ComplexVector>(_ realVector: RealVector, _ complexVector: ComplexVector) -> Complex<Float>
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == Element, RealVector.Element == Float{
        dot(complexVector, realVector)
    }
    
    /*
    // MARK: Mathematical Function
    
    static func log<ComplexVector>(_ complexVector: ComplexVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Element{
        [Element](unsafeUninitializedCapacity: complexVector.count) { buffer, initializedCount in
            
            initializedCount = complexVector.count
        }
    }*/
    
}
