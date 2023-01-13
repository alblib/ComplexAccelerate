//
//  Vector-Complex-Double-Interface.swift
//  
//
//  Created by Albertus Liberius on 2023-01-11.
//

import Foundation
import Accelerate

// MARK: - Create Vector

public extension Vector where Element == Complex<Double>{
    static func castToComplexes<RealVector>(_ vector: RealVector) -> [Complex<Double>]
    where RealVector: AccelerateBuffer, RealVector.Element == Double
    {
        let imags = [Double](unsafeUninitializedCapacity: vector.count) { buffer, initializedCount in
            vDSP.fill(&buffer, with: 0)
            initializedCount = vector.count
        }
        return _merge(reals: vector, imaginaries: imags)
    }
    static func create<RealVectorA, RealVectorB>(reals: RealVectorA, imaginaries: RealVectorB) -> [Complex<Double>]
    where RealVectorA: AccelerateBuffer, RealVectorB: AccelerateBuffer, RealVectorA.Element == Double, RealVectorB.Element == Double
    {
        return _merge(reals: reals, imaginaries: imaginaries)
    }
    static func create(repeating: Complex<Double>, count: Int) -> [Complex<Double>]
    {
        [Element](unsafeUninitializedCapacity: count) { buffer, initializedCount in
            buffer.withDSPDoubleSplitComplexPointer { outPtr in
                repeating.withDSPDoubleSplitComplexPointer { repeatingPtr in
                    vDSP_zvfillD(repeatingPtr, outPtr, 2, vDSP_Length(count))
                }
            }
            initializedCount = count
        }
    }
    static func arithmeticProgression(initialValue: Complex<Double>, increment: Complex<Double>, count: Int) -> [Complex<Double>]
    {
        _ramp(begin: initialValue, increment: increment, count: count)
    }
    static func arithmeticProgression(initialValue: Complex<Double>, to finalValue: Complex<Double>, count: Int) -> [Complex<Double>]
    {
        _ramp(begin: initialValue, end: finalValue, count: count)
    }
    static func geometricProgression(initialValue: Complex<Double>, ratio: Complex<Double>, count: Int) -> [Complex<Double>]
    {
        _rampGeo(begin: initialValue, multiple: ratio, count: count)
    }
    static func geometricProgression(initialValue: Complex<Double>, to finalValue: Complex<Double>, count: Int) -> [Complex<Double>]
    {
        _rampGeo(begin: initialValue, end: finalValue, count: count)
    }
    static func realsAndImaginaries<ComplexVector>(_ vector: ComplexVector) -> (reals: [Double], imaginaries: [Double])
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Element
    {
        return _split(vector)
    }
    static func reals<ComplexVector>(_ vector: ComplexVector) -> [Double]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Element
    {
        return _split(vector).reals
    }
    static func imaginaries<ComplexVector>(_ vector: ComplexVector) -> [Double]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Element
    {
        return _split(vector).imaginaries
    }
}

public extension Vector where Element == DSPDoubleComplex{
    static func castToComplexes<RealVector>(_ vector: RealVector) -> [DSPDoubleComplex]
    where RealVector: AccelerateBuffer, RealVector.Element == Double
    {
        let imags = [Double](unsafeUninitializedCapacity: vector.count) { buffer, initializedCount in
            vDSP.fill(&buffer, with: 0)
            initializedCount = vector.count
        }
        return _merge(reals: vector, imaginaries: imags)
    }
    static func create<RealVectorA, RealVectorB>(reals: RealVectorA, imaginaries: RealVectorB) -> [DSPDoubleComplex]
    where RealVectorA: AccelerateBuffer, RealVectorB: AccelerateBuffer, RealVectorA.Element == Double, RealVectorB.Element == Double
    {
        return _merge(reals: reals, imaginaries: imaginaries)
    }
    static func create(repeating: DSPDoubleComplex, count: Int) -> [DSPDoubleComplex]
    {
        [Element](unsafeUninitializedCapacity: count) { buffer, initializedCount in
            buffer.withDSPDoubleSplitComplexPointer { outPtr in
                repeating.withDSPDoubleSplitComplexPointer { repeatingPtr in
                    vDSP_zvfillD(repeatingPtr, outPtr, 2, vDSP_Length(count))
                }
            }
            initializedCount = count
        }
    }
    static func arithmeticProgression(initialValue: DSPDoubleComplex, increment: DSPDoubleComplex, count: Int) -> [DSPDoubleComplex]
    {
        _ramp(begin: initialValue, increment: increment, count: count)
    }
    static func arithmeticProgression(initialValue: DSPDoubleComplex, to finalValue: DSPDoubleComplex, count: Int) -> [DSPDoubleComplex]
    {
        _ramp(begin: initialValue, end: finalValue, count: count)
    }
    static func geometricProgression(initialValue: DSPDoubleComplex, ratio: DSPDoubleComplex, count: Int) -> [DSPDoubleComplex]
    {
        _rampGeo(begin: initialValue, multiple: ratio, count: count)
    }
    static func geometricProgression(initialValue: DSPDoubleComplex, to finalValue: DSPDoubleComplex, count: Int) -> [DSPDoubleComplex]
    {
        _rampGeo(begin: initialValue, end: finalValue, count: count)
    }
    static func realsAndImaginaries<ComplexVector>(_ vector: ComplexVector) -> (reals: [Double], imaginaries: [Double])
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Element
    {
        return _split(vector)
    }
    static func reals<ComplexVector>(_ vector: ComplexVector) -> [Double]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Element
    {
        return _split(vector).reals
    }
    static func imaginaries<ComplexVector>(_ vector: ComplexVector) -> [Double]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Element
    {
        return _split(vector).imaginaries
    }
}

