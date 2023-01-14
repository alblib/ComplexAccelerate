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
    public static var zero: Self{
        return Self(coefficients: [])
    }
    public var degree: Int{
        max(0, self.coefficients.count - 1)
    }
}

extension Polynomial where Coefficient: ExpressibleByIntegerLiteral{
    public static var one: Self{
        Self(coefficients: [1])
    }
}

extension Polynomial where Coefficient: AdditiveArithmetic{
    public var degree: Int{
        if coefficients.isEmpty{
            return 0
        }
        return coefficients.withUnsafeBufferPointer { originBuffer in
            guard var ptr = originBuffer.baseAddress else{
                return 0
            }
            ptr += coefficients.count - 1
            for i in 0...(coefficients.count-1){
                if (ptr - i).pointee != Coefficient.zero{
                    return self.coefficients.count - 1 - i
                }
            }
            return 0
        }
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

extension Polynomial where Coefficient: SignedNumeric{
    public static prefix func - ( operand: Self) -> Self{
        return Self(coefficients: operand.coefficients.map{-$0})
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
    public static prefix func - (_ operand: Self) -> Self{
        return Self(coefficients: vDSP.negative(operand.coefficients))
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
    public static prefix func - (_ operand: Self) -> Self{
        return Self(coefficients: vDSP.negative(operand.coefficients))
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
    public static prefix func - (_ operand: Self) -> Self{
        return Self(coefficients: Vector.negative(operand.coefficients))
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
    public static prefix func - (_ operand: Self) -> Self{
        return Self(coefficients: Vector.negative(operand.coefficients))
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
    public static prefix func - (_ operand: Self) -> Self{
        return Self(coefficients: Vector.negative(operand.coefficients))
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
    public static prefix func - (_ operand: Self) -> Self{
        return Self(coefficients: Vector.negative(operand.coefficients))
    }
}

// MARK: - Multiplication

extension Polynomial where Coefficient: Numeric{
    public static func * (_ lhs: Self, _ rhs: Self) -> Self
    {
        if lhs.coefficients.isEmpty || rhs.coefficients.isEmpty{
            return .zero
        }
        var resultCoeff = Vector<Coefficient>.zeros(count: lhs.coefficients.count + rhs.coefficients.count - 1)
        for lhsC in lhs.coefficients.enumerated(){
            for rhsC in rhs.coefficients.enumerated(){
                resultCoeff[lhsC.offset + rhsC.offset] += lhsC.element * rhsC.element
            }
        }
        return Self(coefficients: resultCoeff)
    }
    public static func *= (_ lhs: inout Self, _ rhs: Self){
        lhs = lhs * rhs
    }
    public static func * (lhs: Coefficient, rhs: Self) -> Self{
        Self(coefficients: Vector<Coefficient>.multiply(lhs, rhs.coefficients))
    }
    public static func * (lhs: Self, rhs: Coefficient) -> Self{
        Self(coefficients: Vector<Coefficient>.multiply(lhs.coefficients, rhs))
    }
    public static func *= (_ lhs: inout Self, _ rhs: Coefficient){
        lhs = lhs * rhs
    }
}

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
    public static func *= (_ lhs: inout Self, _ rhs: Self){
        lhs = lhs * rhs
    }
    public static func * (_ lhs: Self, _ rhs: Coefficient) -> Self{
        Self(coefficients: vDSP.multiply(rhs, lhs.coefficients))
    }
    public static func * (_ lhs: Coefficient, _ rhs: Self) -> Self{
        Self(coefficients: vDSP.multiply(lhs, rhs.coefficients))
    }
    public static func *= (_ lhs: inout Self, _ rhs: Coefficient){
        lhs = lhs * rhs
    }
    public static func / (_ lhs: Self, _ rhs: Coefficient) -> Self{
        Self(coefficients: vDSP.divide(lhs.coefficients, rhs))
    }
    public static func /= (_ lhs: inout Self, _ rhs: Coefficient){
        lhs = lhs / rhs
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
    public static func *= (_ lhs: inout Self, _ rhs: Self){
        lhs = lhs * rhs
    }
    public static func * (_ lhs: Self, _ rhs: Coefficient) -> Self{
        Self(coefficients: vDSP.multiply(rhs, lhs.coefficients))
    }
    public static func * (_ lhs: Coefficient, _ rhs: Self) -> Self{
        Self(coefficients: vDSP.multiply(lhs, rhs.coefficients))
    }
    public static func *= (_ lhs: inout Self, _ rhs: Coefficient){
        lhs = lhs * rhs
    }
    public static func / (_ lhs: Self, _ rhs: Coefficient) -> Self{
        Self(coefficients: vDSP.divide(lhs.coefficients, rhs))
    }
    public static func /= (_ lhs: inout Self, _ rhs: Coefficient){
        lhs = lhs / rhs
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
    public static func *= (_ lhs: inout Self, _ rhs: Self){
        lhs = lhs * rhs
    }
    public static func * (_ lhs: Self, _ rhs: Coefficient) -> Self{
        Self(coefficients: Vector<Coefficient>._mul(lhs.coefficients, scalar: rhs))
    }
    public static func * (_ lhs: Coefficient, _ rhs: Self) -> Self{
        Self(coefficients: Vector<Coefficient>._mul(rhs.coefficients, scalar:lhs))
    }
    public static func *= (_ lhs: inout Self, _ rhs: Coefficient){
        lhs = lhs * rhs
    }
    public static func / (_ lhs: Self, _ rhs: Coefficient) -> Self{
        Self(coefficients: Vector.divide(lhs.coefficients, rhs))
    }
    public static func /= (_ lhs: inout Self, _ rhs: Coefficient){
        lhs = lhs / rhs
    }
    public static func / (_ lhs: Self, _ rhs: Float) -> Self{
        Self(coefficients: Vector.divide(lhs.coefficients, rhs))
    }
    public static func /= (_ lhs: inout Self, _ rhs: Float){
        lhs = lhs / rhs
    }
}
extension Polynomial where Coefficient == Complex<Double>{
    public static func * (_ lhs: Self, _ rhs: Self) -> Self{
        _mul(lhs,rhs)
    }
    public static func *= (_ lhs: inout Self, _ rhs: Self){
        lhs = lhs * rhs
    }
    public static func * (_ lhs: Self, _ rhs: Coefficient) -> Self{
        Self(coefficients: Vector<Coefficient>._mul(lhs.coefficients, scalar: rhs))
    }
    public static func * (_ lhs: Coefficient, _ rhs: Self) -> Self{
        Self(coefficients: Vector<Coefficient>._mul(rhs.coefficients, scalar:lhs))
    }
    public static func *= (_ lhs: inout Self, _ rhs: Coefficient){
        lhs = lhs * rhs
    }
    public static func / (_ lhs: Self, _ rhs: Coefficient) -> Self{
        Self(coefficients: Vector.divide(lhs.coefficients, rhs))
    }
    public static func /= (_ lhs: inout Self, _ rhs: Coefficient){
        lhs = lhs / rhs
    }
    public static func / (_ lhs: Self, _ rhs: Double) -> Self{
        Self(coefficients: Vector.divide(lhs.coefficients, rhs))
    }
    public static func /= (_ lhs: inout Self, _ rhs: Double){
        lhs = lhs / rhs
    }
}
extension Polynomial where Coefficient == DSPComplex{
    public static func * (_ lhs: Self, _ rhs: Self) -> Self{
        _mul(lhs,rhs)
    }
    public static func *= (_ lhs: inout Self, _ rhs: Self){
        lhs = lhs * rhs
    }
    public static func * (_ lhs: Self, _ rhs: Coefficient) -> Self{
        Self(coefficients: Vector<Coefficient>._mul(lhs.coefficients, scalar: rhs))
    }
    public static func * (_ lhs: Coefficient, _ rhs: Self) -> Self{
        Self(coefficients: Vector<Coefficient>._mul(rhs.coefficients, scalar:lhs))
    }
    public static func *= (_ lhs: inout Self, _ rhs: Coefficient){
        lhs = lhs * rhs
    }
    public static func / (_ lhs: Self, _ rhs: Coefficient) -> Self{
        Self(coefficients: Vector.divide(lhs.coefficients, rhs))
    }
    public static func /= (_ lhs: inout Self, _ rhs: Coefficient){
        lhs = lhs / rhs
    }
    public static func / (_ lhs: Self, _ rhs: Float) -> Self{
        Self(coefficients: Vector.divide(lhs.coefficients, rhs))
    }
    public static func /= (_ lhs: inout Self, _ rhs: Float){
        lhs = lhs / rhs
    }
}
extension Polynomial where Coefficient == DSPDoubleComplex{
    public static func * (_ lhs: Self, _ rhs: Self) -> Self{
        _mul(lhs,rhs)
    }
    public static func *= (_ lhs: inout Self, _ rhs: Self){
        lhs = lhs * rhs
    }
    public static func * (_ lhs: Self, _ rhs: Coefficient) -> Self{
        Self(coefficients: Vector<Coefficient>._mul(lhs.coefficients, scalar: rhs))
    }
    public static func * (_ lhs: Coefficient, _ rhs: Self) -> Self{
        Self(coefficients: Vector<Coefficient>._mul(rhs.coefficients, scalar:lhs))
    }
    public static func *= (_ lhs: inout Self, _ rhs: Coefficient){
        lhs = lhs * rhs
    }
    public static func / (_ lhs: Self, _ rhs: Coefficient) -> Self{
        Self(coefficients: Vector.divide(lhs.coefficients, rhs))
    }
    public static func /= (_ lhs: inout Self, _ rhs: Coefficient){
        lhs = lhs / rhs
    }
    public static func / (_ lhs: Self, _ rhs: Double) -> Self{
        Self(coefficients: Vector.divide(lhs.coefficients, rhs))
    }
    public static func /= (_ lhs: inout Self, _ rhs: Double){
        lhs = lhs / rhs
    }
}


// MARK: - Evaluation

extension Polynomial where Coefficient == Float{
    public func evaluate(variable x: Float) -> Float{
        evaluate(variable: [x])[0]
    }
    public func evaluate(variable values: [Float]) -> [Float]
    {
        if coefficients.isEmpty{
            return Vector<Float>.zeros(count: values.count)
        }
        return [Float](unsafeUninitializedCapacity: values.count) { buffer, initializedCount in
            guard let oPtr = buffer.baseAddress else{
                return
            }
            coefficients.withUnsafeBufferPointer { coeffBuffer in
                let iPtr = coeffBuffer.baseAddress! + coeffBuffer.count - 1
                vDSP_vpoly(iPtr, -1, values, 1, oPtr, 1, vDSP_Length(values.count), vDSP_Length(coefficients.count - 1))
                
            }
            initializedCount = values.count
        }
    }
    func _complexEvaluate<ComplexArray, RComplex>(variables zArray: ComplexArray) -> [RComplex]
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
    public func evaluate<ComplexArray>(variable values: ComplexArray) -> [DSPComplex]
    where ComplexArray: AccelerateBuffer, ComplexArray.Element == DSPComplex
    {
        _complexEvaluate(variables: values)
    }
    public func evaluate<ComplexArray>(variable values: ComplexArray) -> [Complex<Float>]
    where ComplexArray: AccelerateBuffer, ComplexArray.Element == Complex<Float>
    {
        _complexEvaluate(variables: values)
    }
    public func evaluate(variable z: DSPComplex) -> DSPComplex{
        _complexEvaluate(variables: [z])[0]
    }
    public func evaluate(variable z: Complex<Float>) -> Complex<Float>{
        _complexEvaluate(variables: [z])[0]
    }
}

extension Polynomial where Coefficient == Double{
    public func evaluate(variable x: Double) -> Double{
        evaluate(variable: [x])[0]
    }
    public func evaluate(variable values: [Double]) -> [Double]
    {
        if coefficients.isEmpty{
            return Vector<Double>.zeros(count: values.count)
        }
        return [Double](unsafeUninitializedCapacity: values.count) { buffer, initializedCount in
            guard let oPtr = buffer.baseAddress else{
                return
            }
            coefficients.withUnsafeBufferPointer { coeffBuffer in
                let iPtr = coeffBuffer.baseAddress! + coeffBuffer.count - 1
                vDSP_vpolyD(iPtr, -1, values, 1, oPtr, 1, vDSP_Length(values.count), vDSP_Length(coefficients.count - 1))
                
            }
            initializedCount = values.count
        }
    }
    func _complexEvaluate<ComplexArray, RComplex>(variables zArray: ComplexArray) -> [RComplex]
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
    public func evaluate<ComplexArray>(variable values: ComplexArray) -> [DSPDoubleComplex]
    where ComplexArray: AccelerateBuffer, ComplexArray.Element == DSPDoubleComplex
    {
        _complexEvaluate(variables: values)
    }
    public func evaluate<ComplexArray>(variable values: ComplexArray) -> [Complex<Double>]
    where ComplexArray: AccelerateBuffer, ComplexArray.Element == Complex<Double>
    {
        _complexEvaluate(variables: values)
    }
    public func evaluate(variable z: DSPDoubleComplex) -> DSPDoubleComplex{
        _complexEvaluate(variables: [z])[0]
    }
    public func evaluate(variable z: Complex<Double>) -> Complex<Double>{
        _complexEvaluate(variables: [z])[0]
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
    public func evaluate<ComplexArray>(variable values: ComplexArray) -> [Complex<Float>]
    where ComplexArray: AccelerateBuffer, ComplexArray.Element == Complex<Float>
    {
        _evaluate(variables: values)
    }
    public func evaluate(variable z: Complex<Float>) -> Complex<Float>{
        _evaluate(variables: [z])[0]
    }
}
extension Polynomial where Coefficient == Complex<Double>{
    public func evaluate<ComplexArray>(variable values: ComplexArray) -> [Complex<Double>]
    where ComplexArray: AccelerateBuffer, ComplexArray.Element == Complex<Double>
    {
        _evaluate(variables: values)
    }
    public func evaluate(variable z: Complex<Double>) -> Complex<Double>{
        _evaluate(variables: [z])[0]
    }
}

extension Polynomial where Coefficient == DSPComplex{
    public func evaluate<ComplexArray>(variable values: ComplexArray) -> [DSPComplex]
    where ComplexArray: AccelerateBuffer, ComplexArray.Element == DSPComplex
    {
        _evaluate(variables: values)
    }
    public func evaluate(variable z: DSPComplex) -> DSPComplex{
        _evaluate(variables: [z])[0]
    }
}

extension Polynomial where Coefficient == DSPDoubleComplex{
    public func evaluate<ComplexArray>(variable values: ComplexArray) -> [DSPDoubleComplex]
    where ComplexArray: AccelerateBuffer, ComplexArray.Element == DSPDoubleComplex
    {
        _evaluate(variables: values)
    }
    public func evaluate(variable z: DSPDoubleComplex) -> DSPDoubleComplex{
        _evaluate(variables: [z])[0]
    }
}

// MARK: - Differentiation
extension Polynomial where Coefficient == Float{
    public func derivative(order: Int = 1) -> Polynomial{
        if coefficients.count == 0 || coefficients.count <= order {
            return .zero
        }
        if order == 0 {
            return self
        }else if order == 1{
            let polynomialOrder = self.degree
            return Polynomial(coefficients: vDSP.multiply(vDSP.ramp(withInitialValue: Float(1), increment: Float(1), count: polynomialOrder), self.coefficients[1...polynomialOrder]))
        }else if order > 1{
            // [A_0, ... , A_n] -> [A_1, 2A_2, 3A_3, ... , nA_n] -> [2*1*A_2, 3*2*A_3, ... , n(n-1)A_n]
            // -> [ diffOrder! A_diffOrder, ... , n! / (n - diffOrder)! * A_n]
            // = [ tgamma(diffOrder+1) A_diffOrder, ..., tgamma(n+1) / tgamma(n+1-diffOrder) * A_n]
            let polynomialOrder = self.degree
            let differentiateOrder = order
            let multiplCoeff = Array(differentiateOrder+1...polynomialOrder+1).map{tgamma(Float($0)) / tgamma(Float($0 - differentiateOrder))}
            return Polynomial(coefficients: vDSP.multiply(multiplCoeff, self.coefficients[differentiateOrder...polynomialOrder]))
        }else { // order < 0
            // [A_0, ... , A_n] -> [0, A_0, A_1/2, ..., A_n/(n+1)] -> [0, 0, A_0/2, A_1/2/3, ... , A_n/(n+1)(n+2)]
            // -> Array(repeating: 0, integralOrder) + [A_0/integralOrder!, ... , A_n * n! / (n+integralOrder)!]
            // = Array(repeating: 0, integralOrder) + [... , A_n * tgamma(n+1)! / tgamma(n+integralOrder+1)]
            let polynomialOrder = self.degree
            let integralOrder = -order
            let multiplCoeff = Array(0...polynomialOrder).map{tgamma(Float($0 + 1)) / tgamma(Float($0 + integralOrder + 1))}
            return Polynomial(coefficients: Array(repeating: Float.zero, count: integralOrder) + vDSP.multiply(multiplCoeff, self.coefficients))
        }
    }
}
extension Polynomial where Coefficient == Double{
    public func derivative(order: Int = 1) -> Polynomial{
        if coefficients.count == 0 || coefficients.count <= order {
            return .zero
        }
        if order == 0 {
            return self
        }else if order == 1{
            let polynomialOrder = self.degree
            return Polynomial(coefficients: vDSP.multiply(vDSP.ramp(withInitialValue: Double(1), increment: Double(1), count: polynomialOrder), self.coefficients[1...polynomialOrder]))
        }else if order > 1{
            // [A_0, ... , A_n] -> [A_1, 2A_2, 3A_3, ... , nA_n] -> [2*1*A_2, 3*2*A_3, ... , n(n-1)A_n]
            // -> [ diffOrder! A_diffOrder, ... , n! / (n - diffOrder)! * A_n]
            // = [ tgamma(diffOrder+1) A_diffOrder, ..., tgamma(n+1) / tgamma(n+1-diffOrder) * A_n]
            let polynomialOrder = self.degree
            let differentiateOrder = order
            let multiplCoeff = Array(differentiateOrder+1...polynomialOrder+1).map{tgamma(Double($0)) / tgamma(Double($0 - differentiateOrder))}
            return Polynomial(coefficients: vDSP.multiply(multiplCoeff, self.coefficients[differentiateOrder...polynomialOrder]))
        }else { // order < 0
            // [A_0, ... , A_n] -> [0, A_0, A_1/2, ..., A_n/(n+1)] -> [0, 0, A_0/2, A_1/2/3, ... , A_n/(n+1)(n+2)]
            // -> Array(repeating: 0, integralOrder) + [A_0/integralOrder!, ... , A_n * n! / (n+integralOrder)!]
            // = Array(repeating: 0, integralOrder) + [... , A_n * tgamma(n+1)! / tgamma(n+integralOrder+1)]
            let polynomialOrder = self.degree
            let integralOrder = -order
            let multiplCoeff = Array(0...polynomialOrder).map{tgamma(Double($0 + 1)) / tgamma(Double($0 + integralOrder + 1))}
            return Polynomial(coefficients: Array(repeating: Double.zero, count: integralOrder) + vDSP.multiply(multiplCoeff, self.coefficients))
        }
    }
}
extension Polynomial where Coefficient: GenericComplex, Coefficient.Real == Float{
    func _derivative(order: Int) -> Polynomial{
        if coefficients.count == 0 || coefficients.count <= order {
            return .zero
        }
        if order == 0 {
            return self
        }else if order == 1{
            let polynomialOrder = self.degree
            return Polynomial(coefficients: Vector<Coefficient>._mul(self.coefficients[1...polynomialOrder], vDSP.ramp(withInitialValue: Float(1), increment: Float(1), count: polynomialOrder)))
        }else if order > 1{
            // [A_0, ... , A_n] -> [A_1, 2A_2, 3A_3, ... , nA_n] -> [2*1*A_2, 3*2*A_3, ... , n(n-1)A_n]
            // -> [ diffOrder! A_diffOrder, ... , n! / (n - diffOrder)! * A_n]
            // = [ tgamma(diffOrder+1) A_diffOrder, ..., tgamma(n+1) / tgamma(n+1-diffOrder) * A_n]
            let polynomialOrder = self.degree
            let differentiateOrder = order
            let multiplCoeff = Array(differentiateOrder+1...polynomialOrder+1).map{tgamma(Float($0)) / tgamma(Float($0 - differentiateOrder))}
            return Polynomial(coefficients: Vector<Coefficient>._mul(self.coefficients[differentiateOrder...polynomialOrder], multiplCoeff))
        }else { // order < 0
            // [A_0, ... , A_n] -> [0, A_0, A_1/2, ..., A_n/(n+1)] -> [0, 0, A_0/2, A_1/2/3, ... , A_n/(n+1)(n+2)]
            // -> Array(repeating: 0, integralOrder) + [A_0/integralOrder!, ... , A_n * n! / (n+integralOrder)!]
            // = Array(repeating: 0, integralOrder) + [... , A_n * tgamma(n+1)! / tgamma(n+integralOrder+1)]
            let polynomialOrder = self.degree
            let integralOrder = -order
            let multiplCoeff = Array(0...polynomialOrder).map{tgamma(Float($0 + 1)) / tgamma(Float($0 + integralOrder + 1))}
            return Polynomial(coefficients: Vector<Coefficient>._zeros(count: integralOrder) + Vector<Coefficient>._mul(self.coefficients, multiplCoeff))
        }
    }
}

extension Polynomial where Coefficient: GenericComplex, Coefficient.Real == Double{
    func _derivative(order: Int) -> Polynomial{
        if coefficients.count == 0 || coefficients.count <= order {
            return .zero
        }
        if order == 0 {
            return self
        }else if order == 1{
            let polynomialOrder = self.degree
            return Polynomial(coefficients: Vector<Coefficient>._mul(self.coefficients[1...polynomialOrder], vDSP.ramp(withInitialValue: Double(1), increment: Double(1), count: polynomialOrder)))
        }else if order > 1{
            // [A_0, ... , A_n] -> [A_1, 2A_2, 3A_3, ... , nA_n] -> [2*1*A_2, 3*2*A_3, ... , n(n-1)A_n]
            // -> [ diffOrder! A_diffOrder, ... , n! / (n - diffOrder)! * A_n]
            // = [ tgamma(diffOrder+1) A_diffOrder, ..., tgamma(n+1) / tgamma(n+1-diffOrder) * A_n]
            let polynomialOrder = self.degree
            let differentiateOrder = order
            let multiplCoeff = Array(differentiateOrder+1...polynomialOrder+1).map{tgamma(Double($0)) / tgamma(Double($0 - differentiateOrder))}
            return Polynomial(coefficients: Vector<Coefficient>._mul(self.coefficients[differentiateOrder...polynomialOrder], multiplCoeff))
        }else { // order < 0
            // [A_0, ... , A_n] -> [0, A_0, A_1/2, ..., A_n/(n+1)] -> [0, 0, A_0/2, A_1/2/3, ... , A_n/(n+1)(n+2)]
            // -> Array(repeating: 0, integralOrder) + [A_0/integralOrder!, ... , A_n * n! / (n+integralOrder)!]
            // = Array(repeating: 0, integralOrder) + [... , A_n * tgamma(n+1)! / tgamma(n+integralOrder+1)]
            let polynomialOrder = self.degree
            let integralOrder = -order
            let multiplCoeff = Array(0...polynomialOrder).map{tgamma(Double($0 + 1)) / tgamma(Double($0 + integralOrder + 1))}
            return Polynomial(coefficients: Vector<Coefficient>._zeros(count: integralOrder) + Vector<Coefficient>._mul(self.coefficients, multiplCoeff))
        }
    }
}

extension Polynomial where Coefficient == Complex<Float>{
    public func derivative(order: Int = 1) -> Polynomial{
        _derivative(order: order)
    }
}
extension Polynomial where Coefficient == Complex<Double>{
    public func derivative(order: Int = 1) -> Polynomial{
        _derivative(order: order)
    }
}
extension Polynomial where Coefficient == DSPComplex{
    public func derivative(order: Int = 1) -> Polynomial{
        _derivative(order: order)
    }
}
extension Polynomial where Coefficient == DSPDoubleComplex{
    public func derivative(order: Int = 1) -> Polynomial{
        _derivative(order: order)
    }
}

// MARK: - Substitution

extension Polynomial where Coefficient == Float{
    public func substitute(variable by: Self) -> Self{
        var result = Self.zero
        var mono = Self.one
        for i in self.coefficients{
            result += i * mono
            mono *= by
        }
        return result
    }
}
extension Polynomial where Coefficient == Double{
    public func substitute(variable by: Self) -> Self{
        var result = Self.zero
        var mono = Self.one
        for i in self.coefficients{
            result += i * mono
            mono *= by
        }
        return result
    }
}
extension Polynomial where Coefficient == DSPComplex{
    public func substitute(variable by: Self) -> Self{
        var result = Self.zero
        var mono = Self(coefficients: [Coefficient(real: 1, imag: 0)])
        for i in self.coefficients{
            let term = i * mono
            result.coefficients = Vector.add(result.coefficients, term.coefficients)
            mono *= by
        }
        return result
    }
}
extension Polynomial where Coefficient == DSPDoubleComplex{
    public func substitute(variable by: Self) -> Self{
        var result = Self.zero
        var mono = Self(coefficients: [Coefficient(real: 1, imag: 0)])
        for i in self.coefficients{
            let term = i * mono
            result.coefficients = Vector.add(result.coefficients, term.coefficients)
            mono *= by
        }
        return result
    }
}
extension Polynomial where Coefficient == Complex<Float>{
    public func substitute(variable by: Self) -> Self{
        var result = Self.zero
        var mono = Self.one
        for i in self.coefficients{
            result += i * mono
            mono *= by
        }
        return result
    }
}
extension Polynomial where Coefficient == Complex<Double>{
    public func substitute(variable by: Self) -> Self{
        var result = Self.zero
        var mono = Self.one
        for i in self.coefficients{
            result += i * mono
            mono *= by
        }
        return result
    }
}
