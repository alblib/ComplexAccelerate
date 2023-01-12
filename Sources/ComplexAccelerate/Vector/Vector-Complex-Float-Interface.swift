//
//  Vector-Complex-Float-Interface.swift
//  
//
//  Created by Albertus Liberius on 2023-01-11.
//

import Foundation
import Accelerate

// MARK: - Create Vector

public extension Vector where Element == Complex<Float>{
    static func castToComplexes<RealVector>(_ vector: RealVector) -> [Complex<Float>]
    where RealVector: AccelerateBuffer, RealVector.Element == Float
    {
        let imags = [Float](unsafeUninitializedCapacity: vector.count) { buffer, initializedCount in
            vDSP.fill(&buffer, with: 0)
            initializedCount = vector.count
        }
        return _merge(reals: vector, imaginaries: imags)
    }
    static func create<RealVectorA, RealVectorB>(reals: RealVectorA, imaginaries: RealVectorB) -> [Complex<Float>]
    where RealVectorA: AccelerateBuffer, RealVectorB: AccelerateBuffer, RealVectorA.Element == Float, RealVectorB.Element == Float
    {
        return _merge(reals: reals, imaginaries: imaginaries)
    }
    static func create(repeating: Complex<Float>, count: Int) -> [Complex<Float>]
    {
        [Element](unsafeUninitializedCapacity: count) { buffer, initializedCount in
            buffer.withDSPSplitComplexPointer { outPtr in
                repeating.withDSPSplitComplexPointer { repeatingPtr in
                    vDSP_zvfill(repeatingPtr, outPtr, 2, vDSP_Length(count))
                }
            }
            initializedCount = count
        }
    }
    static func arithmeticProgression(initialValue: Complex<Float>, increment: Complex<Float>, count: Int) -> [Complex<Float>]
    {
        _ramp(begin: initialValue, increment: increment, count: count)
    }
    static func arithmeticProgression(initialValue: Complex<Float>, to finalValue: Complex<Float>, count: Int) -> [Complex<Float>]
    {
        _ramp(begin: initialValue, end: finalValue, count: count)
    }
    static func geometricProgression(initialValue: Complex<Float>, ratio: Complex<Float>, count: Int) -> [Complex<Float>]
    {
        _rampGeo(begin: initialValue, multiple: ratio, count: count)
    }
    static func geometricProgression(initialValue: Complex<Float>, to finalValue: Complex<Float>, count: Int) -> [Complex<Float>]
    {
        _rampGeo(begin: initialValue, end: finalValue, count: count)
    }
    static func realsAndImaginaries<ComplexVector>(_ vector: ComplexVector) -> (reals: [Float], imaginaries: [Float])
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Element
    {
        return _split(vector)
    }
    static func reals<ComplexVector>(_ vector: ComplexVector) -> [Float]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Element
    {
        return _split(vector).reals
    }
    static func imaginaries<ComplexVector>(_ vector: ComplexVector) -> [Float]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Element
    {
        return _split(vector).imaginaries
    }
}

public extension Vector where Element == DSPComplex{
    static func castToComplexes<RealVector>(_ vector: RealVector) -> [DSPComplex]
    where RealVector: AccelerateBuffer, RealVector.Element == Float
    {
        let imags = [Float](unsafeUninitializedCapacity: vector.count) { buffer, initializedCount in
            vDSP.fill(&buffer, with: 0)
            initializedCount = vector.count
        }
        return _merge(reals: vector, imaginaries: imags)
    }
    static func create<RealVectorA, RealVectorB>(reals: RealVectorA, imaginaries: RealVectorB) -> [DSPComplex]
    where RealVectorA: AccelerateBuffer, RealVectorB: AccelerateBuffer, RealVectorA.Element == Float, RealVectorB.Element == Float
    {
        return _merge(reals: reals, imaginaries: imaginaries)
    }
    static func create(repeating: DSPComplex, count: Int) -> [DSPComplex]
    {
        [Element](unsafeUninitializedCapacity: count) { buffer, initializedCount in
            buffer.withDSPSplitComplexPointer { outPtr in
                repeating.withDSPSplitComplexPointer { repeatingPtr in
                    vDSP_zvfill(repeatingPtr, outPtr, 2, vDSP_Length(count))
                }
            }
            initializedCount = count
        }
    }
    static func arithmeticProgression(initialValue: DSPComplex, increment: DSPComplex, count: Int) -> [DSPComplex]
    {
        _ramp(begin: initialValue, increment: increment, count: count)
    }
    static func arithmeticProgression(initialValue: DSPComplex, to finalValue: DSPComplex, count: Int) -> [DSPComplex]
    {
        _ramp(begin: initialValue, end: finalValue, count: count)
    }
    static func geometricProgression(initialValue: DSPComplex, ratio: DSPComplex, count: Int) -> [DSPComplex]
    {
        _rampGeo(begin: initialValue, multiple: ratio, count: count)
    }
    static func geometricProgression(initialValue: DSPComplex, to finalValue: DSPComplex, count: Int) -> [DSPComplex]
    {
        _rampGeo(begin: initialValue, end: finalValue, count: count)
    }
    static func realsAndImaginaries<ComplexVector>(_ vector: ComplexVector) -> (reals: [Float], imaginaries: [Float])
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Element
    {
        return _split(vector)
    }
    static func reals<ComplexVector>(_ vector: ComplexVector) -> [Float]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Element
    {
        return _split(vector).reals
    }
    static func imaginaries<ComplexVector>(_ vector: ComplexVector) -> [Float]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Element
    {
        return _split(vector).imaginaries
    }
}