// MARK: - Vector-vector operation
// MARK: ℂₙ + ℂₙ -> ℂₙ

public extension Vector where Element == Complex<Double>
{
    static func add<ComplexVectorA, ComplexVectorB>(_ vectorA: ComplexVectorA, _ vectorB: ComplexVectorB) -> [Complex<Double>]
    where ComplexVectorA: AccelerateBuffer, ComplexVectorB: AccelerateBuffer,
          ComplexVectorA.Element == Complex<Double>, ComplexVectorB.Element == Complex<Double>
    {
        _add(vectorA, vectorB)
    }
    static func subtract<ComplexVectorA, ComplexVectorB>(_ vectorA: ComplexVectorA, _ vectorB: ComplexVectorB) -> [Complex<Double>]
    where ComplexVectorA: AccelerateBuffer, ComplexVectorB: AccelerateBuffer,
          ComplexVectorA.Element == Complex<Double>, ComplexVectorB.Element == Complex<Double>
    {
        _sub(vectorA, vectorB)
    }
    static func multiply<ComplexVectorA, ComplexVectorB>(_ vectorA: ComplexVectorA, _ vectorB: ComplexVectorB) -> [Complex<Double>]
    where ComplexVectorA: AccelerateBuffer, ComplexVectorB: AccelerateBuffer,
          ComplexVectorA.Element == Complex<Double>, ComplexVectorB.Element == Complex<Double>
    {
        _mul(vectorA, vectorB)
    }
    static func multiply<ComplexVectorA, ComplexVectorB>(conjugate vectorA: ComplexVectorA, _ vectorB: ComplexVectorB) -> [Complex<Double>]
    where ComplexVectorA: AccelerateBuffer, ComplexVectorB: AccelerateBuffer,
          ComplexVectorA.Element == Complex<Double>, ComplexVectorB.Element == Complex<Double>
    {
        _mul(conj: vectorA, vectorB)
    }
    static func multiply<ComplexVectorA, ComplexVectorB>(_ vectorA: ComplexVectorA, conjugate vectorB: ComplexVectorB) -> [Complex<Double>]
    where ComplexVectorA: AccelerateBuffer, ComplexVectorB: AccelerateBuffer,
          ComplexVectorA.Element == Complex<Double>, ComplexVectorB.Element == Complex<Double>
    {
        _mul(conj: vectorB, vectorA)
    }
    static func divide<ComplexVectorA, ComplexVectorB>(_ vectorA: ComplexVectorA, _ vectorB: ComplexVectorB) -> [Complex<Double>]
    where ComplexVectorA: AccelerateBuffer, ComplexVectorB: AccelerateBuffer,
          ComplexVectorA.Element == Complex<Double>, ComplexVectorB.Element == Complex<Double>
    {
        _div(vectorA, vectorB)
    }
}

public extension Vector where Element == DSPDoubleComplex
{
    static func add<ComplexVectorA, ComplexVectorB>(_ vectorA: ComplexVectorA, _ vectorB: ComplexVectorB) -> [DSPDoubleComplex]
    where ComplexVectorA: AccelerateBuffer, ComplexVectorB: AccelerateBuffer,
          ComplexVectorA.Element == DSPDoubleComplex, ComplexVectorB.Element == DSPDoubleComplex
    {
        _add(vectorA, vectorB)
    }
    static func subtract<ComplexVectorA, ComplexVectorB>(_ vectorA: ComplexVectorA, _ vectorB: ComplexVectorB) -> [DSPDoubleComplex]
    where ComplexVectorA: AccelerateBuffer, ComplexVectorB: AccelerateBuffer,
          ComplexVectorA.Element == DSPDoubleComplex, ComplexVectorB.Element == DSPDoubleComplex
    {
        _sub(vectorA, vectorB)
    }
    static func multiply<ComplexVectorA, ComplexVectorB>(_ vectorA: ComplexVectorA, _ vectorB: ComplexVectorB) -> [DSPDoubleComplex]
    where ComplexVectorA: AccelerateBuffer, ComplexVectorB: AccelerateBuffer,
          ComplexVectorA.Element == DSPDoubleComplex, ComplexVectorB.Element == DSPDoubleComplex
    {
        _mul(vectorA, vectorB)
    }
    static func multiply<ComplexVectorA, ComplexVectorB>(conjugate vectorA: ComplexVectorA, _ vectorB: ComplexVectorB) -> [DSPDoubleComplex]
    where ComplexVectorA: AccelerateBuffer, ComplexVectorB: AccelerateBuffer,
          ComplexVectorA.Element == DSPDoubleComplex, ComplexVectorB.Element == DSPDoubleComplex
    {
        _mul(conj: vectorA, vectorB)
    }
    static func multiply<ComplexVectorA, ComplexVectorB>(_ vectorA: ComplexVectorA, conjugate vectorB: ComplexVectorB) -> [DSPDoubleComplex]
    where ComplexVectorA: AccelerateBuffer, ComplexVectorB: AccelerateBuffer,
          ComplexVectorA.Element == DSPDoubleComplex, ComplexVectorB.Element == DSPDoubleComplex
    {
        _mul(conj: vectorB, vectorA)
    }
    static func divide<ComplexVectorA, ComplexVectorB>(_ vectorA: ComplexVectorA, _ vectorB: ComplexVectorB) -> [DSPDoubleComplex]
    where ComplexVectorA: AccelerateBuffer, ComplexVectorB: AccelerateBuffer,
          ComplexVectorA.Element == DSPDoubleComplex, ComplexVectorB.Element == DSPDoubleComplex
    {
        _div(vectorA, vectorB)
    }
}

