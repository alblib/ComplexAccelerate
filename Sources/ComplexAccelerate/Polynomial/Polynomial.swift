//
//  Polynomial.swift
//  
//
//  Created by Albertus Liberius on 2023-01-13.
//

import Foundation
import Accelerate

public struct Polynomial<Coefficient>: ExpressibleByArrayLiteral
{
    public var coefficients: [Coefficient]
    public init() {
        self.coefficients = []
    }
    public init(coefficients: [Coefficient]) {
        self.coefficients = coefficients
    }
    public init(arrayLiteral elements: Coefficient...) {
        self.coefficients = elements
    }
}

// MARK: - Equatable

extension Polynomial: Equatable where Coefficient: Equatable {
    public static func == (_ lhs: Self, _ rhs: Self) -> Bool {
        lhs.coefficients == rhs.coefficients
    }
}

// MARK: - AdditiveArithmetic

extension Polynomial: AdditiveArithmetic where Coefficient: AdditiveArithmetic
{
    public static func == (_ lhs: Self, _ rhs: Self) -> Bool {
        if lhs.coefficients.count == rhs.coefficients.count{
            return lhs.coefficients == rhs.coefficients
        }else if lhs.coefficients.count > rhs.coefficients.count{
            if lhs.coefficients[0..<rhs.coefficients.count].elementsEqual(rhs.coefficients){
                return lhs.coefficients[rhs.coefficients.count..<lhs.coefficients.count].allSatisfy { $0 == .zero }
            }else{
                return false
            }
        }else{
            if rhs.coefficients[0..<lhs.coefficients.count].elementsEqual(lhs.coefficients){
                return rhs.coefficients[lhs.coefficients.count..<rhs.coefficients.count].allSatisfy { $0 == .zero }
            }else{
                return false
            }
        }
    }
    
    public static func + (_ lhs: Self, _ rhs: Self) -> Self
    {
        var result = Vector.add(lhs.coefficients, rhs.coefficients)
        if lhs.coefficients.count > rhs.coefficients.count{
            result += lhs.coefficients[rhs.coefficients.count..<lhs.coefficients.count]
        }else if rhs.coefficients.count > lhs.coefficients.count{
            result += rhs.coefficients[lhs.coefficients.count..<rhs.coefficients.count]
        }
        return Polynomial(coefficients: result)
    }
    public static func - (_ lhs: Self, _ rhs: Self) -> Self
    {
        var result = Vector.subtract(lhs.coefficients, rhs.coefficients)
        if lhs.coefficients.count > rhs.coefficients.count{
            result += lhs.coefficients[rhs.coefficients.count..<lhs.coefficients.count]
        }else if rhs.coefficients.count > lhs.coefficients.count{
            result += Vector.subtract(Vector<Coefficient>.zeros(count: rhs.coefficients.count - lhs.coefficients.count), rhs.coefficients[lhs.coefficients.count..<rhs.coefficients.count])
        }
        return Polynomial(coefficients: result)
    }
    public static var zero: Self{
        return Self()
    }
}

extension Polynomial where Coefficient == Float
{
    public static func + (_ lhs: Self, _ rhs: Self) -> Self
    {
        var result = Vector.add(lhs.coefficients, rhs.coefficients)
        if lhs.coefficients.count > rhs.coefficients.count{
            result += lhs.coefficients[rhs.coefficients.count..<lhs.coefficients.count]
        }else if rhs.coefficients.count > lhs.coefficients.count{
            result += rhs.coefficients[lhs.coefficients.count..<rhs.coefficients.count]
        }
        return Polynomial(coefficients: result)
    }
    public static func - (_ lhs: Self, _ rhs: Self) -> Self
    {
        var result = Vector.subtract(lhs.coefficients, rhs.coefficients)
        if lhs.coefficients.count > rhs.coefficients.count{
            result += lhs.coefficients[rhs.coefficients.count..<lhs.coefficients.count]
        }else if rhs.coefficients.count > lhs.coefficients.count{
            result += Vector.subtract(Vector<Coefficient>.zeros(count: rhs.coefficients.count - lhs.coefficients.count), rhs.coefficients[lhs.coefficients.count..<rhs.coefficients.count])
        }
        return Polynomial(coefficients: result)
    }
}