// MARK: - Vector-vector operation
// MARK: ℂₙ + ℂₙ -> ℂₙ

public extension Vector where Element == Complex<Float>
{
    static func add<ComplexVectorA, ComplexVectorB>(_ vectorA: ComplexVectorA, _ vectorB: ComplexVectorB) -> [Complex<Float>]
    where ComplexVectorA: AccelerateBuffer, ComplexVectorB: AccelerateBuffer,
          ComplexVectorA.Element == Complex<Float>, ComplexVectorB.Element == Complex<Float>
    {
        _add(vectorA, vectorB)
    }
    static func subtract<ComplexVectorA, ComplexVectorB>(_ vectorA: ComplexVectorA, _ vectorB: ComplexVectorB) -> [Complex<Float>]
    where ComplexVectorA: AccelerateBuffer, ComplexVectorB: AccelerateBuffer,
          ComplexVectorA.Element == Complex<Float>, ComplexVectorB.Element == Complex<Float>
    {
        _sub(vectorA, vectorB)
    }
    static func multiply<ComplexVectorA, ComplexVectorB>(_ vectorA: ComplexVectorA, _ vectorB: ComplexVectorB) -> [Complex<Float>]
    where ComplexVectorA: AccelerateBuffer, ComplexVectorB: AccelerateBuffer,
          ComplexVectorA.Element == Complex<Float>, ComplexVectorB.Element == Complex<Float>
    {
        _mul(vectorA, vectorB)
    }
    static func multiply<ComplexVectorA, ComplexVectorB>(conjugate vectorA: ComplexVectorA, _ vectorB: ComplexVectorB) -> [Complex<Float>]
    where ComplexVectorA: AccelerateBuffer, ComplexVectorB: AccelerateBuffer,
          ComplexVectorA.Element == Complex<Float>, ComplexVectorB.Element == Complex<Float>
    {
        _mul(conj: vectorA, vectorB)
    }
    static func multiply<ComplexVectorA, ComplexVectorB>(_ vectorA: ComplexVectorA, conjugate vectorB: ComplexVectorB) -> [Complex<Float>]
    where ComplexVectorA: AccelerateBuffer, ComplexVectorB: AccelerateBuffer,
          ComplexVectorA.Element == Complex<Float>, ComplexVectorB.Element == Complex<Float>
    {
        _mul(conj: vectorB, vectorA)
    }
    static func divide<ComplexVectorA, ComplexVectorB>(_ vectorA: ComplexVectorA, _ vectorB: ComplexVectorB) -> [Complex<Float>]
    where ComplexVectorA: AccelerateBuffer, ComplexVectorB: AccelerateBuffer,
          ComplexVectorA.Element == Complex<Float>, ComplexVectorB.Element == Complex<Float>
    {
        _div(vectorA, vectorB)
    }
}