// MARK: ℂₙ + ℝₙ -> ℂₙ

public extension Vector where Element == Complex<Double>{
    static func add<ComplexVector, RealVector>(_ vectorA: ComplexVector, _ vectorB: RealVector) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>, RealVector.Element == Double
    {
        _add(vectorA, vectorB)
    }
    static func subtract<ComplexVector, RealVector>(_ vectorA: ComplexVector, _ vectorB: RealVector) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>, RealVector.Element == Double
    {
        _sub(vectorA, vectorB)
    }
    static func multiply<ComplexVector, RealVector>(_ vectorA: ComplexVector, _ vectorB: RealVector) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>, RealVector.Element == Double
    {
        _mul(vectorA, vectorB)
    }
    static func multiply<ComplexVector, RealVector>(conjugate vectorA: ComplexVector, _ vectorB: RealVector) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>, RealVector.Element == Double
    {
        _mul(_conj(vectorA), vectorB)
    }
    static func divide<ComplexVector, RealVector>(_ vectorA: ComplexVector, _ vectorB: RealVector) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>, RealVector.Element == Double
    {
        _div(vectorA, vectorB)
    }
}

public extension Vector where Element == DSPDoubleComplex{
    static func add<ComplexVector, RealVector>(_ vectorA: ComplexVector, _ vectorB: RealVector) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex, RealVector.Element == Double
    {
        _add(vectorA, vectorB)
    }
    static func subtract<ComplexVector, RealVector>(_ vectorA: ComplexVector, _ vectorB: RealVector) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex, RealVector.Element == Double
    {
        _sub(vectorA, vectorB)
    }
    static func multiply<ComplexVector, RealVector>(_ vectorA: ComplexVector, _ vectorB: RealVector) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex, RealVector.Element == Double
    {
        _mul(vectorA, vectorB)
    }
    static func multiply<ComplexVector, RealVector>(conjugate vectorA: ComplexVector, _ vectorB: RealVector) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex, RealVector.Element == Double
    {
        _mul(_conj(vectorA), vectorB)
    }
    static func divide<ComplexVector, RealVector>(_ vectorA: ComplexVector, _ vectorB: RealVector) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex, RealVector.Element == Double
    {
        _div(vectorA, vectorB)
    }
}

// MARK: ℝₙ + ℂₙ -> ℂₙ
public extension Vector where Element == Complex<Double>{
    static func add<RealVector, ComplexVector>(_ vectorA: RealVector, _ vectorB: ComplexVector) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>, RealVector.Element == Double
    {
        _add(vectorB, vectorA)
    }
    static func subtract<RealVector, ComplexVector>(_ vectorA: RealVector, _ vectorB: ComplexVector) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>, RealVector.Element == Double
    {
        _neg(_sub(vectorB, vectorA))
    }
    static func multiply<RealVector, ComplexVector>(_ vectorA: RealVector, _ vectorB: ComplexVector) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>, RealVector.Element == Double
    {
        _mul(vectorB, vectorA)
    }
    static func multiply<RealVector, ComplexVector>(_ vectorA: RealVector, conjugate vectorB: ComplexVector) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>, RealVector.Element == Double
    {
        _mul(_conj(vectorB), vectorA)
    }
    static func divide<RealVector, ComplexVector>(_ vectorA: RealVector, _ vectorB: ComplexVector) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>, RealVector.Element == Double
    {
        _div(castToComplexes(vectorA), vectorB)
    }
}