extension Polynomial where Coefficient == Double
{
    public static func + (_ lhs: Self, _ rhs: Self) -> Self
    {
        var result = Vector.add(lhs.coefficients, rhs.coefficients)
        if lhs.coefficients.count > rhs.coefficients.count{
            result += lhs.coefficients[rhs.coefficients.count..<lhs.coefficients.count]
        }else if rhs.coefficients.count > lhs.coefficients.count{
            result += rhs.coefficients[lhs.coefficients.count..<rhs.coefficients.count]
        }
        return Polynomial(coefficients: result)
    }
    public static func - (_ lhs: Self, _ rhs: Self) -> Self
    {
        var result = Vector.subtract(lhs.coefficients, rhs.coefficients)
        if lhs.coefficients.count > rhs.coefficients.count{
            result += lhs.coefficients[rhs.coefficients.count..<lhs.coefficients.count]
        }else if rhs.coefficients.count > lhs.coefficients.count{
            result += Vector.subtract(Vector<Coefficient>.zeros(count: rhs.coefficients.count - lhs.coefficients.count), rhs.coefficients[lhs.coefficients.count..<rhs.coefficients.count])
        }
        return Polynomial(coefficients: result)
    }
}

extension Polynomial where Coefficient == Complex<Float>
{
    public static func + (_ lhs: Self, _ rhs: Self) -> Self
    {
        var result = Vector.add(lhs.coefficients, rhs.coefficients)
        if lhs.coefficients.count > rhs.coefficients.count{
            result += lhs.coefficients[rhs.coefficients.count..<lhs.coefficients.count]
        }else if rhs.coefficients.count > lhs.coefficients.count{
            result += rhs.coefficients[lhs.coefficients.count..<rhs.coefficients.count]
        }
        return Polynomial(coefficients: result)
    }
    public static func - (_ lhs: Self, _ rhs: Self) -> Self
    {
        var result = Vector.subtract(lhs.coefficients, rhs.coefficients)
        if lhs.coefficients.count > rhs.coefficients.count{
            result += lhs.coefficients[rhs.coefficients.count..<lhs.coefficients.count]
        }else if rhs.coefficients.count > lhs.coefficients.count{
            result += Vector.subtract(Vector<Coefficient>.zeros(count: rhs.coefficients.count - lhs.coefficients.count), rhs.coefficients[lhs.coefficients.count..<rhs.coefficients.count])
        }
        return Polynomial(coefficients: result)
    }
}

extension Polynomial where Coefficient == Complex<Double>
{
    public static func + (_ lhs: Self, _ rhs: Self) -> Self
    {
        var result = Vector.add(lhs.coefficients, rhs.coefficients)
        if lhs.coefficients.count > rhs.coefficients.count{
            result += lhs.coefficients[rhs.coefficients.count..<lhs.coefficients.count]
        }else if rhs.coefficients.count > lhs.coefficients.count{
            result += rhs.coefficients[lhs.coefficients.count..<rhs.coefficients.count]
        }
        return Polynomial(coefficients: result)
    }
    public static func - (_ lhs: Self, _ rhs: Self) -> Self
    {
        var result = Vector.subtract(lhs.coefficients, rhs.coefficients)
        if lhs.coefficients.count > rhs.coefficients.count{
            result += lhs.coefficients[rhs.coefficients.count..<lhs.coefficients.count]
        }else if rhs.coefficients.count > lhs.coefficients.count{
            result += Vector.subtract(Vector<Coefficient>.zeros(count: rhs.coefficients.count - lhs.coefficients.count), rhs.coefficients[lhs.coefficients.count..<rhs.coefficients.count])
        }
        return Polynomial(coefficients: result)
    }
}