public extension Vector where Element == DSPComplex
{
    static func add<ComplexVectorA, ComplexVectorB>(_ vectorA: ComplexVectorA, _ vectorB: ComplexVectorB) -> [DSPComplex]
    where ComplexVectorA: AccelerateBuffer, ComplexVectorB: AccelerateBuffer,
          ComplexVectorA.Element == DSPComplex, ComplexVectorB.Element == DSPComplex
    {
        _add(vectorA, vectorB)
    }
    static func subtract<ComplexVectorA, ComplexVectorB>(_ vectorA: ComplexVectorA, _ vectorB: ComplexVectorB) -> [DSPComplex]
    where ComplexVectorA: AccelerateBuffer, ComplexVectorB: AccelerateBuffer,
          ComplexVectorA.Element == DSPComplex, ComplexVectorB.Element == DSPComplex
    {
        _sub(vectorA, vectorB)
    }
    static func multiply<ComplexVectorA, ComplexVectorB>(_ vectorA: ComplexVectorA, _ vectorB: ComplexVectorB) -> [DSPComplex]
    where ComplexVectorA: AccelerateBuffer, ComplexVectorB: AccelerateBuffer,
          ComplexVectorA.Element == DSPComplex, ComplexVectorB.Element == DSPComplex
    {
        _mul(vectorA, vectorB)
    }
    static func multiply<ComplexVectorA, ComplexVectorB>(conjugate vectorA: ComplexVectorA, _ vectorB: ComplexVectorB) -> [DSPComplex]
    where ComplexVectorA: AccelerateBuffer, ComplexVectorB: AccelerateBuffer,
          ComplexVectorA.Element == DSPComplex, ComplexVectorB.Element == DSPComplex
    {
        _mul(conj: vectorA, vectorB)
    }
    static func multiply<ComplexVectorA, ComplexVectorB>(_ vectorA: ComplexVectorA, conjugate vectorB: ComplexVectorB) -> [DSPComplex]
    where ComplexVectorA: AccelerateBuffer, ComplexVectorB: AccelerateBuffer,
          ComplexVectorA.Element == DSPComplex, ComplexVectorB.Element == DSPComplex
    {
        _mul(conj: vectorB, vectorA)
    }
    static func divide<ComplexVectorA, ComplexVectorB>(_ vectorA: ComplexVectorA, _ vectorB: ComplexVectorB) -> [DSPComplex]
    where ComplexVectorA: AccelerateBuffer, ComplexVectorB: AccelerateBuffer,
          ComplexVectorA.Element == DSPComplex, ComplexVectorB.Element == DSPComplex
    {
        _div(vectorA, vectorB)
    }
}

// MARK: ℂₙ + ℝₙ -> ℂₙ

