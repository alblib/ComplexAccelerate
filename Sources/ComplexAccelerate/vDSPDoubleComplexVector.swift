//
//  vDDoubleComplexVector.swift
//
//
//  Created by Albertus Liberius on 2023-01-01.
//

import Foundation
import Accelerate



public enum vDSPDoubleComplexVector{
    
    
    /// Splits an array of complex numbers into the array of the real components and the array of the imaginary components.
    ///
    /// - Note: This function is a wrapper of `vDSP_ctozD` function in `Accelerate` framework.
    /// - Parameter complexVector: The array of complex numbers in form of structure `DSPDoubleComplex`.
    /// - Returns: The pair `(real: [Double], imag: [Double])` of the array of real parts and the array of imaginary parts, which can be dereferenced by calling the member `.real` and `.imag`.
    /// - Remark: No exception guaranteed.
    public static func split(_ complexVector: [DSPDoubleComplex]) -> (real: [Double], imag: [Double]){
        let count = complexVector.count
        var real: [Double] = []
        var imag: [Double] = []
        real = [Double](unsafeUninitializedCapacity: count, initializingWith: { realBuffer, realInitializedCount in
            imag = [Double](unsafeUninitializedCapacity: count, initializingWith: { imagBuffer, imagInitializedCount in
                var splitComplex = DSPDoubleSplitComplex(realp: realBuffer.baseAddress!, imagp: imagBuffer.baseAddress!)
                vDSP_ctozD(complexVector, 2, &splitComplex, 1, vDSP_Length(count)) // to move 1 in DSPComplex, input vDSP_Stride = 2
                imagInitializedCount = count
            })
            realInitializedCount = count
        })
        return (real: real, imag: imag)
    }
    
    /// Combine an array of real parts and an array of imaginary parts to make the array of complex numbers.
    /// - Parameters:
    ///     - reals: The real parts of the complex numbers in order.
    ///     - imaginaries: The imaginary parts of the complex numbers in order.
    /// - Returns: The array of `DSPDoubleComplex` combining the array of the real parts and the array of the imaginary parts.
    /// - Note: This function is a wrapper of `vDSP_ztocD` function in `Accelerate` framework.
    /// - Remark: No exception guaranteed. The output array size is confined to the smaller one from the two inputs.
    public static func complexify(reals: [Double], imaginaries: [Double]) -> [DSPDoubleComplex]{
        let count = min(reals.count, imaginaries.count)
        return [DSPDoubleComplex](unsafeUninitializedCapacity: count) { buffer, initializedCount in
            reals.withUnsafeBufferPointer { realBuffer in
                imaginaries.withUnsafeBufferPointer { imagBuffer in
                    var splitComplex = DSPDoubleSplitComplex(realp: UnsafeMutablePointer<Double>(mutating: realBuffer.baseAddress!), imagp: UnsafeMutablePointer<Double>(mutating: imagBuffer.baseAddress!))
                    vDSP_ztocD(&splitComplex, 1, buffer.baseAddress!, 2, vDSP_Length(count))
                }
            }
            initializedCount = count
        }
    }
    
    public static func conjugate(_ complexVector: [DSPDoubleComplex]) -> [DSPDoubleComplex] {
        let count = complexVector.count
        return [DSPDoubleComplex](unsafeUninitializedCapacity: count) { outputBuffer, initializedCount in
            outputBuffer.withMemoryRebound(to: Double.self) { outputDoubleBuffer in
                var outputSplitComplex =
                    DSPDoubleSplitComplex(realp: outputDoubleBuffer.baseAddress!,
                                          imagp: outputDoubleBuffer.baseAddress! + 1)
                complexVector.withUnsafeBufferPointer { inputBuffer in
                    inputBuffer.withMemoryRebound(to: Double.self) { inputDoubleBuffer in
                        var inputSplitComplex =
                            DSPDoubleSplitComplex(
                                realp: UnsafeMutablePointer<Double>(mutating: inputDoubleBuffer.baseAddress!),
                                imagp: UnsafeMutablePointer<Double>(mutating: inputDoubleBuffer.baseAddress! + 1))
                        vDSP_zvconjD(&inputSplitComplex, 2, &outputSplitComplex, 2, vDSP_Length(count))
                    }
                }
            }
            initializedCount = count
        }
    }
    