public extension Vector where Element == DSPDoubleComplex{
    static func add<RealVector, ComplexVector>(_ vectorA: RealVector, _ vectorB: ComplexVector) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex, RealVector.Element == Double
    {
        _add(vectorB, vectorA)
    }
    static func subtract<RealVector, ComplexVector>(_ vectorA: RealVector, _ vectorB: ComplexVector) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex, RealVector.Element == Double
    {
        _neg(_sub(vectorB, vectorA))
    }
    static func multiply<RealVector, ComplexVector>(_ vectorA: RealVector, _ vectorB: ComplexVector) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex, RealVector.Element == Double
    {
        _mul(vectorB, vectorA)
    }
    static func multiply<RealVector, ComplexVector>(_ vectorA: RealVector, conjugate vectorB: ComplexVector) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex, RealVector.Element == Double
    {
        _mul(_conj(vectorB), vectorA)
    }
    static func divide<RealVector, ComplexVector>(_ vectorA: RealVector, _ vectorB: ComplexVector) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex, RealVector.Element == Double
    {
        _div(castToComplexes(vectorA), vectorB)
    }
}


// MARK: - Vector-scalar operation

// MARK: ℂₙ + ℂ -> ℂₙ

public extension Vector where Element == Complex<Double>{
    static func add<ComplexVector>(_ vector: ComplexVector, _ scalar: Complex<Double>) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _add(vector, scalar: scalar)
    }
    static func subtract<ComplexVector>(_ vector: ComplexVector, _ scalar: Complex<Double>) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _sub(vector, scalar: scalar)
    }
    static func multiply<ComplexVector>(_ vector: ComplexVector, _ scalar: Complex<Double>) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _mul(vector, scalar: scalar)
    }
    static func multiply<ComplexVector>(conjugate vector: ComplexVector, _ scalar: Complex<Double>) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _mul(conj: vector, scalar: scalar)
    }
    static func divide<ComplexVector>(_ vector: ComplexVector, _ scalar: Complex<Double>) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _div(vector, scalar: scalar)
    }
}

public extension Vector where Element == DSPDoubleComplex{
    static func add<ComplexVector>(_ vector: ComplexVector, _ scalar: DSPDoubleComplex) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _add(vector, scalar: scalar)
    }
    static func subtract<ComplexVector>(_ vector: ComplexVector, _ scalar: DSPDoubleComplex) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _sub(vector, scalar: scalar)
    }
    static func multiply<ComplexVector>(_ vector: ComplexVector, _ scalar: DSPDoubleComplex) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _mul(vector, scalar: scalar)
    }
    static func multiply<ComplexVector>(conjugate vector: ComplexVector, _ scalar: DSPDoubleComplex) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _mul(conj: vector, scalar: scalar)
    }
    static func divide<ComplexVector>(_ vector: ComplexVector, _ scalar: DSPDoubleComplex) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _div(vector, scalar: scalar)
    }
}


// MARK: ℂ + ℂₙ -> ℂₙ

public extension Vector where Element == Complex<Double>{
    static func add<ComplexVector>(_ scalar: Complex<Double>, _ vector: ComplexVector) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _add(vector, scalar: scalar)
    }
    static func subtract<ComplexVector>(_ scalar: Complex<Double>, _ vector: ComplexVector) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _sub(scalar: scalar, vector)
    }
    static func multiply<ComplexVector>(_ scalar: Complex<Double>, _ vector: ComplexVector) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _mul(vector, scalar: scalar)
    }
    static func multiply<ComplexVector>(_ scalar: Complex<Double>, conjugate vector: ComplexVector) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _mul(conj: vector, scalar: scalar)
    }
    static func divide<ComplexVector>(_ scalar: Complex<Double>, _ vector: ComplexVector) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _div(scalar: scalar, vector)
    }
}

public extension Vector where Element == DSPDoubleComplex{
    static func add<ComplexVector>(_ scalar: DSPDoubleComplex, _ vector: ComplexVector) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _add(vector, scalar: scalar)
    }
    static func subtract<ComplexVector>(_ scalar: DSPDoubleComplex, _ vector: ComplexVector) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _sub(scalar: scalar, vector)
    }
    static func multiply<ComplexVector>(_ scalar: DSPDoubleComplex, _ vector: ComplexVector) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _mul(vector, scalar: scalar)
    }
    static func multiply<ComplexVector>(_ scalar: DSPDoubleComplex, conjugate vector: ComplexVector) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _mul(conj: vector, scalar: scalar)
    }
    static func divide<ComplexVector>(_ scalar: DSPDoubleComplex, _ vector: ComplexVector) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _div(scalar: scalar, vector)
    }
}

///////////////////////
///


// MARK: ℂₙ + ℝ -> ℂₙ

public extension Vector where Element == Complex<Double>{
    static func add<ComplexVector>(_ vector: ComplexVector, _ scalar: Double) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _add(vector, scalar: Element(real: scalar, imag: 0))
    }
    static func subtract<ComplexVector>(_ vector: ComplexVector, _ scalar: Double) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _sub(vector, scalar: Element(real: scalar, imag: 0))
    }
    static func multiply<ComplexVector>(_ vector: ComplexVector, _ scalar: Double) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _mul(vector, scalar: scalar)
    }
    static func divide<ComplexVector>(_ vector: ComplexVector, _ scalar: Double) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _div(vector, scalar: scalar)
    }
}