extension Polynomial where Coefficient == DSPComplex
{
    public static func + (_ lhs: Self, _ rhs: Self) -> Self
    {
        var result = Vector.add(lhs.coefficients, rhs.coefficients)
        if lhs.coefficients.count > rhs.coefficients.count{
            result += lhs.coefficients[rhs.coefficients.count..<lhs.coefficients.count]
        }else if rhs.coefficients.count > lhs.coefficients.count{
            result += rhs.coefficients[lhs.coefficients.count..<rhs.coefficients.count]
        }
        return Polynomial(coefficients: result)
    }
    public static func - (_ lhs: Self, _ rhs: Self) -> Self
    {
        var result = Vector.subtract(lhs.coefficients, rhs.coefficients)
        if lhs.coefficients.count > rhs.coefficients.count{
            result += lhs.coefficients[rhs.coefficients.count..<lhs.coefficients.count]
        }else if rhs.coefficients.count > lhs.coefficients.count{
            result += Vector.subtract(Vector<Coefficient>.zeros(count: rhs.coefficients.count - lhs.coefficients.count), rhs.coefficients[lhs.coefficients.count..<rhs.coefficients.count])
        }
        return Polynomial(coefficients: result)
    }
}

extension Polynomial where Coefficient == DSPDoubleComplex
{
    public static func + (_ lhs: Self, _ rhs: Self) -> Self
    {
        var result = Vector.add(lhs.coefficients, rhs.coefficients)
        if lhs.coefficients.count > rhs.coefficients.count{
            result += lhs.coefficients[rhs.coefficients.count..<lhs.coefficients.count]
        }else if rhs.coefficients.count > lhs.coefficients.count{
            result += rhs.coefficients[lhs.coefficients.count..<rhs.coefficients.count]
        }
        return Polynomial(coefficients: result)
    }
    public static func - (_ lhs: Self, _ rhs: Self) -> Self
    {
        var result = Vector.subtract(lhs.coefficients, rhs.coefficients)
        if lhs.coefficients.count > rhs.coefficients.count{
            result += lhs.coefficients[rhs.coefficients.count..<lhs.coefficients.count]
        }else if rhs.coefficients.count > lhs.coefficients.count{
            result += Vector.subtract(Vector<Coefficient>.zeros(count: rhs.coefficients.count - lhs.coefficients.count), rhs.coefficients[lhs.coefficients.count..<rhs.coefficients.count])
        }
        return Polynomial(coefficients: result)
    }
}

// MARK: - Multiplication
extension Polynomial where Coefficient == Float{
    public static func * (_ lhs: Self, _ rhs: Self) -> Self
    {
        if lhs.coefficients.isEmpty || rhs.coefficients.isEmpty{
            return Self(coefficients: [])
        }
        if lhs.coefficients.count < rhs.coefficients.count{
            return rhs * lhs
        }
        // lhs is long
        let zeros = Vector<Float>.zeros(count: rhs.coefficients.count)
        let resultCount = lhs.coefficients.count + rhs.coefficients.count - 1
        let matrixArrayCount = resultCount * rhs.coefficients.count
        var lhsMatrixArray = lhs.coefficients
        lhsMatrixArray.reserveCapacity(matrixArrayCount)
        for _ in 0..<(rhs.coefficients.count-1){
            lhsMatrixArray.append(contentsOf: zeros)
            lhsMatrixArray.append(contentsOf: lhs.coefficients)
        }
        let lhsMatrix = Matrix(elements: lhsMatrixArray, rowCount: rhs.coefficients.count, columnCount: resultCount)!
        let rhsMatrix = Matrix(elements: rhs.coefficients, rowCount: 1, columnCount: rhs.coefficients.count)!
        let resultMatrix = Matrix.multiply(rhsMatrix, lhsMatrix)!
        return Self(coefficients: resultMatrix.elements)
    }
}