    /// Returns a negated array from an array of complex numbers.
    public static func negative(_ complexVector: [DSPDoubleComplex]) -> [DSPDoubleComplex] {
        let count = complexVector.count
        return [DSPDoubleComplex](unsafeUninitializedCapacity: count) { outputBuffer, initializedCount in
            outputBuffer.withMemoryRebound(to: Double.self) { outputDoubleBuffer in
                complexVector.withUnsafeBufferPointer { inputBuffer in
                    inputBuffer.withMemoryRebound(to: Double.self) { inputDoublebuffer in
                        vDSP_vnegD(inputDoublebuffer.baseAddress!, 1, outputDoubleBuffer.baseAddress!, 1, vDSP_Length(2 * count))
                        // you can use vDSP_zvnegD instead.
                    }
                }
            }
            initializedCount = count
        }
    }
    
    /// Returns the real array of absolute values of each of the given complex array.
    public static func absolute(_ complexVector: [DSPDoubleComplex]) -> [Double] {
        let count = complexVector.count
        return [Double](unsafeUninitializedCapacity: count) { outputBuffer, initializedCount in
            complexVector.withUnsafeBufferPointer { inputComplexBuffer in
                inputComplexBuffer.withMemoryRebound(to: Double.self) { inputDoubleBuffer in
                    var inputSplitComplex = DSPDoubleSplitComplex(realp: UnsafeMutablePointer<Double>(mutating: inputDoubleBuffer.baseAddress!), imagp: UnsafeMutablePointer<Double>(mutating: inputDoubleBuffer.baseAddress! + 1))
                    vDSP_zvabsD(&inputSplitComplex, 2, outputBuffer.baseAddress!, 1, vDSP_Length(count))
                }
            }
            initializedCount = count
        }
    }
    
    public static func squareMagnitudes(_ complexVector: [DSPDoubleComplex]) -> [Double] {
        let count = complexVector.count
        return [Double](unsafeUninitializedCapacity: count) { outputBuffer, initializedCount in
            complexVector.withUnsafeBufferPointer { inputComplexBuffer in
                inputComplexBuffer.withMemoryRebound(to: Double.self) { inputDoubleBuffer in
                    var inputSplitComplex = DSPDoubleSplitComplex(realp: UnsafeMutablePointer<Double>(mutating: inputDoubleBuffer.baseAddress!), imagp: UnsafeMutablePointer<Double>(mutating: inputDoubleBuffer.baseAddress! + 1))
                    vDSP_zvmagsD(&inputSplitComplex, 2, outputBuffer.baseAddress!, 1, vDSP_Length(count))
                }
            }
            initializedCount = count
        }
    }
    public static func arguments(_ complexVector: [DSPDoubleComplex]) -> [Double] {
        let split = split(complexVector)
        let count = complexVector.count
        var count32 = Int32(complexVector.count)
        return [Double](unsafeUninitializedCapacity: count) { buffer, initializedCount in
            vvatan2(buffer.baseAddress!, split.imag, split.real, &count32)
            initializedCount = count
        }
    }
}

// MARK: - Wrapper Basic Components

extension vDSPDoubleComplexVector{
    static func vDSP_wrapper_complexVectorOutput(vectorDimension: Int, wrapping: (_ Out: UnsafePointer<DSPDoubleSplitComplex>, _ IOut: vDSP_Stride, _ N: vDSP_Length) -> ()) -> [DSPDoubleComplex]{
        [DSPDoubleComplex](unsafeUninitializedCapacity: vectorDimension) { outputBuffer, initializedCount in
            outputBuffer.withMemoryRebound(to: Double.self) { outputDoubleBuffer in
                var outputSplitComplex = DSPDoubleSplitComplex(realp: outputDoubleBuffer.baseAddress!, imagp: outputDoubleBuffer.baseAddress! + 1)
                wrapping(&outputSplitComplex, 2, vDSP_Length(vectorDimension))
            }
            initializedCount = vectorDimension
        }
    }
    static func vDSP_wrapper_complexScalarOutput(inputVectorDimension: Int, wrapping: (_ Out: UnsafePointer<DSPDoubleSplitComplex>, _ N: vDSP_Length) -> ()) -> DSPDoubleComplex{
        [DSPDoubleComplex](unsafeUninitializedCapacity: 1) { outputArrayBuffer, initializedCount in
            outputArrayBuffer.withMemoryRebound(to: Double.self) { outputDoubleBuffer in
                var outputSplitComplex = DSPDoubleSplitComplex(realp: outputDoubleBuffer.baseAddress!, imagp: outputDoubleBuffer.baseAddress! + 1)
                wrapping(&outputSplitComplex, vDSP_Length(inputVectorDimension))
            }
            initializedCount = 1
        }[0]
    }
    