public extension Vector where Element == Complex<Float>{
    static func add<ComplexVector, RealVector>(_ vectorA: ComplexVector, _ vectorB: RealVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>, RealVector.Element == Float
    {
        _add(vectorA, vectorB)
    }
    static func subtract<ComplexVector, RealVector>(_ vectorA: ComplexVector, _ vectorB: RealVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>, RealVector.Element == Float
    {
        _sub(vectorA, vectorB)
    }
    static func multiply<ComplexVector, RealVector>(_ vectorA: ComplexVector, _ vectorB: RealVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>, RealVector.Element == Float
    {
        _mul(vectorA, vectorB)
    }
    static func multiply<ComplexVector, RealVector>(conjugate vectorA: ComplexVector, _ vectorB: RealVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>, RealVector.Element == Float
    {
        _mul(_conj(vectorA), vectorB)
    }
    static func divide<ComplexVector, RealVector>(_ vectorA: ComplexVector, _ vectorB: RealVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>, RealVector.Element == Float
    {
        _div(vectorA, vectorB)
    }
}

public extension Vector where Element == DSPComplex{
    static func add<ComplexVector, RealVector>(_ vectorA: ComplexVector, _ vectorB: RealVector) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == DSPComplex, RealVector.Element == Float
    {
        _add(vectorA, vectorB)
    }
    static func subtract<ComplexVector, RealVector>(_ vectorA: ComplexVector, _ vectorB: RealVector) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == DSPComplex, RealVector.Element == Float
    {
        _sub(vectorA, vectorB)
    }
    static func multiply<ComplexVector, RealVector>(_ vectorA: ComplexVector, _ vectorB: RealVector) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == DSPComplex, RealVector.Element == Float
    {
        _mul(vectorA, vectorB)
    }
    static func multiply<ComplexVector, RealVector>(conjugate vectorA: ComplexVector, _ vectorB: RealVector) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == DSPComplex, RealVector.Element == Float
    {
        _mul(_conj(vectorA), vectorB)
    }
    static func divide<ComplexVector, RealVector>(_ vectorA: ComplexVector, _ vectorB: RealVector) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == DSPComplex, RealVector.Element == Float
    {
        _div(vectorA, vectorB)
    }
}

// MARK: ℝₙ + ℂₙ -> ℂₙ
public extension Vector where Element == Complex<Float>{
    static func add<RealVector, ComplexVector>(_ vectorA: RealVector, _ vectorB: ComplexVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>, RealVector.Element == Float
    {
        _add(vectorB, vectorA)
    }
    static func subtract<RealVector, ComplexVector>(_ vectorA: RealVector, _ vectorB: ComplexVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>, RealVector.Element == Float
    {
        _neg(_sub(vectorB, vectorA))
    }
    static func multiply<RealVector, ComplexVector>(_ vectorA: RealVector, _ vectorB: ComplexVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>, RealVector.Element == Float
    {
        _mul(vectorB, vectorA)
    }
    static func multiply<RealVector, ComplexVector>(_ vectorA: RealVector, conjugate vectorB: ComplexVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>, RealVector.Element == Float
    {
        _mul(_conj(vectorB), vectorA)
    }
    static func divide<RealVector, ComplexVector>(_ vectorA: RealVector, _ vectorB: ComplexVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>, RealVector.Element == Float
    {
        _div(castToComplexes(vectorA), vectorB)
    }
}

public extension Vector where Element == DSPComplex{
    static func add<RealVector, ComplexVector>(_ vectorA: RealVector, _ vectorB: ComplexVector) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == DSPComplex, RealVector.Element == Float
    {
        _add(vectorB, vectorA)
    }
    static func subtract<RealVector, ComplexVector>(_ vectorA: RealVector, _ vectorB: ComplexVector) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == DSPComplex, RealVector.Element == Float
    {
        _neg(_sub(vectorB, vectorA))
    }
    static func multiply<RealVector, ComplexVector>(_ vectorA: RealVector, _ vectorB: ComplexVector) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == DSPComplex, RealVector.Element == Float
    {
        _mul(vectorB, vectorA)
    }
    static func multiply<RealVector, ComplexVector>(_ vectorA: RealVector, conjugate vectorB: ComplexVector) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == DSPComplex, RealVector.Element == Float
    {
        _mul(_conj(vectorB), vectorA)
    }
    static func divide<RealVector, ComplexVector>(_ vectorA: RealVector, _ vectorB: ComplexVector) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == DSPComplex, RealVector.Element == Float
    {
        _div(castToComplexes(vectorA), vectorB)
    }
}


// MARK: - Vector-scalar operation

// MARK: ℂₙ + ℂ -> ℂₙ

public extension Vector where Element == Complex<Float>{
    static func add<ComplexVector>(_ vector: ComplexVector, _ scalar: Complex<Float>) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _add(vector, scalar: scalar)
    }
    static func subtract<ComplexVector>(_ vector: ComplexVector, _ scalar: Complex<Float>) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _sub(vector, scalar: scalar)
    }
    static func multiply<ComplexVector>(_ vector: ComplexVector, _ scalar: Complex<Float>) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _mul(vector, scalar: scalar)
    }
    static func multiply<ComplexVector>(conjugate vector: ComplexVector, _ scalar: Complex<Float>) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _mul(conj: vector, scalar: scalar)
    }
    static func divide<ComplexVector>(_ vector: ComplexVector, _ scalar: Complex<Float>) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _div(vector, scalar: scalar)
    }
}

public extension Vector where Element == DSPComplex{
    static func add<ComplexVector>(_ vector: ComplexVector, _ scalar: DSPComplex) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _add(vector, scalar: scalar)
    }
    static func subtract<ComplexVector>(_ vector: ComplexVector, _ scalar: DSPComplex) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _sub(vector, scalar: scalar)
    }
    static func multiply<ComplexVector>(_ vector: ComplexVector, _ scalar: DSPComplex) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _mul(vector, scalar: scalar)
    }
    static func multiply<ComplexVector>(conjugate vector: ComplexVector, _ scalar: DSPComplex) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _mul(conj: vector, scalar: scalar)
    }
    static func divide<ComplexVector>(_ vector: ComplexVector, _ scalar: DSPComplex) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _div(vector, scalar: scalar)
    }
}


// MARK: ℂ + ℂₙ -> ℂₙ

public extension Vector where Element == Complex<Float>{
    static func add<ComplexVector>(_ scalar: Complex<Float>, _ vector: ComplexVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _add(vector, scalar: scalar)
    }
    static func subtract<ComplexVector>(_ scalar: Complex<Float>, _ vector: ComplexVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _sub(scalar: scalar, vector)
    }
    static func multiply<ComplexVector>(_ scalar: Complex<Float>, _ vector: ComplexVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _mul(vector, scalar: scalar)
    }
    static func multiply<ComplexVector>(_ scalar: Complex<Float>, conjugate vector: ComplexVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _mul(conj: vector, scalar: scalar)
    }
    static func divide<ComplexVector>(_ scalar: Complex<Float>, _ vector: ComplexVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _div(scalar: scalar, vector)
    }
}

public extension Vector where Element == DSPComplex{
    static func add<ComplexVector>(_ scalar: DSPComplex, _ vector: ComplexVector) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _add(vector, scalar: scalar)
    }
    static func subtract<ComplexVector>(_ scalar: DSPComplex, _ vector: ComplexVector) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _sub(scalar: scalar, vector)
    }
    static func multiply<ComplexVector>(_ scalar: DSPComplex, _ vector: ComplexVector) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _mul(vector, scalar: scalar)
    }
    static func multiply<ComplexVector>(_ scalar: DSPComplex, conjugate vector: ComplexVector) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _mul(conj: vector, scalar: scalar)
    }
    static func divide<ComplexVector>(_ scalar: DSPComplex, _ vector: ComplexVector) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _div(scalar: scalar, vector)
    }
}

