//
//  Complex-Pointers.swift
//  
//
//  Created by Albertus Liberius on 2023-01-03.
//

import Foundation
import Accelerate


protocol GenericComplex{
    associatedtype Real
    var real: Real { get }
    var imag: Real { get }
    init(real: Real, imag: Real)
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
    mutating func withDSPSplitComplexMutablePointer<R>(_ closure: (_ pointer: UnsafePointer<DSPSplitComplex>) -> R) -> R{
        withUnsafeMutablePointer(to: &self) { rawPointer in
            rawPointer.withMemoryRebound(to: Float.self, capacity: 2) { pointer in
                var splitComplex = DSPSplitComplex(realp: UnsafeMutablePointer(mutating: pointer), imagp: UnsafeMutablePointer(mutating: pointer + 1))
                return closure(&splitComplex)
            }
        }
    }
    func withDSPSplitComplex<R>(_ closure: (_ splitComplex: DSPSplitComplex) -> R) -> R{
        withUnsafePointer(to: self) { rawPointer in
            rawPointer.withMemoryRebound(to: Float.self, capacity: 2) { pointer in
                let splitComplex = DSPSplitComplex(realp: UnsafeMutablePointer(mutating: pointer), imagp: UnsafeMutablePointer(mutating: pointer + 1))
                return closure(splitComplex)
            }
        }
    }
    mutating func withDSPSplitComplexMutable<R>(_ closure: (_ splitComplex: DSPSplitComplex) -> R) -> R{
        withUnsafeMutablePointer(to: &self) { rawPointer in
            rawPointer.withMemoryRebound(to: Float.self, capacity: 2) { pointer in
                let splitComplex = DSPSplitComplex(realp: UnsafeMutablePointer(mutating: pointer), imagp: UnsafeMutablePointer(mutating: pointer + 1))
                return closure(splitComplex)
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
    mutating func withDSPDoubleSplitComplexMutablePointer<R>(_ closure: (_ pointer: UnsafePointer<DSPDoubleSplitComplex>) -> R) -> R{
        withUnsafeMutablePointer(to: &self) { rawPointer in
            rawPointer.withMemoryRebound(to: Double.self, capacity: 2) { pointer in
                var splitComplex = DSPDoubleSplitComplex(realp: UnsafeMutablePointer(mutating: pointer), imagp: UnsafeMutablePointer(mutating: pointer + 1))
                return closure(&splitComplex)
            }
        }
    }
    func withDSPDoubleSplitComplex<R>(_ closure: (_ splitComplex: DSPDoubleSplitComplex) -> R) -> R{
        withUnsafePointer(to: self) { rawPointer in
            rawPointer.withMemoryRebound(to: Double.self, capacity: 2) { pointer in
                let splitComplex = DSPDoubleSplitComplex(realp: UnsafeMutablePointer(mutating: pointer), imagp: UnsafeMutablePointer(mutating: pointer + 1))
                return closure(splitComplex)
            }
        }
    }
    mutating func withDSPDoubleSplitComplexMutable<R>(_ closure: (_ splitComplex: DSPDoubleSplitComplex) -> R) -> R{
        withUnsafeMutablePointer(to: &self) { rawPointer in
            rawPointer.withMemoryRebound(to: Double.self, capacity: 2) { pointer in
                let splitComplex = DSPDoubleSplitComplex(realp: UnsafeMutablePointer(mutating: pointer), imagp: UnsafeMutablePointer(mutating: pointer + 1))
                return closure(splitComplex)
            }
        }
    }
}


extension AccelerateBuffer where Element: GenericComplex{
    func withRealPointer<R>(_ closure: (_ pointer: UnsafePointer<Element.Real>) -> R) -> R? {
        self.withUnsafeBufferPointer { buffer in
            guard let ptr = buffer.baseAddress else{
                return nil
            }
            return ptr.withMemoryRebound(to: Element.Real.self, capacity: 2 * buffer.count) { pointer in
                return closure(pointer)
            }
        }
    }
}


extension AccelerateBuffer where Element: GenericComplex, Element.Real == Float{
    func withDSPSplitComplexPointer<R>(_ closure: (_ pointer: UnsafePointer<DSPSplitComplex>) -> R) -> R? {
        self.withUnsafeBufferPointer { buffer in
            guard let ptr = buffer.baseAddress else{
                return nil
            }
            return ptr.withMemoryRebound(to: Element.Real.self, capacity: 2 * buffer.count) { pointer in
                var splitComplex = DSPSplitComplex(realp: .init(mutating: pointer), imagp: .init(mutating: pointer + 1))
                return closure(&splitComplex)
            }
        }
    }
    func withDSPSplitComplex<R>(_ closure: (_ splitComplex: DSPSplitComplex) -> R) -> R? {
        self.withUnsafeBufferPointer { buffer in
            guard let ptr = buffer.baseAddress else{
                return nil
            }
            return ptr.withMemoryRebound(to: Element.Real.self, capacity: 2 * buffer.count) { pointer in
                let splitComplex = DSPSplitComplex(realp: .init(mutating: pointer), imagp: .init(mutating: pointer + 1))
                return closure(splitComplex)
            }
        }
    }
}

extension AccelerateBuffer where Element: GenericComplex, Element.Real == Double{
    func withDSPDoubleSplitComplexPointer<R>(_ closure: (_ pointer: UnsafePointer<DSPDoubleSplitComplex>) -> R) -> R? {
        self.withUnsafeBufferPointer { buffer in
            guard let ptr = buffer.baseAddress else{
                return nil
            }
            return ptr.withMemoryRebound(to: Element.Real.self, capacity: 2 * buffer.count) { pointer in
                var splitComplex = DSPDoubleSplitComplex(realp: .init(mutating: pointer), imagp: .init(mutating: pointer + 1))
                return closure(&splitComplex)
            }
        }
    }
    func withDSPDoubleSplitComplex<R>(_ closure: (_ splitComplex: DSPDoubleSplitComplex) -> R) -> R? {
        self.withUnsafeBufferPointer { buffer in
            guard let ptr = buffer.baseAddress else{
                return nil
            }
            return ptr.withMemoryRebound(to: Element.Real.self, capacity: 2 * buffer.count) { pointer in
                let splitComplex = DSPDoubleSplitComplex(realp: .init(mutating: pointer), imagp: .init(mutating: pointer + 1))
                return closure(splitComplex)
            }
        }
    }
}

extension AccelerateMutableBuffer where Element: GenericComplex{
    mutating func withRealMutablePointer<R>(_ closure: (_ pointer: UnsafeMutablePointer<Element.Real>) -> R) -> R? {
        self.withUnsafeMutableBufferPointer { buffer in
            guard let ptr = buffer.baseAddress else{
                return nil
            }
            return ptr.withMemoryRebound(to: Element.Real.self, capacity: 2 * buffer.count) { pointer in
                return closure(pointer)
            }
        }
    }
}

extension AccelerateMutableBuffer where Element: GenericComplex, Element.Real == Float{
    mutating func withDSPSplitComplexMutablePointer<R>(_ closure: (_ pointer: UnsafePointer<DSPSplitComplex>) -> R) -> R? {
        self.withUnsafeMutableBufferPointer { buffer in
            guard let ptr = buffer.baseAddress else{
                return nil
            }
            return ptr.withMemoryRebound(to: Element.Real.self, capacity: 2 * buffer.count) { pointer in
                var splitComplex = DSPSplitComplex(realp: pointer, imagp: pointer + 1)
                return closure(&splitComplex)
            }
        }
    }
}

extension AccelerateMutableBuffer where Element: GenericComplex, Element.Real == Double{
    mutating func withDSPDoubleSplitComplexMutablePointer<R>(_ closure: (_ pointer: UnsafePointer<DSPDoubleSplitComplex>) -> R) -> R? {
        self.withUnsafeMutableBufferPointer { buffer in
            guard let ptr = buffer.baseAddress else{
                return nil
            }
            return ptr.withMemoryRebound(to: Element.Real.self, capacity: 2 * buffer.count) { pointer in
                var splitComplex = DSPDoubleSplitComplex(realp: pointer, imagp: pointer + 1)
                return closure(&splitComplex)
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
