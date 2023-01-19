//
//  AudioPhase.swift
//  
//
//  Created by Albertus Liberius on 2023-01-19.
//

import Foundation
import Accelerate

/// Represents phase of a complex number.
public struct AudioPhase: ExpressibleByFloatLiteral{
    public var inRadians: Double
    public var inDegrees: Double{
        get{
            inRadians / .pi * 180
        }
        set{
            inRadians = newValue / 180 * .pi
        }
    }
    public init(){
        self.inRadians = .zero
    }
    public init(inRadians: Double){
        self.inRadians = inRadians
    }
    public init(inDegrees: Double){
        self.inRadians = inDegrees / 180 * .pi
    }
    public init(phaseOf z: Complex<Float>){
        self.inRadians = Double(arg(z))
    }
    public init(phaseOf z: Complex<Double>){
        self.inRadians = arg(z)
    }
    public init(phaseOf z: DSPComplex){
        self.inRadians = Double(atan2(z.imag, z.real))
    }
    public init(phaseOf z: DSPDoubleComplex){
        self.inRadians = atan2(z.imag, z.real)
    }
    public init(floatLiteral value: FloatLiteralType) {
        inRadians = value
    }
    public func added(winding: Int) -> AudioPhase{
        return Self(inRadians: inRadians + Double(winding) * 2 * .pi)
    }
}

extension AudioPhase: AdditiveArithmetic{
    
    public static var zero: AudioPhase {
        AudioPhase(inRadians: .zero)
    }
    public static func + (lhs: AudioPhase, rhs: AudioPhase) -> AudioPhase{
        AudioPhase(inRadians: lhs.inRadians + rhs.inRadians)
    }
    
    public static func - (lhs: AudioPhase, rhs: AudioPhase) -> AudioPhase {
        AudioPhase(inRadians: lhs.inRadians - rhs.inRadians)
    }
}

extension AudioPhase{
    public static func * (lhs: AudioPhase, rhs: Double) -> AudioPhase{
        AudioPhase(inRadians: lhs.inRadians * rhs)
    }
    public static func * (lhs: AudioPhase, rhs: Float) -> AudioPhase{
        AudioPhase(inRadians: lhs.inRadians * Double(rhs))
    }
    public static func * (lhs: AudioPhase, rhs: Int) -> AudioPhase{
        AudioPhase(inRadians: lhs.inRadians * Double(rhs))
    }
    public static func * (lhs: Double, rhs: AudioPhase) -> AudioPhase{
        AudioPhase(inRadians: lhs * rhs.inRadians)
    }
    public static func * (lhs: Float, rhs: AudioPhase) -> AudioPhase{
        AudioPhase(inRadians: Double(lhs) * rhs.inRadians)
    }
    public static func * (lhs: Int, rhs: AudioPhase) -> AudioPhase{
        AudioPhase(inRadians: Double(lhs) * rhs.inRadians)
    }
}

extension AudioPhase: CustomStringConvertible{
    internal static let formatter: MeasurementFormatter = {
        let result = MeasurementFormatter()
        result.unitOptions = .providedUnit
        result.unitStyle = .short
        return result
    }()
    public var description: String{
        Self.formatter.string(from:
            Measurement(value: inRadians, unit: UnitAngle.radians).converted(to: .degrees)
        )
    }
}

extension Vector where Element == AudioPhase{
    public static func create<DoubleVector>(radians: DoubleVector) -> [AudioPhase]
    where DoubleVector: AccelerateBuffer, DoubleVector.Element == Double
    {
        [AudioPhase](unsafeUninitializedCapacity: radians.count) { buffer, initializedCount in
            buffer.withMemoryRebound(to: Double.self) { buffer in
                let output = UnsafeMutableRawBufferPointer(buffer)
                radians.withUnsafeBufferPointer{ iBuffer in
                    output.copyMemory(from: UnsafeRawBufferPointer(iBuffer))
                }
            }
            initializedCount = radians.count
        }
    }
    
    public static func create<FloatVector>(radians: FloatVector) -> [AudioPhase]
    where FloatVector: AccelerateBuffer, FloatVector.Element == Float
    {
        create(radians: vDSP.floatToDouble(radians))
    }
    public static func createPhases<DSPDoubleComplexVector>(from complexNumbers: DSPDoubleComplexVector) -> [AudioPhase]
    where DSPDoubleComplexVector: AccelerateBuffer, DSPDoubleComplexVector.Element == DSPDoubleComplex
    {
        create(radians: Vector<DSPDoubleComplex>.phase(complexNumbers))
    }
    public static func createPhases<DSPComplexVector>(from complexNumbers: DSPComplexVector) -> [AudioPhase]
    where DSPComplexVector: AccelerateBuffer, DSPComplexVector.Element == DSPComplex
    {
        create(radians: Vector<DSPComplex>.phase(complexNumbers))
    }
    public static func createPhases<DoubleComplexVector>(from complexNumbers: DoubleComplexVector) -> [AudioPhase]
    where DoubleComplexVector: AccelerateBuffer, DoubleComplexVector.Element == Complex<Double>
    {
        create(radians: Vector<Complex<Double>>.phase(complexNumbers))
    }
    public static func createPhases<ComplexVector>(from complexNumbers: ComplexVector) -> [AudioPhase]
    where ComplexVector: AccelerateBuffer, ComplexVector.Element == Complex<Float>
    {
        create(radians: Vector<Complex<Float>>.phase(complexNumbers))
    }
    public static func convertToContinuousBranch<PhaseVector>(phaseVector: PhaseVector) -> [AudioPhase]
    where PhaseVector: AccelerateBuffer, PhaseVector.Element == AudioPhase
    {
        [AudioPhase](unsafeUninitializedCapacity: phaseVector.count) { outputBuffer, initializedCount in
            phaseVector.withUnsafeBufferPointer { inputBuffer in
                guard var iptr = inputBuffer.baseAddress else{
                    return
                }
                guard var optr = outputBuffer.baseAddress else{
                    return
                }
                optr.initialize(to: iptr.pointee)
                var prev_input = iptr.pointee
                var wind: Int = 0
                for _ in 1..<phaseVector.count{
                    optr += 1
                    iptr += 1
                    if (iptr.pointee.inRadians - prev_input.inRadians > Double.pi){
                        wind -= 1
                    }else if (iptr.pointee.inRadians - prev_input.inRadians < -Double.pi){
                        wind += 1
                    }
                    optr.initialize(to: AudioPhase(inRadians: iptr.pointee.inRadians + Double(wind) * 2 * .pi))
                    prev_input = iptr.pointee
                }
            }
            initializedCount = phaseVector.count
        }
    }
    
    public static func radians<PhaseVector>(_ phaseVector: PhaseVector) -> [Double]
    where PhaseVector: AccelerateBuffer, PhaseVector.Element == AudioPhase
    {
        [Double](unsafeUninitializedCapacity: phaseVector.count) { buffer, initializedCount in
            phaseVector.withUnsafeBufferPointer{ iBuffer in
                iBuffer.withMemoryRebound(to: Double.self) { iBuffer in
                    let output = UnsafeMutableRawBufferPointer(buffer)
                    let input = UnsafeRawBufferPointer(iBuffer)
                    output.copyMemory(from: input)
                }
            }
            initializedCount = phaseVector.count
        }
    }
    public static func degrees<PhaseVector>(_ phaseVector: PhaseVector) -> [Double]
    where PhaseVector: AccelerateBuffer, PhaseVector.Element == AudioPhase
    {
        vDSP.multiply(180 / Double.pi, radians(phaseVector))
    }
}