public extension Vector where Element == DSPDoubleComplex{
    static func add<ComplexVector>(_ vector: ComplexVector, _ scalar: Double) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _add(vector, scalar: Element(real: scalar, imag: 0))
    }
    static func subtract<ComplexVector>(_ vector: ComplexVector, _ scalar: Double) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _sub(vector, scalar: Element(real: scalar, imag: 0))
    }
    static func multiply<ComplexVector>(_ vector: ComplexVector, _ scalar: Double) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _mul(vector, scalar: scalar)
    }
    static func divide<ComplexVector>(_ vector: ComplexVector, _ scalar: Double) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _div(vector, scalar: scalar)
    }
}


// MARK: ℝ + ℂₙ -> ℂₙ

public extension Vector where Element == Complex<Double>{
    static func add<ComplexVector>(_ scalar: Double, _ vector: ComplexVector) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _add(vector, scalar: Element(real: scalar, imag: 0))
    }
    static func subtract<ComplexVector>(_ scalar: Double, _ vector: ComplexVector) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _sub(scalar: Element(real: scalar, imag: 0), vector)
    }
    static func multiply<ComplexVector>(_ scalar: Double, _ vector: ComplexVector) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _mul(vector, scalar: scalar)
    }
    static func divide<ComplexVector>(_ scalar: Double, _ vector: ComplexVector) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _div(scalar: Element(real: scalar, imag: 0), vector)
    }
}

public extension Vector where Element == DSPDoubleComplex{
    static func add<ComplexVector>(_ scalar: Double, _ vector: ComplexVector) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _add(vector, scalar: Element(real: scalar, imag: 0))
    }
    static func subtract<ComplexVector>(_ scalar: Double, _ vector: ComplexVector) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _sub(scalar: Element(real: scalar, imag: 0), vector)
    }
    static func multiply<ComplexVector>(_ scalar: Double, _ vector: ComplexVector) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _mul(vector, scalar: scalar)
    }
    static func divide<ComplexVector>(_ scalar: Double, _ vector: ComplexVector) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _div(scalar: Element(real: scalar, imag: 0), vector)
    }
}


// MARK: - Vector Reduction
// MARK: Dot Product

public extension Vector where Element == Complex<Double>{
    static func dot<ComplexVectorA, ComplexVectorB>
    (_ vectorA: ComplexVectorA, _ vectorB: ComplexVectorB) -> Complex<Double>
    where ComplexVectorA: AccelerateBuffer, ComplexVectorB: AccelerateBuffer,
          ComplexVectorA.Element == Complex<Double>, ComplexVectorB.Element == Complex<Double>
    {
        _dot(vectorA, vectorB)
    }
    static func dot<ComplexVectorA, ComplexVectorB>
    (conjugate vectorA: ComplexVectorA, _ vectorB: ComplexVectorB) -> Complex<Double>
    where ComplexVectorA: AccelerateBuffer, ComplexVectorB: AccelerateBuffer,
          ComplexVectorA.Element == Complex<Double>, ComplexVectorB.Element == Complex<Double>
    {
        _dot(conj: vectorA, vectorB)
    }
    
    static func dot<ComplexVectorA, ComplexVectorB>
    (_ vectorA: ComplexVectorA, conjugate vectorB: ComplexVectorB) -> Complex<Double>
    where ComplexVectorA: AccelerateBuffer, ComplexVectorB: AccelerateBuffer,
          ComplexVectorA.Element == Complex<Double>, ComplexVectorB.Element == Complex<Double>
    {
        _dot(conj: vectorB, vectorA)
    }
    
    static func dot<ComplexVector, RealVector>
    (_ vectorA: ComplexVector, _ vectorB: RealVector) -> Complex<Double>
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer,
          ComplexVector.Element == Complex<Double>, RealVector.Element == Double
    {
        _dot(vectorA, vectorB)
    }
    
    static func dot<RealVector, ComplexVector>
    (_ vectorA: RealVector, _ vectorB: ComplexVector) -> Complex<Double>
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer,
          ComplexVector.Element == Complex<Double>, RealVector.Element == Double
    {
        _dot(vectorB, vectorA)
    }
}
    

public extension Vector where Element == DSPDoubleComplex{
    static func dot<ComplexVectorA, ComplexVectorB>
    (_ vectorA: ComplexVectorA, _ vectorB: ComplexVectorB) -> DSPDoubleComplex
    where ComplexVectorA: AccelerateBuffer, ComplexVectorB: AccelerateBuffer,
          ComplexVectorA.Element == DSPDoubleComplex, ComplexVectorB.Element == DSPDoubleComplex
    {
        _dot(vectorA, vectorB)
    }
    static func dot<ComplexVectorA, ComplexVectorB>
    (conjugate vectorA: ComplexVectorA, _ vectorB: ComplexVectorB) -> DSPDoubleComplex
    where ComplexVectorA: AccelerateBuffer, ComplexVectorB: AccelerateBuffer,
          ComplexVectorA.Element == DSPDoubleComplex, ComplexVectorB.Element == DSPDoubleComplex
    {
        _dot(conj: vectorA, vectorB)
    }
    
