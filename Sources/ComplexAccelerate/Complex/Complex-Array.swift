//
//  Complex-Array.swift
//  
//
//  Created by Albertus Liberius on 2023-01-03.
//

import Foundation
import Accelerate

extension Array where Element == Complex<Float>{
    public init(repeating: Complex<Float>, count: Int){
        self.init(unsafeUninitializedCapacity: count) { outputComplexBuffer, initializedCount in
            outputComplexBuffer.withMemoryRebound(to: Float.self) { outputFloatBuffer in
                var outputSplitComplex = DSPSplitComplex(realp: outputFloatBuffer.baseAddress!, imagp: outputFloatBuffer.baseAddress! + 1)
                repeating.withDSPSplitComplexPointer { inputSplitPointer in
                    vDSP_zvfill(inputSplitPointer, &outputSplitComplex, 2, vDSP_Length(count))
                }
            }
            initializedCount = count
        }
    }
    public init(start: Complex<Float>, step: Complex<Float>, count: Int){
        if count < 1{
            self = []
        }
        self.init(unsafeUninitializedCapacity: count) { outputComplexBuffer, initializedCount in
            outputComplexBuffer.withMemoryRebound(to: Float.self) { outputFloatBuffer in
                withUnsafePointer(to: start) { startPointer in
                    startPointer.withMemoryRebound(to: Float.self, capacity: 2) { startFloatPointer in
                        withUnsafePointer(to: step) { stepPointer in
                            stepPointer.withMemoryRebound(to: Float.self, capacity: 2) { stepFloatPointer in
                                vDSP_vramp(startFloatPointer, stepFloatPointer, outputFloatBuffer.baseAddress!, 2, vDSP_Length(count))
                                vDSP_vramp(startFloatPointer + 1, stepFloatPointer + 1, outputFloatBuffer.baseAddress! + 1, 2, vDSP_Length(count))
                            }
                        }
                    }
                }
            }
            initializedCount = count
        }
    }
    public init(start: Complex<Float>, end: Complex<Float>, count: Int){
        let countMinusOne = Float(count - 1)
        let step = Complex<Float>(real: (end.real - start.real) / countMinusOne, imag: (end.imag - start.imag) / countMinusOne)
        self.init(start: start, step: step, count: count)
    }
}


extension Array where Element == Complex<Double>{
    public init(repeating: Complex<Double>, count: Int){
        self.init(unsafeUninitializedCapacity: count) { outputComplexBuffer, initializedCount in
            outputComplexBuffer.withMemoryRebound(to: Double.self) { outputDoubleBuffer in
                var outputSplitComplex = DSPDoubleSplitComplex(realp: outputDoubleBuffer.baseAddress!, imagp: outputDoubleBuffer.baseAddress! + 1)
                repeating.withDSPDoubleSplitComplexPointer { inputSplitPointer in
                    vDSP_zvfillD(inputSplitPointer, &outputSplitComplex, 2, vDSP_Length(count))
                }
            }
            initializedCount = count
        }
    }
    public init(start: Complex<Double>, step: Complex<Double>, count: Int){
        if count < 1{
            self = []
        }
        self.init(unsafeUninitializedCapacity: count) { outputComplexBuffer, initializedCount in
            outputComplexBuffer.withMemoryRebound(to: Double.self) { outputDoubleBuffer in
                withUnsafePointer(to: start) { startPointer in
                    startPointer.withMemoryRebound(to: Double.self, capacity: 2) { startDoublePointer in
                        withUnsafePointer(to: step) { stepPointer in
                            stepPointer.withMemoryRebound(to: Double.self, capacity: 2) { stepDoublePointer in
                                vDSP_vrampD(startDoublePointer, stepDoublePointer, outputDoubleBuffer.baseAddress!, 2, vDSP_Length(count))
                                vDSP_vrampD(startDoublePointer + 1, stepDoublePointer + 1, outputDoubleBuffer.baseAddress! + 1, 2, vDSP_Length(count))
                            }
                        }
                    }
                }
            }
            initializedCount = count
        }
    }
    public init(start: Complex<Double>, end: Complex<Double>, count: Int){
        let countMinusOne = Double(count - 1)
        let step = Complex<Double>(real: (end.real - start.real) / countMinusOne, imag: (end.imag - start.imag) / countMinusOne)
        self.init(start: start, step: step, count: count)
    }
}