    static func vDSP_wrapper_complexVectorInput(complexVectorPtr: UnsafePointer<DSPDoubleComplex>, capacity: Int, wrapping: (_ A: UnsafePointer<DSPDoubleSplitComplex>, _ IA: vDSP_Stride) -> ()) {
        complexVectorPtr.withMemoryRebound(to: Double.self, capacity: 2 * capacity) { pointer in
            var inputSplitComplex =
                DSPDoubleSplitComplex(
                    realp: UnsafeMutablePointer(mutating: pointer),
                    imagp: UnsafeMutablePointer(mutating: pointer + 1))
            wrapping(&inputSplitComplex, 2)
        }
    }
    static func vDSP_wrapper_complexScalarInput(complexScalar: DSPDoubleComplex, wrapping: (_ A: UnsafePointer<DSPDoubleSplitComplex>) -> ()){
        withUnsafePointer(to: complexScalar) { inputPointer in
            inputPointer.withMemoryRebound(to: Double.self, capacity: 2) { inputDoublePointer in
                var inputSplitComplex =
                    DSPDoubleSplitComplex(
                        realp: UnsafeMutablePointer<Double>(mutating: inputDoublePointer),
                        imagp: UnsafeMutablePointer<Double>(mutating: inputDoublePointer + 1))
                wrapping(&inputSplitComplex)
            }
        }
    }
    static func vDSP_wrapper_realVectorInput(realVectorPtr: UnsafePointer<Double>, wrapping: (_ A: UnsafePointer<Double>, _ IA: vDSP_Stride) -> ()){
        wrapping(realVectorPtr, 1)
    }
    static func vDSP_wrapper_realScalarInput(realScalar: Double, wrapping: (_ A: UnsafePointer<Double>) -> ()){
        withUnsafePointer(to: realScalar) { inputPointer in
            wrapping(inputPointer)
        }
    }
}

// MARK: - Wrapper Forms

extension vDSPDoubleComplexVector{
    static func vDSP_wrapperForm_zvzvzv(wrapping: (_ A: UnsafePointer<DSPDoubleSplitComplex>, _ IA: vDSP_Stride, _ B: UnsafePointer<DSPDoubleSplitComplex>, _ IB: vDSP_Stride, _ Out: UnsafePointer<DSPDoubleSplitComplex>, _ IOut: vDSP_Stride, _ N: vDSP_Length) -> () , complexVectorA: [DSPDoubleComplex], complexVectorB: [DSPDoubleComplex]) -> [DSPDoubleComplex]{
        vDSP_wrapper_complexVectorOutput(vectorDimension: min(complexVectorA.count, complexVectorB.count)) { Out, IOut, N in
            vDSP_wrapper_complexVectorInput(complexVectorPtr: complexVectorA, capacity: complexVectorA.capacity) { A, IA in
                vDSP_wrapper_complexVectorInput(complexVectorPtr: complexVectorB, capacity: complexVectorB.capacity) { B, IB in
                    wrapping(A, IA, B, IB, Out, IOut, N)
                }
            }
        }
    }
    static func vDSP_wrapperForm_zvzszv(wrapping: (_ A: UnsafePointer<DSPDoubleSplitComplex>, _ IA: vDSP_Stride, _ B: UnsafePointer<DSPDoubleSplitComplex>, _ Out: UnsafePointer<DSPDoubleSplitComplex>, _ IOut: vDSP_Stride, _ N: vDSP_Length) -> () , complexVectorA: [DSPDoubleComplex], complexScalarB: DSPDoubleComplex) -> [DSPDoubleComplex]{
        vDSP_wrapper_complexVectorOutput(vectorDimension: complexVectorA.count) { Out, IOut, N in
            vDSP_wrapper_complexVectorInput(complexVectorPtr: complexVectorA, capacity: complexVectorA.capacity) { A, IA in
                vDSP_wrapper_complexScalarInput(complexScalar: complexScalarB) { B in
                    wrapping(A, IA, B, Out, IOut, N)
                }
            }
        }
    }
}

    
// MARK: - Arithmetics between two complex arrays