extension Polynomial where Coefficient == Double{
    public static func * (_ lhs: Self, _ rhs: Self) -> Self
    {
        if lhs.coefficients.isEmpty || rhs.coefficients.isEmpty{
            return Self(coefficients: [])
        }
        if lhs.coefficients.count < rhs.coefficients.count{
            return rhs * lhs
        }
        // lhs is long
        let zeros = Vector<Double>.zeros(count: rhs.coefficients.count)
        let resultCount = lhs.coefficients.count + rhs.coefficients.count - 1
        let matrixArrayCount = resultCount * rhs.coefficients.count
        var lhsMatrixArray = lhs.coefficients
        lhsMatrixArray.reserveCapacity(matrixArrayCount)
        for _ in 0..<(rhs.coefficients.count-1){
            lhsMatrixArray.append(contentsOf: zeros)
            lhsMatrixArray.append(contentsOf: lhs.coefficients)
        }
        let lhsMatrix = Matrix(elements: lhsMatrixArray, rowCount: rhs.coefficients.count, columnCount: resultCount)!
        let rhsMatrix = Matrix(elements: rhs.coefficients, rowCount: 1, columnCount: rhs.coefficients.count)!
        let resultMatrix = Matrix.multiply(rhsMatrix, lhsMatrix)!
        return Self(coefficients: resultMatrix.elements)
    }
}

extension Polynomial where Coefficient: GenericComplex, Coefficient.Real == Float{
    static func _mul (_ lhs: Self, _ rhs: Self) -> Self
    {
        if lhs.coefficients.isEmpty || rhs.coefficients.isEmpty{
            return Self(coefficients: [])
        }
        if lhs.coefficients.count < rhs.coefficients.count{
            return _mul(rhs, lhs)
        }
        // lhs is long
        let zeros = Vector<Coefficient>._zeros(count: rhs.coefficients.count)
        let resultCount = lhs.coefficients.count + rhs.coefficients.count - 1
        let matrixArrayCount = resultCount * rhs.coefficients.count
        var lhsMatrixArray = lhs.coefficients
        lhsMatrixArray.reserveCapacity(matrixArrayCount)
        for _ in 0..<(rhs.coefficients.count-1){
            lhsMatrixArray.append(contentsOf: zeros)
            lhsMatrixArray.append(contentsOf: lhs.coefficients)
        }
        let lhsMatrix = Matrix(elements: lhsMatrixArray, rowCount: rhs.coefficients.count, columnCount: resultCount)!
        let rhsMatrix = Matrix(elements: rhs.coefficients, rowCount: 1, columnCount: rhs.coefficients.count)!
        let resultMatrix = Matrix<Coefficient>._multiply(rhsMatrix, lhsMatrix)!
        return Self(coefficients: resultMatrix.elements)
    }
}

extension Polynomial where Coefficient: GenericComplex, Coefficient.Real == Double{
    static func _mul (_ lhs: Self, _ rhs: Self) -> Self
    {
        if lhs.coefficients.isEmpty || rhs.coefficients.isEmpty{
            return Self(coefficients: [])
        }
        if lhs.coefficients.count < rhs.coefficients.count{
            return _mul(rhs, lhs)
        }
        // lhs is long
        let zeros = Vector<Coefficient>._zeros(count: rhs.coefficients.count)
        let resultCount = lhs.coefficients.count + rhs.coefficients.count - 1
        let matrixArrayCount = resultCount * rhs.coefficients.count
        var lhsMatrixArray = lhs.coefficients
        lhsMatrixArray.reserveCapacity(matrixArrayCount)
        for _ in 0..<(rhs.coefficients.count-1){
            lhsMatrixArray.append(contentsOf: zeros)
            lhsMatrixArray.append(contentsOf: lhs.coefficients)
        }
        let lhsMatrix = Matrix(elements: lhsMatrixArray, rowCount: rhs.coefficients.count, columnCount: resultCount)!
        let rhsMatrix = Matrix(elements: rhs.coefficients, rowCount: 1, columnCount: rhs.coefficients.count)!
        let resultMatrix = Matrix<Coefficient>._multiply(rhsMatrix, lhsMatrix)!
        return Self(coefficients: resultMatrix.elements)
    }
}