///////////////////////
///


// MARK: ℂₙ + ℝ -> ℂₙ

public extension Vector where Element == Complex<Float>{
    static func add<ComplexVector>(_ vector: ComplexVector, _ scalar: Float) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _add(vector, scalar: Element(real: scalar, imag: 0))
    }
    static func subtract<ComplexVector>(_ vector: ComplexVector, _ scalar: Float) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _sub(vector, scalar: Element(real: scalar, imag: 0))
    }
    static func multiply<ComplexVector>(_ vector: ComplexVector, _ scalar: Float) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _mul(vector, scalar: scalar)
    }
    static func divide<ComplexVector>(_ vector: ComplexVector, _ scalar: Float) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _div(vector, scalar: scalar)
    }
}

public extension Vector where Element == DSPComplex{
    static func add<ComplexVector>(_ vector: ComplexVector, _ scalar: Float) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _add(vector, scalar: Element(real: scalar, imag: 0))
    }
    static func subtract<ComplexVector>(_ vector: ComplexVector, _ scalar: Float) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _sub(vector, scalar: Element(real: scalar, imag: 0))
    }
    static func multiply<ComplexVector>(_ vector: ComplexVector, _ scalar: Float) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _mul(vector, scalar: scalar)
    }
    static func divide<ComplexVector>(_ vector: ComplexVector, _ scalar: Float) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _div(vector, scalar: scalar)
    }
}


// MARK: ℝ + ℂₙ -> ℂₙ

public extension Vector where Element == Complex<Float>{
    static func add<ComplexVector>(_ scalar: Float, _ vector: ComplexVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _add(vector, scalar: Element(real: scalar, imag: 0))
    }
    static func subtract<ComplexVector>(_ scalar: Float, _ vector: ComplexVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _sub(scalar: Element(real: scalar, imag: 0), vector)
    }
    static func multiply<ComplexVector>(_ scalar: Float, _ vector: ComplexVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _mul(vector, scalar: scalar)
    }
    static func divide<ComplexVector>(_ scalar: Float, _ vector: ComplexVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _div(scalar: Element(real: scalar, imag: 0), vector)
    }
}

public extension Vector where Element == DSPComplex{
    static func add<ComplexVector>(_ scalar: Float, _ vector: ComplexVector) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _add(vector, scalar: Element(real: scalar, imag: 0))
    }
    static func subtract<ComplexVector>(_ scalar: Float, _ vector: ComplexVector) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _sub(scalar: Element(real: scalar, imag: 0), vector)
    }
    static func multiply<ComplexVector>(_ scalar: Float, _ vector: ComplexVector) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _mul(vector, scalar: scalar)
    }
    static func divide<ComplexVector>(_ scalar: Float, _ vector: ComplexVector) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _div(scalar: Element(real: scalar, imag: 0), vector)
    }
}


// MARK: - Vector Reduction

public extension Vector where Element == Complex<Float>{
    static func dot<ComplexVectorA, ComplexVectorB>
    (_ vectorA: ComplexVectorA, _ vectorB: ComplexVectorB) -> Complex<Float>
    where ComplexVectorA: AccelerateBuffer, ComplexVectorB: AccelerateBuffer,
          ComplexVectorA.Element == Complex<Float>, ComplexVectorB.Element == Complex<Float>
    {
        _dot(vectorA, vectorB)
    }
    static func dot<ComplexVectorA, ComplexVectorB>
    (conjugate vectorA: ComplexVectorA, _ vectorB: ComplexVectorB) -> Complex<Float>
    where ComplexVectorA: AccelerateBuffer, ComplexVectorB: AccelerateBuffer,
          ComplexVectorA.Element == Complex<Float>, ComplexVectorB.Element == Complex<Float>
    {
        _dot(conj: vectorA, vectorB)
    }
    
    static func dot<ComplexVectorA, ComplexVectorB>
    (_ vectorA: ComplexVectorA, conjugate vectorB: ComplexVectorB) -> Complex<Float>
    where ComplexVectorA: AccelerateBuffer, ComplexVectorB: AccelerateBuffer,
          ComplexVectorA.Element == Complex<Float>, ComplexVectorB.Element == Complex<Float>
    {
        _dot(conj: vectorB, vectorA)
    }
    
    static func dot<ComplexVector, RealVector>
    (_ vectorA: ComplexVector, _ vectorB: RealVector) -> Complex<Float>
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer,
          ComplexVector.Element == Complex<Float>, RealVector.Element == Float
    {
        _dot(vectorA, vectorB)
    }
    