    static func dot<ComplexVectorA, ComplexVectorB>
    (_ vectorA: ComplexVectorA, conjugate vectorB: ComplexVectorB) -> DSPDoubleComplex
    where ComplexVectorA: AccelerateBuffer, ComplexVectorB: AccelerateBuffer,
          ComplexVectorA.Element == DSPDoubleComplex, ComplexVectorB.Element == DSPDoubleComplex
    {
        _dot(conj: vectorB, vectorA)
    }
    
    static func dot<ComplexVector, RealVector>
    (_ vectorA: ComplexVector, _ vectorB: RealVector) -> DSPDoubleComplex
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer,
          ComplexVector.Element == DSPDoubleComplex, RealVector.Element == Double
    {
        _dot(vectorA, vectorB)
    }
    
    static func dot<RealVector, ComplexVector>
    (_ vectorA: RealVector, _ vectorB: ComplexVector) -> DSPDoubleComplex
    where ComplexVector: AccelerateBuffer, RealVector: AccelerateBuffer,
          ComplexVector.Element == DSPDoubleComplex, RealVector.Element == Double
    {
        _dot(vectorB, vectorA)
    }
}

// MARK: Array Reduction

public extension Vector where Element == Complex<Double>{
    static func sum<ComplexVector>(_ vector: ComplexVector) -> Complex<Double>
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _sum(vector)
    }
    static func sumOfSquareMagnitudes<ComplexVector>(_ vector: ComplexVector) -> Double
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _sum_sqMag(vector)
    }
    static func mean<ComplexVector>(_ vector: ComplexVector) -> Complex<Double>
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _mean(vector)
    }
    static func meanSquareMagnitudes<ComplexVector>(_ vector: ComplexVector) -> Double
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _mean_sqMag(vector)
    }
    static func rootMeanSquareMagnitude<ComplexVector>(_ vector: ComplexVector) -> Double
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _rmsMag(vector)
    }
}

public extension Vector where Element == DSPDoubleComplex{
    static func sum<ComplexVector>(_ vector: ComplexVector) -> DSPDoubleComplex
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _sum(vector)
    }
    static func sumOfSquareMagnitudes<ComplexVector>(_ vector: ComplexVector) -> Double
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _sum_sqMag(vector)
    }
    static func mean<ComplexVector>(_ vector: ComplexVector) -> DSPDoubleComplex
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _mean(vector)
    }
    static func meanSquareMagnitudes<ComplexVector>(_ vector: ComplexVector) -> Double
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _mean_sqMag(vector)
    }
    static func rootMeanSquareMagnitude<ComplexVector>(_ vector: ComplexVector) -> Double
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _rmsMag(vector)
    }
}

    
// MARK: - Single Function

// MARK: Complex Analysis

public extension Vector where Element == Complex<Double>{
    static func absolute<ComplexVector>(_ vector: ComplexVector) -> [Double]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _abs(vector)
    }
    static func conjugate<ComplexVector>(_ vector: ComplexVector) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _conj(vector)
    }
    static func negative<ComplexVector>(_ vector: ComplexVector) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _neg(vector)
    }
    static func phase<ComplexVector>(_ vector: ComplexVector) -> [Double]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _arg(vector)
    }
    static func squareMagnitudes<ComplexVector>(_ vector: ComplexVector) -> [Double]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _sqrMag(vector)
    }
}


public extension Vector where Element == DSPDoubleComplex{
    static func absolute<ComplexVector>(_ vector: ComplexVector) -> [Double]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _abs(vector)
    }
    static func conjugate<ComplexVector>(_ vector: ComplexVector) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _conj(vector)
    }
    static func negative<ComplexVector>(_ vector: ComplexVector) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _neg(vector)
    }
    static func phase<ComplexVector>(_ vector: ComplexVector) -> [Double]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _arg(vector)
    }
    static func squareMagnitudes<ComplexVector>(_ vector: ComplexVector) -> [Double]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _sqrMag(vector)
    }
}

// MARK: Logs and Exps

public extension Vector where Element == Complex<Double>{
    static func log<ComplexVector>(_ vector: ComplexVector) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _log(vector)
    }
    static func exp<ComplexVector>(_ vector: ComplexVector) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _exp(vector)
    }
    static func expi<ComplexVector>(_ vector: ComplexVector) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _expi(vector)
    }
    static func expi<RealVector>(_ vector: RealVector) -> [Complex<Double>]
    where RealVector: AccelerateBuffer, RealVector.Element == Double
    {
        _expi(vector)
    }
    static func sqrt<ComplexVector>(_ vector: ComplexVector) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _sqrt(vector)
    }
}

public extension Vector where Element == DSPDoubleComplex{
    static func log<ComplexVector>(_ vector: ComplexVector) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _log(vector)
    }
    static func exp<ComplexVector>(_ vector: ComplexVector) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _exp(vector)
    }
    static func expi<ComplexVector>(_ vector: ComplexVector) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _expi(vector)
    }
    static func expi<RealVector>(_ vector: RealVector) -> [DSPDoubleComplex]
    where RealVector: AccelerateBuffer, RealVector.Element == Double
    {
        _expi(vector)
    }
    static func sqrt<ComplexVector>(_ vector: ComplexVector) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _sqrt(vector)
    }
}