extension Polynomial where Coefficient == Complex<Float>{
    public static func * (_ lhs: Self, _ rhs: Self) -> Self{
        _mul(lhs,rhs)
    }
}
extension Polynomial where Coefficient == Complex<Double>{
    public static func * (_ lhs: Self, _ rhs: Self) -> Self{
        _mul(lhs,rhs)
    }
}
extension Polynomial where Coefficient == DSPComplex{
    public static func * (_ lhs: Self, _ rhs: Self) -> Self{
        _mul(lhs,rhs)
    }
}
extension Polynomial where Coefficient == DSPDoubleComplex{
    public static func * (_ lhs: Self, _ rhs: Self) -> Self{
        _mul(lhs,rhs)
    }
}


// MARK: - Appliable

extension Polynomial where Coefficient == Float{
    public func evaluate(variable x: Float) -> Float{
        evaluate(variables: [x])[0]
    }
    public func evaluate(variables xArray: [Float]) -> [Float]
    {
        if coefficients.isEmpty{
            return Vector<Float>.zeros(count: xArray.count)
        }
        return [Float](unsafeUninitializedCapacity: xArray.count) { buffer, initializedCount in
            guard let oPtr = buffer.baseAddress else{
                return
            }
            coefficients.withUnsafeBufferPointer { coeffBuffer in
                let iPtr = coeffBuffer.baseAddress! + coeffBuffer.count - 1
                vDSP_vpoly(iPtr, -1, xArray, 1, oPtr, 1, vDSP_Length(xArray.count), vDSP_Length(coefficients.count - 1))
                
            }
            initializedCount = xArray.count
        }
    }
    func _evaluate<ComplexArray, RComplex>(variables zArray: ComplexArray) -> [RComplex]
    where ComplexArray: AccelerateBuffer, ComplexArray.Element == RComplex,
          RComplex: GenericComplex, RComplex.Real == Float
    {
        if zArray.count <= 0 {
            return []
        }
        if coefficients.isEmpty{
            return Vector<RComplex>._zeros(count: zArray.count)
        }
        let coefficientMatrix = Matrix(elements: Vector<RComplex>._castToComplexes(coefficients), rowCount: 1, columnCount: coefficients.count)!
        let realExponentArray: [RComplex.Real] = vDSP.ramp(in: 0...Float((coefficients.count-1)), count: coefficients.count)
        let cmplxExponentArray: [RComplex] = Vector<RComplex>._castToComplexes(realExponentArray)
        let exponents = Matrix<RComplex>(elements: cmplxExponentArray, rowCount: coefficients.count, columnCount: 1)!
        let zLogArray: [RComplex] = Vector<RComplex>._log(zArray)
        let zLogMatrix = Matrix<RComplex>(elements: zLogArray, rowCount: 1, columnCount: zArray.count)!
        let zLogExponentMatrix = Matrix<RComplex>._multiply(exponents, zLogMatrix)!
        let zMatrix = Matrix<RComplex>(elements: Vector<RComplex>._exp(zLogExponentMatrix.elements), rowCount: coefficients.count, columnCount: zArray.count)!
        let results = Matrix<RComplex>._multiply(coefficientMatrix, zMatrix)!
        return results.elements
    }
    public func evaluate<ComplexArray>(variables zArray: ComplexArray) -> [DSPComplex]
    where ComplexArray: AccelerateBuffer, ComplexArray.Element == DSPComplex
    {
        _evaluate(variables: zArray)
    }
    public func evaluate<ComplexArray>(variables zArray: ComplexArray) -> [Complex<Float>]
    where ComplexArray: AccelerateBuffer, ComplexArray.Element == Complex<Float>
    {
        _evaluate(variables: zArray)
    }
    public func evaluate(variable z: DSPComplex) -> DSPComplex{
        _evaluate(variables: [z])[0]
    }
    public func evaluate(variable z: Complex<Float>) -> Complex<Float>{
        _evaluate(variables: [z])[0]
    }
}