    static func dot<RealVector, ComplexVector>
    (_ vectorA: RealVector, _ vectorB: ComplexVector) -> Complex<Float>
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer,
          ComplexVector.Element == Complex<Float>, RealVector.Element == Float
    {
        _dot(vectorB, vectorA)
    }
}
    

public extension Vector where Element == DSPComplex{
    static func dot<ComplexVectorA, ComplexVectorB>
    (_ vectorA: ComplexVectorA, _ vectorB: ComplexVectorB) -> DSPComplex
    where ComplexVectorA: AccelerateBuffer, ComplexVectorB: AccelerateBuffer,
          ComplexVectorA.Element == DSPComplex, ComplexVectorB.Element == DSPComplex
    {
        _dot(vectorA, vectorB)
    }
    static func dot<ComplexVectorA, ComplexVectorB>
    (conjugate vectorA: ComplexVectorA, _ vectorB: ComplexVectorB) -> DSPComplex
    where ComplexVectorA: AccelerateBuffer, ComplexVectorB: AccelerateBuffer,
          ComplexVectorA.Element == DSPComplex, ComplexVectorB.Element == DSPComplex
    {
        _dot(conj: vectorA, vectorB)
    }
    
    static func dot<ComplexVectorA, ComplexVectorB>
    (_ vectorA: ComplexVectorA, conjugate vectorB: ComplexVectorB) -> DSPComplex
    where ComplexVectorA: AccelerateBuffer, ComplexVectorB: AccelerateBuffer,
          ComplexVectorA.Element == DSPComplex, ComplexVectorB.Element == DSPComplex
    {
        _dot(conj: vectorB, vectorA)
    }
    
    static func dot<ComplexVector, RealVector>
    (_ vectorA: ComplexVector, _ vectorB: RealVector) -> DSPComplex
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer,
          ComplexVector.Element == DSPComplex, RealVector.Element == Float
    {
        _dot(vectorA, vectorB)
    }
    
    static func dot<RealVector, ComplexVector>
    (_ vectorA: RealVector, _ vectorB: ComplexVector) -> DSPComplex
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer,
          ComplexVector.Element == DSPComplex, RealVector.Element == Float
    {
        _dot(vectorB, vectorA)
    }
}
    
// MARK: - Single Function

// MARK: Complex Analysis

public extension Vector where Element == Complex<Float>{
    static func absolute<ComplexVector>(_ vector: ComplexVector) -> [Float]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _abs(vector)
    }
    static func conjugate<ComplexVector>(_ vector: ComplexVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _conj(vector)
    }
    static func negative<ComplexVector>(_ vector: ComplexVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _neg(vector)
    }
    static func phase<ComplexVector>(_ vector: ComplexVector) -> [Float]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _arg(vector)
    }
}


public extension Vector where Element == DSPComplex{
    static func absolute<ComplexVector>(_ vector: ComplexVector) -> [Float]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _abs(vector)
    }
    static func conjugate<ComplexVector>(_ vector: ComplexVector) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _conj(vector)
    }
    static func negative<ComplexVector>(_ vector: ComplexVector) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _neg(vector)
    }
    static func phase<ComplexVector>(_ vector: ComplexVector) -> [Float]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _arg(vector)
    }
}

// MARK: Logs and Exps

public extension Vector where Element == Complex<Float>{
    static func log<ComplexVector>(_ vector: ComplexVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _log(vector)
    }
    static func exp<ComplexVector>(_ vector: ComplexVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _exp(vector)
    }
    static func expi<ComplexVector>(_ vector: ComplexVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _expi(vector)
    }
    static func expi<RealVector>(_ vector: RealVector) -> [Complex<Float>]
    where RealVector: AccelerateBuffer, RealVector.Element == Float
    {
        _expi(vector)
    }
    static func sqrt<ComplexVector>(_ vector: ComplexVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _sqrt(vector)
    }
}

public extension Vector where Element == DSPComplex{
    static func log<ComplexVector>(_ vector: ComplexVector) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _log(vector)
    }
    static func exp<ComplexVector>(_ vector: ComplexVector) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _exp(vector)
    }
    static func expi<ComplexVector>(_ vector: ComplexVector) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _expi(vector)
    }
    static func expi<RealVector>(_ vector: RealVector) -> [DSPComplex]
    where RealVector: AccelerateBuffer, RealVector.Element == Float
    {
        _expi(vector)
    }
    static func sqrt<ComplexVector>(_ vector: ComplexVector) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _sqrt(vector)
    }
}

// MARK: Powers