extension vDSPDoubleComplexVector{
    
    public static func add(_ complexVectorA: [DSPDoubleComplex], _ complexVectorB: [DSPDoubleComplex]) -> [DSPDoubleComplex]{
        vDSP_wrapperForm_zvzvzv(wrapping: { A, IA, B, IB, Out, IOut, N in
            vDSP_zvaddD(A, IA, B, IB, Out, IOut, N)
        }, complexVectorA: complexVectorA, complexVectorB: complexVectorB)
    }
    public static func subtract(_ complexVectorA: [DSPDoubleComplex], _ complexVectorB: [DSPDoubleComplex]) -> [DSPDoubleComplex]{
        vDSP_wrapperForm_zvzvzv(wrapping: { A, IA, B, IB, Out, IOut, N in
            vDSP_zvsubD(A, IA, B, IB, Out, IOut, N)
        }, complexVectorA: complexVectorA, complexVectorB: complexVectorB)
    }
    public static func multiply(_ complexVectorA: [DSPDoubleComplex], _ complexVectorB: [DSPDoubleComplex]) -> [DSPDoubleComplex]{
        vDSP_wrapperForm_zvzvzv(wrapping: { A, IA, B, IB, Out, IOut, N in
            vDSP_zvmulD(A, IA, B, IB, Out, IOut, N, +1)
        }, complexVectorA: complexVectorA, complexVectorB: complexVectorB)
    }
    public static func multiply(conjugate complexVectorA: [DSPDoubleComplex], _ complexVectorB: [DSPDoubleComplex]) -> [DSPDoubleComplex]{
        vDSP_wrapperForm_zvzvzv(wrapping: { A, IA, B, IB, Out, IOut, N in
            vDSP_zvmulD(A, IA, B, IB, Out, IOut, N, -1)
        }, complexVectorA: complexVectorA, complexVectorB: complexVectorB)
    }
    public static func divide(_ complexVectorA: [DSPDoubleComplex], _ complexVectorB: [DSPDoubleComplex]) -> [DSPDoubleComplex]{
        vDSP_wrapperForm_zvzvzv(wrapping: { A, IA, B, IB, Out, IOut, N in
            vDSP_zvdivD(B, IB, A, IA, Out, IOut, N)
        }, complexVectorA: complexVectorA, complexVectorB: complexVectorB)
    }
}

// MARK: Arithmetics -- [z] * z -> [z]

extension vDSPDoubleComplexVector{
    
    public static func multiply (_ complexVector: [DSPDoubleComplex], _ complexScalar: DSPDoubleComplex) -> [DSPDoubleComplex] {
        vDSP_wrapperForm_zvzszv(wrapping: { A, IA, B, Out, IOut, N in
            vDSP_zvzsmlD(A, IA, B, Out, IOut, N)
            
        }, complexVectorA: complexVector, complexScalarB: complexScalar)
    }
}