extension Polynomial where Coefficient == Double{
    public func evaluate(variable x: Double) -> Double{
        evaluate(variables: [x])[0]
    }
    public func evaluate(variables xArray: [Double]) -> [Double]
    {
        if coefficients.isEmpty{
            return Vector<Double>.zeros(count: xArray.count)
        }
        return [Double](unsafeUninitializedCapacity: xArray.count) { buffer, initializedCount in
            guard let oPtr = buffer.baseAddress else{
                return
            }
            coefficients.withUnsafeBufferPointer { coeffBuffer in
                let iPtr = coeffBuffer.baseAddress! + coeffBuffer.count - 1
                vDSP_vpolyD(iPtr, -1, xArray, 1, oPtr, 1, vDSP_Length(xArray.count), vDSP_Length(coefficients.count - 1))
                
            }
            initializedCount = xArray.count
        }
    }
    func _evaluate<ComplexArray, RComplex>(variables zArray: ComplexArray) -> [RComplex]
    where ComplexArray: AccelerateBuffer, ComplexArray.Element == RComplex,
          RComplex: GenericComplex, RComplex.Real == Double
    {
        if zArray.count <= 0 {
            return []
        }
        if coefficients.isEmpty{
            return Vector<RComplex>._zeros(count: zArray.count)
        }
        let coefficientMatrix = Matrix(elements: Vector<RComplex>._castToComplexes(coefficients), rowCount: 1, columnCount: coefficients.count)!
        let realExponentArray: [RComplex.Real] = vDSP.ramp(in: 0...Double((coefficients.count-1)), count: coefficients.count)
        let cmplxExponentArray: [RComplex] = Vector<RComplex>._castToComplexes(realExponentArray)
        let exponents = Matrix<RComplex>(elements: cmplxExponentArray, rowCount: coefficients.count, columnCount: 1)!
        let zLogArray: [RComplex] = Vector<RComplex>._log(zArray)
        let zLogMatrix = Matrix<RComplex>(elements: zLogArray, rowCount: 1, columnCount: zArray.count)!
        let zLogExponentMatrix = Matrix<RComplex>._multiply(exponents, zLogMatrix)!
        let zMatrix = Matrix<RComplex>(elements: Vector<RComplex>._exp(zLogExponentMatrix.elements), rowCount: coefficients.count, columnCount: zArray.count)!
        let results = Matrix<RComplex>._multiply(coefficientMatrix, zMatrix)!
        return results.elements
    }
    public func evaluate<ComplexArray>(variables zArray: ComplexArray) -> [DSPDoubleComplex]
    where ComplexArray: AccelerateBuffer, ComplexArray.Element == DSPDoubleComplex
    {
        _evaluate(variables: zArray)
    }
    public func evaluate<ComplexArray>(variables zArray: ComplexArray) -> [Complex<Double>]
    where ComplexArray: AccelerateBuffer, ComplexArray.Element == Complex<Double>
    {
        _evaluate(variables: zArray)
    }
    public func evaluate(variable z: DSPDoubleComplex) -> DSPDoubleComplex{
        _evaluate(variables: [z])[0]
    }
    public func evaluate(variable z: Complex<Double>) -> Complex<Double>{
        _evaluate(variables: [z])[0]
    }
}

extension Polynomial where Coefficient: GenericComplex, Coefficient.Real == Float{
    func _evaluate<ComplexArray>(variables zArray: ComplexArray) -> [Coefficient]
    where ComplexArray: AccelerateBuffer, ComplexArray.Element == Coefficient
    {
        if zArray.count <= 0 {
            return []
        }
        if coefficients.isEmpty{
            return Vector<Coefficient>._zeros(count: zArray.count)
        }
        let coefficientMatrix = Matrix(elements: coefficients, rowCount: 1, columnCount: coefficients.count)!
        let exponentArray: [Coefficient] = Vector<Coefficient>._ramp(begin: .init(real: 0, imag: 0), increment: .init(real: 1, imag: 0), count: coefficients.count)
        let exponents = Matrix<Coefficient>(elements: exponentArray, rowCount: coefficients.count, columnCount: 1)!
        let zLogArray: [Coefficient] = Vector<Coefficient>._log(zArray)
        let zLogMatrix = Matrix<Coefficient>(elements: zLogArray, rowCount: 1, columnCount: zArray.count)!
        let zLogExponentMatrix = Matrix<Coefficient>._multiply(exponents, zLogMatrix)!
        let zMatrix = Matrix<Coefficient>(elements: Vector<Coefficient>._exp(zLogExponentMatrix.elements), rowCount: coefficients.count, columnCount: zArray.count)!
        let results = Matrix<Coefficient>._multiply(coefficientMatrix, zMatrix)!
        return results.elements
    }
}