public extension Vector where Element == Complex<Float>{
    static func pow<ComplexBaseVector, ComplexExponentVector>(bases: ComplexBaseVector, exponents: ComplexExponentVector) -> [Complex<Float>]
    where ComplexBaseVector: AccelerateBuffer, ComplexExponentVector: AccelerateBuffer, ComplexBaseVector.Element == Complex<Float>, ComplexExponentVector.Element == Complex<Float>
    {
        _pow(bases: bases, exponents: exponents)
    }
    static func pow<RealBaseVector, ComplexExponentVector>(bases: RealBaseVector, exponents: ComplexExponentVector) -> [Complex<Float>]
    where RealBaseVector: AccelerateBuffer, ComplexExponentVector: AccelerateBuffer, RealBaseVector.Element == Float, ComplexExponentVector.Element == Complex<Float>
    {
        _pow(bases: bases, exponents: exponents)
    }
    static func pow<ComplexBaseVector, RealExponentVector>(bases: ComplexBaseVector, exponents: RealExponentVector) -> [Complex<Float>]
    where ComplexBaseVector: AccelerateBuffer, RealExponentVector: AccelerateBuffer, ComplexBaseVector.Element == Complex<Float>, RealExponentVector.Element == Float
    {
        _pow(bases: bases, exponents: exponents)
    }
    
    static func pow<ComplexExponentVector>(base: Complex<Float>, exponents: ComplexExponentVector) -> [Complex<Float>]
    where ComplexExponentVector: AccelerateBuffer, ComplexExponentVector.Element == Complex<Float>
    {
        _pow(base: base, exponents: exponents)
    }
    static func pow<ComplexExponentVector>(base: Float, exponents: ComplexExponentVector) -> [Complex<Float>]
    where ComplexExponentVector: AccelerateBuffer, ComplexExponentVector.Element == Complex<Float>
    {
        _pow(base: base, exponents: exponents)
    }
    static func pow<RealExponentVector>(base: Complex<Float>, exponents: RealExponentVector) -> [Complex<Float>]
    where RealExponentVector: AccelerateBuffer, RealExponentVector.Element == Float
    {
        _pow(base: base, exponents: exponents)
    }
    
    
    static func pow<ComplexBaseVector>(bases: ComplexBaseVector, exponent: Complex<Float>) -> [Complex<Float>]
    where ComplexBaseVector: AccelerateBuffer, ComplexBaseVector.Element == Complex<Float>
    {
        _pow(bases: bases, exponent: exponent)
    }
    static func pow<RealBaseVector>(bases: RealBaseVector, exponent: Complex<Float>) -> [Complex<Float>]
    where RealBaseVector: AccelerateBuffer, RealBaseVector.Element == Float
    {
        _pow(bases: bases, exponent: exponent)
    }
    static func pow<ComplexBaseVector>(bases: ComplexBaseVector, exponent: Float) -> [Complex<Float>]
    where ComplexBaseVector: AccelerateBuffer, ComplexBaseVector.Element == Complex<Float>
    {
        _pow(bases: bases, exponent: exponent)
    }
}

public extension Vector where Element == DSPComplex{
    static func pow<ComplexBaseVector, ComplexExponentVector>(bases: ComplexBaseVector, exponents: ComplexExponentVector) -> [DSPComplex]
    where ComplexBaseVector: AccelerateBuffer, ComplexExponentVector: AccelerateBuffer, ComplexBaseVector.Element == DSPComplex, ComplexExponentVector.Element == DSPComplex
    {
        _pow(bases: bases, exponents: exponents)
    }
    static func pow<RealBaseVector, ComplexExponentVector>(bases: RealBaseVector, exponents: ComplexExponentVector) -> [DSPComplex]
    where RealBaseVector: AccelerateBuffer, ComplexExponentVector: AccelerateBuffer, RealBaseVector.Element == Float, ComplexExponentVector.Element == DSPComplex
    {
        _pow(bases: bases, exponents: exponents)
    }
    static func pow<ComplexBaseVector, RealExponentVector>(bases: ComplexBaseVector, exponents: RealExponentVector) -> [DSPComplex]
    where ComplexBaseVector: AccelerateBuffer, RealExponentVector: AccelerateBuffer, ComplexBaseVector.Element == DSPComplex, RealExponentVector.Element == Float
    {
        _pow(bases: bases, exponents: exponents)
    }
    