// MARK: Arithmetics -- ([z], z, [z]) -> [z]
/*
extension vDSPDoubleComplexVector{
    static func vDSP_wrapper_zvzszvzv(wrapping: (_ A: UnsafePointer<DSPDoubleSplitComplex>, _ IA: vDSP_Stride, _ B: UnsafePointer<DSPDoubleSplitComplex>, _ C: UnsafePointer<DSPDoubleSplitComplex>, _ IC: vDSP_Stride, _ Out: UnsafePointer<DSPDoubleSplitComplex>, _ IOut: vDSP_Stride, _ N: vDSP_Length), complexVectorA: [DSPDoubleComplex], complexScalarB: DSPDoubleComplex, complexVectorC: [DSPDoubleComplex]) -> [DSPDoubleComplex]{
        let count = min(complexVectorA.count, complexVectorC.count)
        return [DSPDoubleComplex](unsafeUninitializedCapacity: count) { outputBuffer, initializedCount in
            // TODO: //vDSP_zvsma(<#T##__A: UnsafePointer<DSPSplitComplex>##UnsafePointer<DSPSplitComplex>#>, <#T##__IA: vDSP_Stride##vDSP_Stride#>, <#T##__B: UnsafePointer<DSPSplitComplex>##UnsafePointer<DSPSplitComplex>#>, <#T##__C: UnsafePointer<DSPSplitComplex>##UnsafePointer<DSPSplitComplex>#>, <#T##__IC: vDSP_Stride##vDSP_Stride#>, <#T##__D: UnsafePointer<DSPSplitComplex>##UnsafePointer<DSPSplitComplex>#>, <#T##__ID: vDSP_Stride##vDSP_Stride#>, <#T##__N: vDSP_Length##vDSP_Length#>)
            initializedCount = count
        }
    }
}*/

extension vDSPDoubleComplexVector{

    
    public static func multiply(_ complexVector: [DSPDoubleComplex], _ vector: [Double]) -> [DSPDoubleComplex]{
        let count = min(complexVector.count, vector.count)
        return [DSPDoubleComplex](unsafeUninitializedCapacity: count) { resultComplexBuffer, initializedCount in
            resultComplexBuffer.withMemoryRebound(to: Double.self) { resultDoubleBuffer in
                complexVector.withUnsafeBufferPointer { inputComplexBuffer in
                    inputComplexBuffer.withMemoryRebound(to: Double.self) { inputDoubleBuffer in
                        vDSP_vmulD(inputDoubleBuffer.baseAddress!, 2, vector, 1, resultDoubleBuffer.baseAddress!, 2, vDSP_Length(count))
                        vDSP_vmulD(inputDoubleBuffer.baseAddress! + 1, 2, vector, 1, resultDoubleBuffer.baseAddress! + 1, 2, vDSP_Length(count))
                    }
                }
            }
            initializedCount = count
        }
    }
    @inline(__always)
    public static func multiply(_ vector: [Double], _ complexVector: [DSPDoubleComplex]) -> [DSPDoubleComplex]{
        multiply(complexVector, vector)
    }
    
    public static func multiply(_ scalar: Double, _ complexVector: [DSPDoubleComplex]) -> [DSPDoubleComplex]{
        let count = complexVector.count
        var newScalar = scalar
        return [DSPDoubleComplex](unsafeUninitializedCapacity: count) { resultComplexBuffer, initializedCount in
            resultComplexBuffer.withMemoryRebound(to: Double.self) { resultDoubleBuffer in
                complexVector.withUnsafeBufferPointer { inputComplexBuffer in
                    inputComplexBuffer.withMemoryRebound(to: Double.self) { inputDoubleBuffer in
                        vDSP_vsmulD(inputDoubleBuffer.baseAddress!, 2, &newScalar, resultDoubleBuffer.baseAddress!, 2, vDSP_Length(count))
                        vDSP_vsmulD(inputDoubleBuffer.baseAddress! + 1, 2, &newScalar, resultDoubleBuffer.baseAddress! + 1, 2, vDSP_Length(count))
                    }
                }
            }
            initializedCount = count
        }
    }
    @inline(__always)
    public static func multiply(_ complexVector: [DSPDoubleComplex], _ scalar: Double) -> [DSPDoubleComplex]{
        return multiply(scalar, complexVector)
    }
    
