//
//  Matrix.swift
//  
//
//  Created by Albertus Liberius on 2023-01-13.
//

import Foundation
import Accelerate

public struct Matrix<Element>{
    public var elements: [Element]
    public var rowCount: Int
    public var columnCount: Int
    public init?(elements: [Element], rowCount: Int, columnCount: Int) {
        let count = rowCount * columnCount
        guard elements.count >= count else{
            return nil
        }
        guard rowCount >= 0 else{
            return nil
        }
        guard columnCount >= 0 else{
            return nil
        }
        self.elements = Array(elements[0..<count])
        self.rowCount = rowCount
        self.columnCount = columnCount
    }
    public subscript(index: Int) -> [Element]{
        let indexBase = index * columnCount
        let indexEnd = (index + 1) * columnCount
        return Array(elements[indexBase..<indexEnd])
    }

}

extension Matrix: ExpressibleByArrayLiteral{
    public init(arrayLiteral elements: Element...) {
        self.elements = elements
        self.rowCount = self.elements.count
        self.columnCount = 1
    }
}

// MARK: - AdditiveArithmetic

public extension Matrix where Element: AdditiveArithmetic{
    static func add(_ matrixA: Self, _ matrixB: Self) -> Self?{
        guard matrixA.rowCount == matrixB.rowCount && matrixA.columnCount == matrixB.columnCount else{
            return nil
        }
        return Self(elements: Vector<Element>.add(matrixA.elements, matrixB.elements), rowCount: matrixA.rowCount, columnCount: matrixA.columnCount)
    }
    static func subtract(_ matrixA: Self, _ matrixB: Self) -> Self?{
        guard matrixA.rowCount == matrixB.rowCount && matrixA.columnCount == matrixB.columnCount else{
            return nil
        }
        return Self(elements: Vector.subtract(matrixA.elements, matrixB.elements), rowCount: matrixA.rowCount, columnCount: matrixA.columnCount)
    }
}