// MARK: Powers


public extension Vector where Element == Complex<Double>{
    static func pow<ComplexBaseVector, ComplexExponentVector>(bases: ComplexBaseVector, exponents: ComplexExponentVector) -> [Complex<Double>]
    where ComplexBaseVector: AccelerateBuffer, ComplexExponentVector: AccelerateBuffer, ComplexBaseVector.Element == Complex<Double>, ComplexExponentVector.Element == Complex<Double>
    {
        _pow(bases: bases, exponents: exponents)
    }
    static func pow<RealBaseVector, ComplexExponentVector>(bases: RealBaseVector, exponents: ComplexExponentVector) -> [Complex<Double>]
    where RealBaseVector: AccelerateBuffer, ComplexExponentVector: AccelerateBuffer, RealBaseVector.Element == Double, ComplexExponentVector.Element == Complex<Double>
    {
        _pow(bases: bases, exponents: exponents)
    }
    static func pow<ComplexBaseVector, RealExponentVector>(bases: ComplexBaseVector, exponents: RealExponentVector) -> [Complex<Double>]
    where ComplexBaseVector: AccelerateBuffer, RealExponentVector: AccelerateBuffer, ComplexBaseVector.Element == Complex<Double>, RealExponentVector.Element == Double
    {
        _pow(bases: bases, exponents: exponents)
    }
    
    static func pow<ComplexExponentVector>(base: Complex<Double>, exponents: ComplexExponentVector) -> [Complex<Double>]
    where ComplexExponentVector: AccelerateBuffer, ComplexExponentVector.Element == Complex<Double>
    {
        _pow(base: base, exponents: exponents)
    }
    static func pow<ComplexExponentVector>(base: Double, exponents: ComplexExponentVector) -> [Complex<Double>]
    where ComplexExponentVector: AccelerateBuffer, ComplexExponentVector.Element == Complex<Double>
    {
        _pow(base: base, exponents: exponents)
    }
    static func pow<RealExponentVector>(base: Complex<Double>, exponents: RealExponentVector) -> [Complex<Double>]
    where RealExponentVector: AccelerateBuffer, RealExponentVector.Element == Double
    {
        _pow(base: base, exponents: exponents)
    }
    
    
    static func pow<ComplexBaseVector>(bases: ComplexBaseVector, exponent: Complex<Double>) -> [Complex<Double>]
    where ComplexBaseVector: AccelerateBuffer, ComplexBaseVector.Element == Complex<Double>
    {
        _pow(bases: bases, exponent: exponent)
    }
    static func pow<RealBaseVector>(bases: RealBaseVector, exponent: Complex<Double>) -> [Complex<Double>]
    where RealBaseVector: AccelerateBuffer, RealBaseVector.Element == Double
    {
        _pow(bases: bases, exponent: exponent)
    }
    static func pow<ComplexBaseVector>(bases: ComplexBaseVector, exponent: Double) -> [Complex<Double>]
    where ComplexBaseVector: AccelerateBuffer, ComplexBaseVector.Element == Complex<Double>
    {
        _pow(bases: bases, exponent: exponent)
    }
}

public extension Vector where Element == DSPDoubleComplex{
    static func pow<ComplexBaseVector, ComplexExponentVector>(bases: ComplexBaseVector, exponents: ComplexExponentVector) -> [DSPDoubleComplex]
    where ComplexBaseVector: AccelerateBuffer, ComplexExponentVector: AccelerateBuffer, ComplexBaseVector.Element == DSPDoubleComplex, ComplexExponentVector.Element == DSPDoubleComplex
    {
        _pow(bases: bases, exponents: exponents)
    }
    static func pow<RealBaseVector, ComplexExponentVector>(bases: RealBaseVector, exponents: ComplexExponentVector) -> [DSPDoubleComplex]
    where RealBaseVector: AccelerateBuffer, ComplexExponentVector: AccelerateBuffer, RealBaseVector.Element == Double, ComplexExponentVector.Element == DSPDoubleComplex
    {
        _pow(bases: bases, exponents: exponents)
    }
    static func pow<ComplexBaseVector, RealExponentVector>(bases: ComplexBaseVector, exponents: RealExponentVector) -> [DSPDoubleComplex]
    where ComplexBaseVector: AccelerateBuffer, RealExponentVector: AccelerateBuffer, ComplexBaseVector.Element == DSPDoubleComplex, RealExponentVector.Element == Double
    {
        _pow(bases: bases, exponents: exponents)
    }
    