    static func pow<ComplexExponentVector>(base: DSPComplex, exponents: ComplexExponentVector) -> [DSPComplex]
    where ComplexExponentVector: AccelerateBuffer, ComplexExponentVector.Element == DSPComplex
    {
        _pow(base: base, exponents: exponents)
    }
    static func pow<ComplexExponentVector>(base: Float, exponents: ComplexExponentVector) -> [DSPComplex]
    where ComplexExponentVector: AccelerateBuffer, ComplexExponentVector.Element == DSPComplex
    {
        _pow(base: base, exponents: exponents)
    }
    static func pow<RealExponentVector>(base: DSPComplex, exponents: RealExponentVector) -> [DSPComplex]
    where RealExponentVector: AccelerateBuffer, RealExponentVector.Element == Float
    {
        _pow(base: base, exponents: exponents)
    }
    
    
    static func pow<ComplexBaseVector>(bases: ComplexBaseVector, exponent: DSPComplex) -> [DSPComplex]
    where ComplexBaseVector: AccelerateBuffer, ComplexBaseVector.Element == DSPComplex
    {
        _pow(bases: bases, exponent: exponent)
    }
    static func pow<RealBaseVector>(bases: RealBaseVector, exponent: DSPComplex) -> [DSPComplex]
    where RealBaseVector: AccelerateBuffer, RealBaseVector.Element == Float
    {
        _pow(bases: bases, exponent: exponent)
    }
    static func pow<ComplexBaseVector>(bases: ComplexBaseVector, exponent: Float) -> [DSPComplex]
    where ComplexBaseVector: AccelerateBuffer, ComplexBaseVector.Element == DSPComplex
    {
        _pow(bases: bases, exponent: exponent)
    }
}

// MARK: Trigonometric Functions

public extension Vector where Element == Complex<Float>{
    static func cos<ComplexVector>(_ vector: ComplexVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _cos(vector)
    }
    static func sin<ComplexVector>(_ vector: ComplexVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _sin(vector)
    }
    static func tan<ComplexVector>(_ vector: ComplexVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _tan(vector)
    }
    static func cot<ComplexVector>(_ vector: ComplexVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _cot(vector)
    }
    static func acos<ComplexVector>(_ vector: ComplexVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _acos(vector)
    }
    static func asin<ComplexVector>(_ vector: ComplexVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _asin(vector)
    }
    static func atan<ComplexVector>(_ vector: ComplexVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _atan(vector)
    }
    static func acot<ComplexVector>(_ vector: ComplexVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _acot(vector)
    }
}

public extension Vector where Element == DSPComplex{
    static func cos<ComplexVector>(_ vector: ComplexVector) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _cos(vector)
    }
    static func sin<ComplexVector>(_ vector: ComplexVector) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _sin(vector)
    }
    static func tan<ComplexVector>(_ vector: ComplexVector) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _tan(vector)
    }
    static func cot<ComplexVector>(_ vector: ComplexVector) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _cot(vector)
    }
    static func acos<ComplexVector>(_ vector: ComplexVector) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _acos(vector)
    }
    static func asin<ComplexVector>(_ vector: ComplexVector) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _asin(vector)
    }
    static func atan<ComplexVector>(_ vector: ComplexVector) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _atan(vector)
    }
    static func acot<ComplexVector>(_ vector: ComplexVector) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _acot(vector)
    }
}

// MARK: Hyperbolic Functions

public extension Vector where Element == Complex<Float>{
    static func cosh<ComplexVector>(_ vector: ComplexVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _cosh(vector)
    }
    static func sinh<ComplexVector>(_ vector: ComplexVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _sinh(vector)
    }
    static func tanh<ComplexVector>(_ vector: ComplexVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _tanh(vector)
    }
    static func coth<ComplexVector>(_ vector: ComplexVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _coth(vector)
    }
    static func acosh<ComplexVector>(_ vector: ComplexVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _acosh(vector)
    }
    static func asinh<ComplexVector>(_ vector: ComplexVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _asinh(vector)
    }
    static func atanh<ComplexVector>(_ vector: ComplexVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _atanh(vector)
    }
    static func acoth<ComplexVector>(_ vector: ComplexVector) -> [Complex<Float>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        _acoth(vector)
    }
}

public extension Vector where Element == DSPComplex{
    static func cosh<ComplexVector>(_ vector: ComplexVector) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _cosh(vector)
    }
    static func sinh<ComplexVector>(_ vector: ComplexVector) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _sinh(vector)
    }
    static func tanh<ComplexVector>(_ vector: ComplexVector) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _tanh(vector)
    }
    static func coth<ComplexVector>(_ vector: ComplexVector) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _coth(vector)
    }
    static func acosh<ComplexVector>(_ vector: ComplexVector) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _acosh(vector)
    }
    static func asinh<ComplexVector>(_ vector: ComplexVector) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _asinh(vector)
    }
    static func atanh<ComplexVector>(_ vector: ComplexVector) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _atanh(vector)
    }
    static func acoth<ComplexVector>(_ vector: ComplexVector) -> [DSPComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPComplex
    {
        _acoth(vector)
    }
}