public extension Matrix where Element == Float{
    static func add(_ matrixA: Self, _ matrixB: Self) -> Self?{
        guard matrixA.rowCount == matrixB.rowCount && matrixA.columnCount == matrixB.columnCount else{
            return nil
        }
        return Self(elements: Vector<Element>.add(matrixA.elements, matrixB.elements), rowCount: matrixA.rowCount, columnCount: matrixA.columnCount)
    }
    static func subtract(_ matrixA: Self, _ matrixB: Self) -> Self?{
        guard matrixA.rowCount == matrixB.rowCount && matrixA.columnCount == matrixB.columnCount else{
            return nil
        }
        return Self(elements: Vector.subtract(matrixA.elements, matrixB.elements), rowCount: matrixA.rowCount, columnCount: matrixA.columnCount)
    }
}
public extension Matrix where Element == Double{
    static func add(_ matrixA: Self, _ matrixB: Self) -> Self?{
        guard matrixA.rowCount == matrixB.rowCount && matrixA.columnCount == matrixB.columnCount else{
            return nil
        }
        return Self(elements: Vector<Element>.add(matrixA.elements, matrixB.elements), rowCount: matrixA.rowCount, columnCount: matrixA.columnCount)
    }
    static func subtract(_ matrixA: Self, _ matrixB: Self) -> Self?{
        guard matrixA.rowCount == matrixB.rowCount && matrixA.columnCount == matrixB.columnCount else{
            return nil
        }
        return Self(elements: Vector.subtract(matrixA.elements, matrixB.elements), rowCount: matrixA.rowCount, columnCount: matrixA.columnCount)
    }
}
public extension Matrix where Element == Complex<Float>{
    static func add(_ matrixA: Self, _ matrixB: Self) -> Self?{
        guard matrixA.rowCount == matrixB.rowCount && matrixA.columnCount == matrixB.columnCount else{
            return nil
        }
        return Self(elements: Vector<Element>.add(matrixA.elements, matrixB.elements), rowCount: matrixA.rowCount, columnCount: matrixA.columnCount)
    }
    static func subtract(_ matrixA: Self, _ matrixB: Self) -> Self?{
        guard matrixA.rowCount == matrixB.rowCount && matrixA.columnCount == matrixB.columnCount else{
            return nil
        }
        return Self(elements: Vector.subtract(matrixA.elements, matrixB.elements), rowCount: matrixA.rowCount, columnCount: matrixA.columnCount)
    }
}
public extension Matrix where Element == Complex<Double>{
    static func add(_ matrixA: Self, _ matrixB: Self) -> Self?{
        guard matrixA.rowCount == matrixB.rowCount && matrixA.columnCount == matrixB.columnCount else{
            return nil
        }
        return Self(elements: Vector<Element>.add(matrixA.elements, matrixB.elements), rowCount: matrixA.rowCount, columnCount: matrixA.columnCount)
    }
    static func subtract(_ matrixA: Self, _ matrixB: Self) -> Self?{
        guard matrixA.rowCount == matrixB.rowCount && matrixA.columnCount == matrixB.columnCount else{
            return nil
        }
        return Self(elements: Vector.subtract(matrixA.elements, matrixB.elements), rowCount: matrixA.rowCount, columnCount: matrixA.columnCount)
    }
}
public extension Matrix where Element == DSPComplex{
    static func add(_ matrixA: Self, _ matrixB: Self) -> Self?{
        guard matrixA.rowCount == matrixB.rowCount && matrixA.columnCount == matrixB.columnCount else{
            return nil
        }
        return Self(elements: Vector<Element>.add(matrixA.elements, matrixB.elements), rowCount: matrixA.rowCount, columnCount: matrixA.columnCount)
    }
    static func subtract(_ matrixA: Self, _ matrixB: Self) -> Self?{
        guard matrixA.rowCount == matrixB.rowCount && matrixA.columnCount == matrixB.columnCount else{
            return nil
        }
        return Self(elements: Vector.subtract(matrixA.elements, matrixB.elements), rowCount: matrixA.rowCount, columnCount: matrixA.columnCount)
    }
}
public extension Matrix where Element == DSPDoubleComplex{
    static func add(_ matrixA: Self, _ matrixB: Self) -> Self?{
        guard matrixA.rowCount == matrixB.rowCount && matrixA.columnCount == matrixB.columnCount else{
            return nil
        }
        return Self(elements: Vector<Element>.add(matrixA.elements, matrixB.elements), rowCount: matrixA.rowCount, columnCount: matrixA.columnCount)
    }
    static func subtract(_ matrixA: Self, _ matrixB: Self) -> Self?{
        guard matrixA.rowCount == matrixB.rowCount && matrixA.columnCount == matrixB.columnCount else{
            return nil
        }
        return Self(elements: Vector.subtract(matrixA.elements, matrixB.elements), rowCount: matrixA.rowCount, columnCount: matrixA.columnCount)
    }
}

// MARK: - Transpose

extension Matrix{
    public var transpose: Self{
        let arrayCount = rowCount * columnCount
        let array = [Element](unsafeUninitializedCapacity: arrayCount) { buffer, initializedCount in
            for i in 0..<rowCount{
                for j in 0..<columnCount{
                    (buffer.baseAddress! + j * rowCount + i).initialize(to: elements[i * columnCount + j])
                }
            }
            initializedCount = arrayCount
        }
        return Self(elements: array, rowCount: columnCount, columnCount: rowCount)!
    }
}