    static func pow<ComplexExponentVector>(base: DSPDoubleComplex, exponents: ComplexExponentVector) -> [DSPDoubleComplex]
    where ComplexExponentVector: AccelerateBuffer, ComplexExponentVector.Element == DSPDoubleComplex
    {
        _pow(base: base, exponents: exponents)
    }
    static func pow<ComplexExponentVector>(base: Double, exponents: ComplexExponentVector) -> [DSPDoubleComplex]
    where ComplexExponentVector: AccelerateBuffer, ComplexExponentVector.Element == DSPDoubleComplex
    {
        _pow(base: base, exponents: exponents)
    }
    static func pow<RealExponentVector>(base: DSPDoubleComplex, exponents: RealExponentVector) -> [DSPDoubleComplex]
    where RealExponentVector: AccelerateBuffer, RealExponentVector.Element == Double
    {
        _pow(base: base, exponents: exponents)
    }
    
    
    static func pow<ComplexBaseVector>(bases: ComplexBaseVector, exponent: DSPDoubleComplex) -> [DSPDoubleComplex]
    where ComplexBaseVector: AccelerateBuffer, ComplexBaseVector.Element == DSPDoubleComplex
    {
        _pow(bases: bases, exponent: exponent)
    }
    static func pow<RealBaseVector>(bases: RealBaseVector, exponent: DSPDoubleComplex) -> [DSPDoubleComplex]
    where RealBaseVector: AccelerateBuffer, RealBaseVector.Element == Double
    {
        _pow(bases: bases, exponent: exponent)
    }
    static func pow<ComplexBaseVector>(bases: ComplexBaseVector, exponent: Double) -> [DSPDoubleComplex]
    where ComplexBaseVector: AccelerateBuffer, ComplexBaseVector.Element == DSPDoubleComplex
    {
        _pow(bases: bases, exponent: exponent)
    }
}

// MARK: Trigonometric Functions

public extension Vector where Element == Complex<Double>{
    static func cos<ComplexVector>(_ vector: ComplexVector) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _cos(vector)
    }
    static func sin<ComplexVector>(_ vector: ComplexVector) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _sin(vector)
    }
    static func tan<ComplexVector>(_ vector: ComplexVector) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _tan(vector)
    }
    static func cot<ComplexVector>(_ vector: ComplexVector) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _cot(vector)
    }
    static func acos<ComplexVector>(_ vector: ComplexVector) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _acos(vector)
    }
    static func asin<ComplexVector>(_ vector: ComplexVector) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _asin(vector)
    }
    static func atan<ComplexVector>(_ vector: ComplexVector) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _atan(vector)
    }
    static func acot<ComplexVector>(_ vector: ComplexVector) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _acot(vector)
    }
}

public extension Vector where Element == DSPDoubleComplex{
    static func cos<ComplexVector>(_ vector: ComplexVector) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _cos(vector)
    }
    static func sin<ComplexVector>(_ vector: ComplexVector) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _sin(vector)
    }
    static func tan<ComplexVector>(_ vector: ComplexVector) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _tan(vector)
    }
    static func cot<ComplexVector>(_ vector: ComplexVector) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _cot(vector)
    }
    static func acos<ComplexVector>(_ vector: ComplexVector) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _acos(vector)
    }
    static func asin<ComplexVector>(_ vector: ComplexVector) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _asin(vector)
    }
    static func atan<ComplexVector>(_ vector: ComplexVector) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _atan(vector)
    }
    static func acot<ComplexVector>(_ vector: ComplexVector) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _acot(vector)
    }
}

// MARK: Hyperbolic Functions

public extension Vector where Element == Complex<Double>{
    static func cosh<ComplexVector>(_ vector: ComplexVector) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _cosh(vector)
    }
    static func sinh<ComplexVector>(_ vector: ComplexVector) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _sinh(vector)
    }
    static func tanh<ComplexVector>(_ vector: ComplexVector) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _tanh(vector)
    }
    static func coth<ComplexVector>(_ vector: ComplexVector) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _coth(vector)
    }
    static func acosh<ComplexVector>(_ vector: ComplexVector) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _acosh(vector)
    }
    static func asinh<ComplexVector>(_ vector: ComplexVector) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _asinh(vector)
    }
    static func atanh<ComplexVector>(_ vector: ComplexVector) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _atanh(vector)
    }
    static func acoth<ComplexVector>(_ vector: ComplexVector) -> [Complex<Double>]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Double>
    {
        _acoth(vector)
    }
}

public extension Vector where Element == DSPDoubleComplex{
    static func cosh<ComplexVector>(_ vector: ComplexVector) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _cosh(vector)
    }
    static func sinh<ComplexVector>(_ vector: ComplexVector) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _sinh(vector)
    }
    static func tanh<ComplexVector>(_ vector: ComplexVector) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _tanh(vector)
    }
    static func coth<ComplexVector>(_ vector: ComplexVector) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _coth(vector)
    }
    static func acosh<ComplexVector>(_ vector: ComplexVector) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _acosh(vector)
    }
    static func asinh<ComplexVector>(_ vector: ComplexVector) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _asinh(vector)
    }
    static func atanh<ComplexVector>(_ vector: ComplexVector) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _atanh(vector)
    }
    static func acoth<ComplexVector>(_ vector: ComplexVector) -> [DSPDoubleComplex]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == DSPDoubleComplex
    {
        _acoth(vector)
    }
}