    public static func divide(_ complexVector: [DSPDoubleComplex], _ vector: [Double]) -> [DSPDoubleComplex]{
        let count = min(complexVector.count, vector.count)
        return [DSPDoubleComplex](unsafeUninitializedCapacity: count) { resultComplexBuffer, initializedCount in
            resultComplexBuffer.withMemoryRebound(to: Double.self) { resultDoubleBuffer in
                complexVector.withUnsafeBufferPointer { inputComplexBuffer in
                    inputComplexBuffer.withMemoryRebound(to: Double.self) { inputDoubleBuffer in
                        vDSP_vdivD(vector, 1, inputDoubleBuffer.baseAddress!, 2, resultDoubleBuffer.baseAddress!, 2, vDSP_Length(count))
                        vDSP_vdivD(vector, 1, inputDoubleBuffer.baseAddress! + 1, 2, resultDoubleBuffer.baseAddress! + 1, 2, vDSP_Length(count))
                    }
                }
            }
            initializedCount = count
        }
    }
    
    public static func divide(_ complexVector: [DSPDoubleComplex], _ scalar: Double) -> [DSPDoubleComplex]{
        let count = complexVector.count
        var newScalar = scalar
        return [DSPDoubleComplex](unsafeUninitializedCapacity: count) { resultComplexBuffer, initializedCount in
            resultComplexBuffer.withMemoryRebound(to: Double.self) { resultDoubleBuffer in
                complexVector.withUnsafeBufferPointer { inputComplexBuffer in
                    inputComplexBuffer.withMemoryRebound(to: Double.self) { inputDoubleBuffer in
                        vDSP_vsdivD(inputDoubleBuffer.baseAddress!, 2, &newScalar, resultDoubleBuffer.baseAddress!, 2, vDSP_Length(count))
                        vDSP_vsdivD(inputDoubleBuffer.baseAddress! + 1, 2, &newScalar, resultDoubleBuffer.baseAddress! + 1, 2, vDSP_Length(count))
                    }
                }
            }
            initializedCount = count
        }
    }
    
}

// MARK: - Dot Product
extension vDSPDoubleComplexVector{
    public static func dot(_ complexVectorA: [DSPDoubleComplex], _ complexVectorB: [DSPDoubleComplex]) -> DSPDoubleComplex {
        vDSP_wrapper_complexScalarOutput(inputVectorDimension: min(complexVectorA.count, complexVectorB.count)) { Out, N in
            vDSP_wrapper_complexVectorInput(complexVectorPtr: complexVectorA, capacity: complexVectorA.count) { A, IA in
                vDSP_wrapper_complexVectorInput(complexVectorPtr: complexVectorB, capacity: complexVectorB.count) { B, IB in
                    vDSP_zdotprD(A, IA, B, IB, Out, N)
                }
            }
        }
    }
    public static func dot(_ complexVectorA: [DSPDoubleComplex], _ realVectorB: [Double]) -> DSPDoubleComplex {
        vDSP_wrapper_complexScalarOutput(inputVectorDimension: min(complexVectorA.count, realVectorB.count)) { Out, N in
            vDSP_wrapper_complexVectorInput(complexVectorPtr: complexVectorA, capacity: complexVectorA.count) { A, IA in
                vDSP_wrapper_realVectorInput(realVectorPtr: realVectorB) { B, IB in
                    vDSP_zrdotprD(A, IA, B, IB, Out, N)
                }
            }
        }
    }
    @inline(__always)
    public static func dot(_ realVector: [Double], _ complexVector: [DSPDoubleComplex]) -> DSPDoubleComplex{
        dot(complexVector, realVector)
    }
    public static func dot(_ realVectorA: [Double], _ realVectorB: [Double]) -> Double{
        vDSP.dot(realVectorA, realVectorB)
    }
}