public extension Matrix where Element == Float{
    var transpose: Self{
        let count = rowCount * columnCount
        let array = [Element](unsafeUninitializedCapacity: count) { buffer, initializedCount in
            guard let ptr = buffer.baseAddress else{
                return
            }
            vDSP_mtrans(elements, 1, ptr, 1, vDSP_Length(rowCount), vDSP_Length(columnCount))
            initializedCount = count
        }
        return Self(elements: array, rowCount: columnCount, columnCount: rowCount)! // suppose empty matrix is not possible.
    }
}
public extension Matrix where Element == Double{
    var transpose: Self{
        let count = rowCount * columnCount
        let array = [Element](unsafeUninitializedCapacity: count) { buffer, initializedCount in
            guard let ptr = buffer.baseAddress else{
                return
            }
            vDSP_mtransD(elements, 1, ptr, 1, vDSP_Length(rowCount), vDSP_Length(columnCount))
            initializedCount = count
        }
        return Self(elements: array, rowCount: columnCount, columnCount: rowCount)! // suppose empty matrix is not possible.
    }
}
extension Matrix where Element: GenericComplex, Element.Real == Float{
    var _transpose: Self{
        let count = rowCount * columnCount
        let array = [Element](unsafeUninitializedCapacity: count) { buffer, initializedCount in
            buffer.withDSPSplitComplex { osplitComplex in
                self.elements.withDSPSplitComplex { isplitComplex in
                    vDSP_mtrans(isplitComplex.realp, 2, osplitComplex.realp, 2, vDSP_Length(rowCount), vDSP_Length(columnCount))
                    vDSP_mtrans(isplitComplex.imagp, 2, osplitComplex.imagp, 2, vDSP_Length(rowCount), vDSP_Length(columnCount))
                }
            }
            initializedCount = count
        }
        return Self(elements: array, rowCount: columnCount, columnCount: rowCount)! // suppose empty matrix is not possible.
    }
}
extension Matrix where Element: GenericComplex, Element.Real == Double{
    var _transpose: Self{
        let count = rowCount * columnCount
        let array = [Element](unsafeUninitializedCapacity: count) { buffer, initializedCount in
            buffer.withDSPDoubleSplitComplex { osplitComplex in
                self.elements.withDSPDoubleSplitComplex { isplitComplex in
                    vDSP_mtransD(isplitComplex.realp, 2, osplitComplex.realp, 2, vDSP_Length(rowCount), vDSP_Length(columnCount))
                    vDSP_mtransD(isplitComplex.imagp, 2, osplitComplex.imagp, 2, vDSP_Length(rowCount), vDSP_Length(columnCount))
                }
            }
            initializedCount = count
        }
        return Self(elements: array, rowCount: columnCount, columnCount: rowCount)! // suppose empty matrix is not possible.
    }
}
public extension Matrix where Element == Complex<Float>{
    var transpose: Self { _transpose }
}
public extension Matrix where Element == Complex<Double>{
    var transpose: Self { _transpose }
}
public extension Matrix where Element == DSPComplex{
    var transpose: Self { _transpose }
}
public extension Matrix where Element == DSPDoubleComplex{
    var transpose: Self { _transpose }
}

// MARK: - Multiplication

extension Matrix where Element: Numeric{
    public static func multiply(_ matrixA: Matrix<Element>, _ matrixB: Matrix<Element>) -> Matrix<Element>? {
        guard matrixA.columnCount == matrixB.rowCount else{
            return nil
        }
        var array = [Element](repeating: .zero, count: matrixA.rowCount * matrixB.columnCount)
        for i in 0..<matrixA.rowCount{
            for j in 0..<matrixB.columnCount{
                for k in 0..<matrixA.columnCount{
                    array[i * matrixB.columnCount + j] += matrixA.elements[i * matrixA.columnCount + k] * matrixB.elements[k * matrixB.columnCount + j]
                }
            }
        }
        return Self(elements: array, rowCount: matrixA.rowCount, columnCount: matrixB.columnCount)!
    }
}

public extension Matrix where Element == Float{
    static func multiply(_ matrixA: Matrix<Float>, _ matrixB: Matrix<Float>) -> Matrix<Float>? {
        guard matrixA.columnCount == matrixB.rowCount else{
            return nil
        }
        let outCount = matrixA.rowCount * matrixB.columnCount
        let array = [Element](unsafeUninitializedCapacity: outCount) { buffer, initializedCount in
            guard let ptr = buffer.baseAddress else{
                return
            }
            vDSP_mmul(matrixA.elements, 1, matrixB.elements, 1, ptr, 1, vDSP_Length(matrixA.rowCount), vDSP_Length(matrixB.columnCount), vDSP_Length(matrixA.columnCount))
            initializedCount = outCount
        }
        return Self(elements: array, rowCount: matrixA.rowCount, columnCount: matrixB.columnCount)!
    }
}

