//
//  Complex-Pointers.swift
//  
//
//  Created by Albertus Liberius on 2023-01-03.
//

import Foundation
import Accelerate

// MARK: Single Precision Pointers

extension Complex where Real == Float{
    /// Provides the `UnsafePointer<DSPComplex>` to the given closure where the pointer points `self` but the type is converted to `DSPComplex`.
    public func withDSPComplexPointer(_ closure: (_ pointer: UnsafePointer<DSPComplex>) -> ()){
        withUnsafePointer(to: self) { rawPointer in
            rawPointer.withMemoryRebound(to: DSPComplex.self, capacity: 1) { pointer in
                closure(pointer)
            }
        }
    }
    /// Provides the pointer to the `DSPSplitComplex` structure which points `self`.
    /// - Remark: This function assumes that the `closure` mutates `self`. If not, you can use ``withDSPSplitComplexPointer(_:)``.
    public mutating func withMutableDSPSplitComplexPointer(_ closure: (_ pointer: UnsafePointer<DSPSplitComplex>) -> ()){
        withUnsafeMutablePointer(to: &self) { rawPointer in
            rawPointer.withMemoryRebound(to: Float.self, capacity: 2) { pointer in
                var splitComplex = DSPSplitComplex(realp: pointer, imagp: pointer + 1)
                closure(&splitComplex)
            }
        }
    }
    /// Provides the pointer to the `DSPSplitComplex` structure which points `self`, and also indicates that the given `closure` will never mutate `self`.
    /// - Important: Using this function indicates that the `closure` never mutates `self`. However, as `DSPSplitComplex` holds `UnsafeMutablePointer<Float>` pointing to `self`, `closure` is not prohibited technically to mutate the content of `self`. Thus, you must be careful not to use this function if `closure` is a kind of function mutating the complex value or the content of complex value array pointed by its input pointer. If so, you must use ``withMutableDSPSplitComplexPointer(_:)``.
    public func withDSPSplitComplexPointer(_ closure: (_ pointer: UnsafePointer<DSPSplitComplex>) -> ()){
        withUnsafePointer(to: self) { rawPointer in
            rawPointer.withMemoryRebound(to: Float.self, capacity: 2) { pointer in
                var splitComplex = DSPSplitComplex(realp: UnsafeMutablePointer(mutating: pointer), imagp: UnsafeMutablePointer(mutating: pointer + 1))
                closure(&splitComplex)
            }
        }
    }
}



// MARK: Double Precision Pointers


extension Complex where Real == Double{
    /// Provides the `UnsafePointer<DSPDoubleComplex>` to the given closure where the pointer points `self` but the type is converted to `DSPDoubleComplex`.
    public func withDSPDoubleComplexPointer(_ closure: (_ pointer: UnsafePointer<DSPDoubleComplex>) -> ()){
        withUnsafePointer(to: self) { rawPointer in
            rawPointer.withMemoryRebound(to: DSPDoubleComplex.self, capacity: 1) { pointer in
                closure(pointer)
            }
        }
    }
    
    /// Provides the pointer to the `DSPDoubleSplitComplex` structure which points `self`.
    /// - Remark: This function assumes that the `closure` mutates `self`. If not, you can use ``withDSPDoubleSplitComplexPointer(_:)``.
    public mutating func withMutableDSPDoubleSplitComplexPointer(_ closure: (_ pointer: UnsafePointer<DSPDoubleSplitComplex>) -> ()){
        withUnsafeMutablePointer(to: &self) { rawPointer in
            rawPointer.withMemoryRebound(to: Double.self, capacity: 2) { pointer in
                var splitComplex = DSPDoubleSplitComplex(realp: pointer, imagp: pointer + 1)
                closure(&splitComplex)
            }
        }
    }
    /// Provides the pointer to the `DSPDoubleSplitComplex` structure which points `self`, and also indicates that the given `closure` will never mutate `self`.
    /// - Important: Using this function indicates that the `closure` never mutates `self`. However, as `DSPDoubleSplitComplex` holds `UnsafeMutablePointer<Double>` pointing to `self`, `closure` is not prohibited technically to mutate the content of `self`. Thus, you must be careful not to use this function if `closure` is a kind of function mutating the complex value or the content of complex value array pointed by its input pointer. If so, you must use ``withMutableDSPDoubleSplitComplexPointer(_:)``.
    public func withDSPDoubleSplitComplexPointer(_ closure: (_ pointer: UnsafePointer<DSPDoubleSplitComplex>) -> ()){
        withUnsafePointer(to: self) { rawPointer in
            rawPointer.withMemoryRebound(to: Double.self, capacity: 2) { pointer in
                var splitComplex = DSPDoubleSplitComplex(realp: UnsafeMutablePointer(mutating: pointer), imagp: UnsafeMutablePointer(mutating: pointer + 1))
                closure(&splitComplex)
            }
        }
    }
}