extension Polynomial where Coefficient: GenericComplex, Coefficient.Real == Double{
    func _evaluate<ComplexArray>(variables zArray: ComplexArray) -> [Coefficient]
    where ComplexArray: AccelerateBuffer, ComplexArray.Element == Coefficient
    {
        if zArray.count <= 0 {
            return []
        }
        if coefficients.isEmpty{
            return Vector<Coefficient>._zeros(count: zArray.count)
        }
        let coefficientMatrix = Matrix(elements: coefficients, rowCount: 1, columnCount: coefficients.count)!
        let exponentArray: [Coefficient] = Vector<Coefficient>._ramp(begin: .init(real: 0, imag: 0), increment: .init(real: 1, imag: 0), count: coefficients.count)
        let exponents = Matrix<Coefficient>(elements: exponentArray, rowCount: coefficients.count, columnCount: 1)!
        let zLogArray: [Coefficient] = Vector<Coefficient>._log(zArray)
        let zLogMatrix = Matrix<Coefficient>(elements: zLogArray, rowCount: 1, columnCount: zArray.count)!
        let zLogExponentMatrix = Matrix<Coefficient>._multiply(exponents, zLogMatrix)!
        let zMatrix = Matrix<Coefficient>(elements: Vector<Coefficient>._exp(zLogExponentMatrix.elements), rowCount: coefficients.count, columnCount: zArray.count)!
        let results = Matrix<Coefficient>._multiply(coefficientMatrix, zMatrix)!
        return results.elements
    }
}


extension Polynomial where Coefficient == Complex<Float>{
    public func evaluate<ComplexArray>(variables zArray: ComplexArray) -> [Complex<Float>]
    where ComplexArray: AccelerateBuffer, ComplexArray.Element == Complex<Float>
    {
        _evaluate(variables: zArray)
    }
    public func evaluate(variable z: Complex<Float>) -> Complex<Float>{
        _evaluate(variables: [z])[0]
    }
}
extension Polynomial where Coefficient == Complex<Double>{
    public func evaluate<ComplexArray>(variables zArray: ComplexArray) -> [Complex<Double>]
    where ComplexArray: AccelerateBuffer, ComplexArray.Element == Complex<Double>
    {
        _evaluate(variables: zArray)
    }
    public func evaluate(variable z: Complex<Double>) -> Complex<Double>{
        _evaluate(variables: [z])[0]
    }
}

extension Polynomial where Coefficient == DSPComplex{
    public func evaluate<ComplexArray>(variables zArray: ComplexArray) -> [DSPComplex]
    where ComplexArray: AccelerateBuffer, ComplexArray.Element == DSPComplex
    {
        _evaluate(variables: zArray)
    }
    public func evaluate(variable z: DSPComplex) -> DSPComplex{
        _evaluate(variables: [z])[0]
    }
}

extension Polynomial where Coefficient == DSPDoubleComplex{
    public func evaluate<ComplexArray>(variables zArray: ComplexArray) -> [DSPDoubleComplex]
    where ComplexArray: AccelerateBuffer, ComplexArray.Element == DSPDoubleComplex
    {
        _evaluate(variables: zArray)
    }
    public func evaluate(variable z: DSPDoubleComplex) -> DSPDoubleComplex{
        _evaluate(variables: [z])[0]
    }
}