extension Matrix where Element == Double{
    public static func multiply(_ matrixA: Matrix<Double>, _ matrixB: Matrix<Double>) -> Matrix<Double>? {
        guard matrixA.columnCount == matrixB.rowCount else{
            return nil
        }
        let outCount = matrixA.rowCount * matrixB.columnCount
        let array = [Double](unsafeUninitializedCapacity: outCount) { buffer, initializedCount in
            guard let ptr = buffer.baseAddress else{
                return
            }
            vDSP_mmulD(matrixA.elements, 1, matrixB.elements, 1, ptr, 1, vDSP_Length(matrixA.rowCount), vDSP_Length(matrixB.columnCount), vDSP_Length(matrixA.columnCount))
            initializedCount = outCount
        }
        return Matrix<Double>(elements: array, rowCount: matrixA.rowCount, columnCount: matrixB.columnCount)!
    }
}

extension Matrix where Element: GenericComplex, Element.Real == Float{
    static func _multiply(_ matrixA: Self, _ matrixB: Self) -> Self? {
        guard matrixA.columnCount == matrixB.rowCount else{
            return nil
        }
        let outCount = matrixA.rowCount * matrixB.columnCount
        let array = [Element](unsafeUninitializedCapacity: outCount) { buffer, initializedCount in
            buffer.withDSPSplitComplexMutablePointer { oSplitPtr in
                matrixA.elements.withDSPSplitComplexPointer { ptrA in
                    matrixB.elements.withDSPSplitComplexPointer { ptrB in
                        vDSP_zmmul(ptrA, 2, ptrB, 2, oSplitPtr, 2, vDSP_Length(matrixA.rowCount), vDSP_Length(matrixB.columnCount), vDSP_Length(matrixA.columnCount))
                    }
                }
            }
            initializedCount = outCount
        }
        return Self(elements: array, rowCount: matrixA.rowCount, columnCount: matrixB.columnCount)!
    }
}

extension Matrix where Element: GenericComplex, Element.Real == Double{
    static func _multiply(_ matrixA: Self, _ matrixB: Self) -> Self? {
        guard matrixA.columnCount == matrixB.rowCount else{
            return nil
        }
        let outCount = matrixA.rowCount * matrixB.columnCount
        let array = [Element](unsafeUninitializedCapacity: outCount) { buffer, initializedCount in
            buffer.withDSPDoubleSplitComplexMutablePointer { oSplitPtr in
                matrixA.elements.withDSPDoubleSplitComplexPointer { ptrA in
                    matrixB.elements.withDSPDoubleSplitComplexPointer { ptrB in
                        vDSP_zmmulD(ptrA, 2, ptrB, 2, oSplitPtr, 2, vDSP_Length(matrixA.rowCount), vDSP_Length(matrixB.columnCount), vDSP_Length(matrixA.columnCount))
                    }
                }
            }
            initializedCount = outCount
        }
        return Self(elements: array, rowCount: matrixA.rowCount, columnCount: matrixB.columnCount)!
    }
}

public extension Matrix where Element == Complex<Float>{
    static func multiply(_ matrixA: Self, _ matrixB: Self) -> Self? {
        return _multiply(matrixA, matrixB)
    }
}

public extension Matrix where Element == DSPComplex{
    static func multiply(_ matrixA: Self, _ matrixB: Self) -> Self? {
        return _multiply(matrixA, matrixB)
    }
}

public extension Matrix where Element == Complex<Double>{
    static func multiply(_ matrixA: Self, _ matrixB: Self) -> Self? {
        return _multiply(matrixA, matrixB)
    }
}

public extension Matrix where Element == DSPDoubleComplex{
    static func multiply(_ matrixA: Self, _ matrixB: Self) -> Self? {
        return _multiply(matrixA, matrixB)
    }
}