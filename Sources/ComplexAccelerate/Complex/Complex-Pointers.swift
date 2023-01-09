//
//  Complex-Pointers.swift
//  
//
//  Created by Albertus Liberius on 2023-01-03.
//

import Foundation
import Accelerate


/*
protocol ParallelizableFloatingPoint: BinaryFloatingPoint{}
extension Float: ParallelizableFloatingPoint{}
extension Double: ParallelizableFloatingPoint{}
 
*/

protocol GenericComplex{
    associatedtype Real
    var real: Real { get }
    var imag: Real { get }
    
}

extension DSPComplex: GenericComplex{}
extension DSPDoubleComplex: GenericComplex{}
extension Complex: GenericComplex{}


extension GenericComplex where Real == Float{
    func withDSPSplitComplexPointer<R>(_ closure: (_ pointer: UnsafePointer<DSPSplitComplex>) -> R) -> R{
        withUnsafePointer(to: self) { rawPointer in
            rawPointer.withMemoryRebound(to: Float.self, capacity: 2) { pointer in
                var splitComplex = DSPSplitComplex(realp: UnsafeMutablePointer(mutating: pointer), imagp: UnsafeMutablePointer(mutating: pointer + 1))
                return closure(&splitComplex)
            }
        }
    }
}
extension GenericComplex where Real == Double{
    func withDSPDoubleSplitComplexPointer<R>(_ closure: (_ pointer: UnsafePointer<DSPDoubleSplitComplex>) -> R) -> R{
        withUnsafePointer(to: self) { rawPointer in
            rawPointer.withMemoryRebound(to: Double.self, capacity: 2) { pointer in
                var splitComplex = DSPDoubleSplitComplex(realp: UnsafeMutablePointer(mutating: pointer), imagp: UnsafeMutablePointer(mutating: pointer + 1))
                return closure(&splitComplex)
            }
        }
    }
}

extension AccelerateBuffer where Element: GenericComplex, Element.Real == Float{
    func withDSPSplitComplexPointer<R>(_ closure: (_ pointer: UnsafePointer<DSPSplitComplex>) -> R) -> R? {
        self.withUnsafeBufferPointer { buffer in
            buffer.withMemoryRebound(to: Element.Real.self) { floatBuffer in
                if let baseAddress = floatBuffer.baseAddress{
                    var splitComplex = DSPSplitComplex.init(realp: .init(mutating: baseAddress), imagp: .init(mutating: baseAddress + 1))
                    return closure(&splitComplex)
                }else{
                    return nil
                }
            }
        }
    }
}

extension AccelerateBuffer where Element: GenericComplex, Element.Real == Double{
    func withDSPDoubleSplitComplexPointer<R>(_ closure: (_ pointer: UnsafePointer<DSPDoubleSplitComplex>) -> R) -> R? {
        self.withUnsafeBufferPointer { buffer in
            buffer.withMemoryRebound(to: Element.Real.self) { floatBuffer in
                if let baseAddress = floatBuffer.baseAddress{
                    var splitComplex = DSPDoubleSplitComplex(realp: .init(mutating: baseAddress), imagp: .init(mutating: baseAddress + 1))
                    return closure(&splitComplex)
                }else{
                    return nil
                }
            }
        }
    }
}

extension AccelerateBuffer where Element == Float{
    func withRealPointer<R>(_ closure: (_ pointer: UnsafePointer<Element>) -> R) -> R? {
        self.withUnsafeBufferPointer { buffer in
            if let baseAddress = buffer.baseAddress{
                return closure(baseAddress)
            }else{
                return nil
            }
        }
    }
}

extension AccelerateBuffer where Element == Double{
    func withRealPointer<R>(_ closure: (_ pointer: UnsafePointer<Element>) -> R) -> R? {
        self.withUnsafeBufferPointer { buffer in
            if let baseAddress = buffer.baseAddress{
                return closure(baseAddress)
            }else{
                return nil
            }
        }
    }
}

extension UnsafeMutableBufferPointer where Element == Float{
    mutating func withRealMutablePointer<R>(_ closure: (_ pointer: UnsafeMutablePointer<Element>) -> R) -> R? {
        self.withUnsafeMutableBufferPointer { buffer in
            if let baseAddress = buffer.baseAddress{
                return closure(baseAddress)
            }else{
                return nil
            }
        }
    }
}

extension UnsafeMutableBufferPointer where Element == Double{
    mutating func withRealMutablePointer<R>(_ closure: (_ pointer: UnsafeMutablePointer<Element>) -> R) -> R? {
        self.withUnsafeMutableBufferPointer { buffer in
            if let baseAddress = buffer.baseAddress{
                return closure(baseAddress)
            }else{
                return nil
            }
        }
    }
}