// MARK: - Transcendental Functions
extension vDSPDoubleComplexVector{
    public static func log(_ complexVector: [DSPDoubleComplex]) -> [DSPDoubleComplex] {
        var real = vForce.log(absolute(complexVector))
        var imag = arguments(complexVector)
        let count = complexVector.count
        return [DSPDoubleComplex](unsafeUninitializedCapacity: count) { buffer, initializedCount in
            real.withUnsafeMutableBufferPointer { realBuffer in
                imag.withUnsafeMutableBufferPointer { imagBuffer in
                    var splitComplex = DSPDoubleSplitComplex(realp: realBuffer.baseAddress!, imagp: imagBuffer.baseAddress!)
                    vDSP_ztocD(&splitComplex, 1, buffer.baseAddress!, 2, vDSP_Length(count))
                }
            }
            initializedCount = count
        }
    }
    public static func expi(arguments: [Double]) -> [DSPDoubleComplex] {
        let count = arguments.count
        let count32: [Int32] = [Int32(count)]
        return [DSPDoubleComplex](unsafeUninitializedCapacity: count) { buffer, initializedCount in
            vvcosisin(OpaquePointer(buffer.baseAddress!), arguments, count32)
            initializedCount = count
        }
    }
    public static func exp(_ complexVector: [DSPDoubleComplex]) -> [DSPDoubleComplex] {
        let splited = split(complexVector)
        let magnitudes = vForce.exp(splited.real)
        return multiply(magnitudes, expi(arguments: splited.imag))
    }
    public static func pow(bases: [DSPDoubleComplex], exponents: [Double]) -> [DSPDoubleComplex] {
        let count = min(bases.count, exponents.count)
        return exp(multiply(log(Array(bases[0..<count])), exponents))
    }
    
    public static func pow(bases: [DSPDoubleComplex], exponents: [DSPDoubleComplex]) -> [DSPDoubleComplex] {
        let count = min(bases.count, exponents.count)
        return exp(multiply(log(Array(bases[0..<count])), exponents))
    }
    
    public static func pow(bases: [DSPDoubleComplex], exponent: Double) -> [DSPDoubleComplex] {
        exp(multiply(exponent, log(bases)))
    }
    public static func cosh(_ complexVector: [DSPDoubleComplex]) -> [DSPDoubleComplex]{
        divide(add(exp(complexVector), exp(negative(complexVector))), 2)
    }
    public static func sinh(_ complexVector: [DSPDoubleComplex]) -> [DSPDoubleComplex]{
        divide(subtract(exp(complexVector), exp(negative(complexVector))), 2)
    }
    public static func tanh(_ complexVector: [DSPDoubleComplex]) -> [DSPDoubleComplex]{
        divide(subtract(exp(complexVector), exp(negative(complexVector))), add(exp(complexVector), exp(negative(complexVector))))
    }
    public static func coth(_ complexVector: [DSPDoubleComplex]) -> [DSPDoubleComplex]{
        divide(add(exp(complexVector), exp(negative(complexVector))), subtract(exp(complexVector), exp(negative(complexVector))))
    }
    public static func cos(_ complexVector: [DSPDoubleComplex]) -> [DSPDoubleComplex] {
        let splited = split(complexVector)
        let ITimes = complexify(reals: vDSP.negative(splited.imag), imaginaries: splited.real)
        return cosh(ITimes)
    }
    public static func sin(_ complexVector: [DSPDoubleComplex]) -> [DSPDoubleComplex] {
        let splited = split(complexVector)
        let ITimes = complexify(reals: vDSP.negative(splited.imag), imaginaries: splited.real)
        let sinhSplit = split(sinh(ITimes)) // -> now divide I -> (re,im) -> (im,-re)
        return complexify(reals: sinhSplit.imag, imaginaries: vDSP.negative(sinhSplit.real))
    }
    public static func tan(_ complexVector: [DSPDoubleComplex]) -> [DSPDoubleComplex] {
        // tanh(iz)/i
        let splited = split(complexVector)
        let ITimes = complexify(reals: vDSP.negative(splited.imag), imaginaries: splited.real)
        let tanhSplit = split(tanh(ITimes))
        return complexify(reals: tanhSplit.imag, imaginaries: vDSP.negative(tanhSplit.real))
    }
    public static func cot(_ complexVector: [DSPDoubleComplex]) -> [DSPDoubleComplex] {
        // icoth(iz)
        let splited = split(complexVector)
        let ITimes = complexify(reals: vDSP.negative(splited.imag), imaginaries: splited.real)
        let cothSplit = split(coth(ITimes))
        return complexify(reals: vDSP.negative(cothSplit.imag), imaginaries: cothSplit.real)
    }
}

