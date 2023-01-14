//
//  PolynomialFraction.swift
//  
//
//  Created by Albertus Liberius on 2023-01-14.
//

import Foundation
import Accelerate

public struct PolynomialFraction<Coefficient>
{
    public var numerator: Polynomial<Coefficient>
    public var denominator: Polynomial<Coefficient>
    
    public init(numerator: Polynomial<Coefficient>, denominator: Polynomial<Coefficient>) {
        self.numerator = numerator
        self.denominator = denominator
    }
}
extension PolynomialFraction where Coefficient: ExpressibleByIntegerLiteral{
    public var zero: Self{
        Self(numerator: .zero, denominator: .one)
    }
    public var one: Self{
        Self(numerator: .one, denominator: .one)
    }
}

// MARK: - Equatable

extension PolynomialFraction: Equatable where Coefficient: Equatable{
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.numerator == rhs.numerator && lhs.denominator == rhs.denominator
    }
}

extension PolynomialFraction where Coefficient: AdditiveArithmetic{
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.numerator == rhs.numerator && lhs.denominator == rhs.denominator
    }
}

// MARK: - AdditiveArithmetic

extension PolynomialFraction where Coefficient: Numeric{
    public static func + (lhs: Self, rhs: Self) -> Self{
        Self(numerator: lhs.numerator * rhs.denominator + lhs.denominator * rhs.numerator, denominator: lhs.denominator * rhs.denominator)
    }
    public static func += (lhs: inout Self, rhs: Self){
        lhs = lhs + rhs
    }
    public static func - (lhs: Self, rhs: Self) -> Self{
        Self(numerator: lhs.numerator * rhs.denominator - lhs.denominator * rhs.numerator, denominator: lhs.denominator * rhs.denominator)
    }
    public static func -= (lhs: inout Self, rhs: Self){
        lhs = lhs + rhs
    }
}
extension PolynomialFraction where Coefficient: SignedNumeric{
    public static prefix func - (_ operand: Self) -> Self{
        Self(numerator: -operand.numerator, denominator: operand.denominator)
    }
}
extension PolynomialFraction where Coefficient == Float{
    public static func + (lhs: Self, rhs: Self) -> Self{
        Self(numerator: lhs.numerator * rhs.denominator + lhs.denominator * rhs.numerator, denominator: lhs.denominator * rhs.denominator)
    }
    public static func += (lhs: inout Self, rhs: Self){
        lhs = lhs + rhs
    }
    public static func - (lhs: Self, rhs: Self) -> Self{
        Self(numerator: lhs.numerator * rhs.denominator - lhs.denominator * rhs.numerator, denominator: lhs.denominator * rhs.denominator)
    }
    public static func -= (lhs: inout Self, rhs: Self){
        lhs = lhs + rhs
    }
    public static prefix func - (_ operand: Self) -> Self{
        Self(numerator: -operand.numerator, denominator: operand.denominator)
    }
}
extension PolynomialFraction where Coefficient == Double{
    public static func + (lhs: Self, rhs: Self) -> Self{
        Self(numerator: lhs.numerator * rhs.denominator + lhs.denominator * rhs.numerator, denominator: lhs.denominator * rhs.denominator)
    }
    public static func += (lhs: inout Self, rhs: Self){
        lhs = lhs + rhs
    }
    public static func - (lhs: Self, rhs: Self) -> Self{
        Self(numerator: lhs.numerator * rhs.denominator - lhs.denominator * rhs.numerator, denominator: lhs.denominator * rhs.denominator)
    }
    public static func -= (lhs: inout Self, rhs: Self){
        lhs = lhs + rhs
    }
    public static prefix func - (_ operand: Self) -> Self{
        Self(numerator: -operand.numerator, denominator: operand.denominator)
    }
}
extension PolynomialFraction where Coefficient == DSPComplex{
    public static func + (lhs: Self, rhs: Self) -> Self{
        Self(numerator: lhs.numerator * rhs.denominator + lhs.denominator * rhs.numerator, denominator: lhs.denominator * rhs.denominator)
    }
    public static func += (lhs: inout Self, rhs: Self){
        lhs = lhs + rhs
    }
    public static func - (lhs: Self, rhs: Self) -> Self{
        Self(numerator: lhs.numerator * rhs.denominator - lhs.denominator * rhs.numerator, denominator: lhs.denominator * rhs.denominator)
    }
    public static func -= (lhs: inout Self, rhs: Self){
        lhs = lhs + rhs
    }
    public static prefix func - (_ operand: Self) -> Self{
        Self(numerator: -operand.numerator, denominator: operand.denominator)
    }
}
extension PolynomialFraction where Coefficient == DSPDoubleComplex{
    public static func + (lhs: Self, rhs: Self) -> Self{
        Self(numerator: lhs.numerator * rhs.denominator + lhs.denominator * rhs.numerator, denominator: lhs.denominator * rhs.denominator)
    }
    public static func += (lhs: inout Self, rhs: Self){
        lhs = lhs + rhs
    }
    public static func - (lhs: Self, rhs: Self) -> Self{
        Self(numerator: lhs.numerator * rhs.denominator - lhs.denominator * rhs.numerator, denominator: lhs.denominator * rhs.denominator)
    }
    public static func -= (lhs: inout Self, rhs: Self){
        lhs = lhs + rhs
    }
    public static prefix func - (_ operand: Self) -> Self{
        Self(numerator: -operand.numerator, denominator: operand.denominator)
    }
}
extension PolynomialFraction where Coefficient == Complex<Float>{
    public static func + (lhs: Self, rhs: Self) -> Self{
        Self(numerator: lhs.numerator * rhs.denominator + lhs.denominator * rhs.numerator, denominator: lhs.denominator * rhs.denominator)
    }
    public static func += (lhs: inout Self, rhs: Self){
        lhs = lhs + rhs
    }
    public static func - (lhs: Self, rhs: Self) -> Self{
        Self(numerator: lhs.numerator * rhs.denominator - lhs.denominator * rhs.numerator, denominator: lhs.denominator * rhs.denominator)
    }
    public static func -= (lhs: inout Self, rhs: Self){
        lhs = lhs + rhs
    }
    public static prefix func - (_ operand: Self) -> Self{
        Self(numerator: -operand.numerator, denominator: operand.denominator)
    }
}
extension PolynomialFraction where Coefficient == Complex<Double>{
    public static func + (lhs: Self, rhs: Self) -> Self{
        Self(numerator: lhs.numerator * rhs.denominator + lhs.denominator * rhs.numerator, denominator: lhs.denominator * rhs.denominator)
    }
    public static func += (lhs: inout Self, rhs: Self){
        lhs = lhs + rhs
    }
    public static func - (lhs: Self, rhs: Self) -> Self{
        Self(numerator: lhs.numerator * rhs.denominator - lhs.denominator * rhs.numerator, denominator: lhs.denominator * rhs.denominator)
    }
    public static func -= (lhs: inout Self, rhs: Self){
        lhs = lhs + rhs
    }
    public static prefix func - (_ operand: Self) -> Self{
        Self(numerator: -operand.numerator, denominator: operand.denominator)
    }
}

// MARK: - Multiplication

extension PolynomialFraction where Coefficient: Numeric{
    public static func * (lhs: Self, rhs: Self) -> Self{
        Self(numerator: lhs.numerator * rhs.numerator, denominator: lhs.denominator * rhs.denominator)
    }
    public static func *= (lhs: inout Self, rhs: Self){
        lhs = lhs * rhs
    }
    public static func * (lhs: Coefficient, rhs: Self) -> Self{
        Self(numerator: lhs * rhs.numerator, denominator: rhs.denominator)
    }
    public static func * (lhs: Self, rhs: Coefficient) -> Self{
        Self(numerator: lhs.numerator * rhs, denominator: lhs.denominator)
    }
    public static func *= (lhs: inout Self, rhs: Coefficient){
        lhs = lhs * rhs
    }
    public static func / (lhs: Self, rhs: Coefficient) -> Self{
        Self(numerator: lhs.numerator, denominator: lhs.denominator * rhs)
    }
    public static func /= (lhs: inout Self, rhs: Coefficient){
        lhs = lhs / rhs
    }
}
extension PolynomialFraction where Coefficient == Float{
    public static func * (lhs: Self, rhs: Self) -> Self{
        Self(numerator: lhs.numerator * rhs.numerator, denominator: lhs.denominator * rhs.denominator)
    }
    public static func *= (lhs: inout Self, rhs: Self){
        lhs = lhs * rhs
    }
    public static func * (lhs: Coefficient, rhs: Self) -> Self{
        Self(numerator: lhs * rhs.numerator, denominator: rhs.denominator)
    }
    public static func * (lhs: Self, rhs: Coefficient) -> Self{
        Self(numerator: lhs.numerator * rhs, denominator: lhs.denominator)
    }
    public static func *= (lhs: inout Self, rhs: Coefficient){
        lhs = lhs * rhs
    }
    public static func / (lhs: Self, rhs: Coefficient) -> Self{
        Self(numerator: lhs.numerator, denominator: lhs.denominator * rhs)
    }
    public static func /= (lhs: inout Self, rhs: Coefficient){
        lhs = lhs / rhs
    }
}
extension PolynomialFraction where Coefficient == Double{
    public static func * (lhs: Self, rhs: Self) -> Self{
        Self(numerator: lhs.numerator * rhs.numerator, denominator: lhs.denominator * rhs.denominator)
    }
    public static func *= (lhs: inout Self, rhs: Self){
        lhs = lhs * rhs
    }
    public static func * (lhs: Coefficient, rhs: Self) -> Self{
        Self(numerator: lhs * rhs.numerator, denominator: rhs.denominator)
    }
    public static func * (lhs: Self, rhs: Coefficient) -> Self{
        Self(numerator: lhs.numerator * rhs, denominator: lhs.denominator)
    }
    public static func *= (lhs: inout Self, rhs: Coefficient){
        lhs = lhs * rhs
    }
    public static func / (lhs: Self, rhs: Coefficient) -> Self{
        Self(numerator: lhs.numerator, denominator: lhs.denominator * rhs)
    }
    public static func /= (lhs: inout Self, rhs: Coefficient){
        lhs = lhs / rhs
    }
}
extension PolynomialFraction where Coefficient == DSPComplex{
    public static func * (lhs: Self, rhs: Self) -> Self{
        Self(numerator: lhs.numerator * rhs.numerator, denominator: lhs.denominator * rhs.denominator)
    }
    public static func *= (lhs: inout Self, rhs: Self){
        lhs = lhs * rhs
    }
    public static func * (lhs: Coefficient, rhs: Self) -> Self{
        Self(numerator: lhs * rhs.numerator, denominator: rhs.denominator)
    }
    public static func * (lhs: Self, rhs: Coefficient) -> Self{
        Self(numerator: lhs.numerator * rhs, denominator: lhs.denominator)
    }
    public static func *= (lhs: inout Self, rhs: Coefficient){
        lhs = lhs * rhs
    }
    public static func / (lhs: Self, rhs: Coefficient) -> Self{
        Self(numerator: lhs.numerator, denominator: lhs.denominator * rhs)
    }
    public static func /= (lhs: inout Self, rhs: Coefficient){
        lhs = lhs / rhs
    }
}
extension PolynomialFraction where Coefficient == DSPDoubleComplex{
    public static func * (lhs: Self, rhs: Self) -> Self{
        Self(numerator: lhs.numerator * rhs.numerator, denominator: lhs.denominator * rhs.denominator)
    }
    public static func *= (lhs: inout Self, rhs: Self){
        lhs = lhs * rhs
    }
    public static func * (lhs: Coefficient, rhs: Self) -> Self{
        Self(numerator: lhs * rhs.numerator, denominator: rhs.denominator)
    }
    public static func * (lhs: Self, rhs: Coefficient) -> Self{
        Self(numerator: lhs.numerator * rhs, denominator: lhs.denominator)
    }
    public static func *= (lhs: inout Self, rhs: Coefficient){
        lhs = lhs * rhs
    }
    public static func / (lhs: Self, rhs: Coefficient) -> Self{
        Self(numerator: lhs.numerator, denominator: lhs.denominator * rhs)
    }
    public static func /= (lhs: inout Self, rhs: Coefficient){
        lhs = lhs / rhs
    }
}
extension PolynomialFraction where Coefficient == Complex<Float>{
    public static func * (lhs: Self, rhs: Self) -> Self{
        Self(numerator: lhs.numerator * rhs.numerator, denominator: lhs.denominator * rhs.denominator)
    }
    public static func *= (lhs: inout Self, rhs: Self){
        lhs = lhs * rhs
    }
    public static func * (lhs: Coefficient, rhs: Self) -> Self{
        Self(numerator: lhs * rhs.numerator, denominator: rhs.denominator)
    }
    public static func * (lhs: Self, rhs: Coefficient) -> Self{
        Self(numerator: lhs.numerator * rhs, denominator: lhs.denominator)
    }
    public static func *= (lhs: inout Self, rhs: Coefficient){
        lhs = lhs * rhs
    }
    public static func / (lhs: Self, rhs: Coefficient) -> Self{
        Self(numerator: lhs.numerator, denominator: lhs.denominator * rhs)
    }
    public static func /= (lhs: inout Self, rhs: Coefficient){
        lhs = lhs / rhs
    }
}
extension PolynomialFraction where Coefficient == Complex<Double>{
    public static func * (lhs: Self, rhs: Self) -> Self{
        Self(numerator: lhs.numerator * rhs.numerator, denominator: lhs.denominator * rhs.denominator)
    }
    public static func *= (lhs: inout Self, rhs: Self){
        lhs = lhs * rhs
    }
    public static func * (lhs: Coefficient, rhs: Self) -> Self{
        Self(numerator: lhs * rhs.numerator, denominator: rhs.denominator)
    }
    public static func * (lhs: Self, rhs: Coefficient) -> Self{
        Self(numerator: lhs.numerator * rhs, denominator: lhs.denominator)
    }
    public static func *= (lhs: inout Self, rhs: Coefficient){
        lhs = lhs * rhs
    }
    public static func / (lhs: Self, rhs: Coefficient) -> Self{
        Self(numerator: lhs.numerator, denominator: lhs.denominator * rhs)
    }
    public static func /= (lhs: inout Self, rhs: Coefficient){
        lhs = lhs / rhs
    }
}


// MARK: - Division

extension Polynomial{
    public static func / (lhs: Polynomial<Coefficient>, rhs: Polynomial<Coefficient>) -> PolynomialFraction<Coefficient>{
        PolynomialFraction<Coefficient>(numerator: lhs, denominator: rhs)
    }
}
extension PolynomialFraction where Coefficient: Numeric{
    public static func / (lhs: Self, rhs: Self) -> Self{
        Self(numerator: lhs.numerator * rhs.denominator, denominator: lhs.denominator * rhs.numerator)
    }
    public static func / (lhs: Self, rhs: Polynomial<Coefficient>) -> Self{
        Self(numerator: lhs.numerator, denominator: lhs.denominator * rhs)
    }
    public static func / (lhs: Polynomial<Coefficient>, rhs: Self) -> Self{
        Self(numerator: lhs * rhs.denominator, denominator: rhs.numerator)
    }
    public static func /= (lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }
    public static func /= (lhs: inout Self, rhs: Polynomial<Coefficient>) {
        lhs = lhs / rhs
    }
}
extension PolynomialFraction where Coefficient == Float{
    public static func / (lhs: Self, rhs: Self) -> Self{
        Self(numerator: lhs.numerator * rhs.denominator, denominator: lhs.denominator * rhs.numerator)
    }
    public static func / (lhs: Self, rhs: Polynomial<Coefficient>) -> Self{
        Self(numerator: lhs.numerator, denominator: lhs.denominator * rhs)
    }
    public static func / (lhs: Polynomial<Coefficient>, rhs: Self) -> Self{
        Self(numerator: lhs * rhs.denominator, denominator: rhs.numerator)
    }
    public static func /= (lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }
    public static func /= (lhs: inout Self, rhs: Polynomial<Coefficient>) {
        lhs = lhs / rhs
    }
}
extension PolynomialFraction where Coefficient == Double{
    public static func / (lhs: Self, rhs: Self) -> Self{
        Self(numerator: lhs.numerator * rhs.denominator, denominator: lhs.denominator * rhs.numerator)
    }
    public static func / (lhs: Self, rhs: Polynomial<Coefficient>) -> Self{
        Self(numerator: lhs.numerator, denominator: lhs.denominator * rhs)
    }
    public static func / (lhs: Polynomial<Coefficient>, rhs: Self) -> Self{
        Self(numerator: lhs * rhs.denominator, denominator: rhs.numerator)
    }
    public static func /= (lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }
    public static func /= (lhs: inout Self, rhs: Polynomial<Coefficient>) {
        lhs = lhs / rhs
    }
}
extension PolynomialFraction where Coefficient == DSPComplex{
    public static func / (lhs: Self, rhs: Self) -> Self{
        Self(numerator: lhs.numerator * rhs.denominator, denominator: lhs.denominator * rhs.numerator)
    }
    public static func / (lhs: Self, rhs: Polynomial<Coefficient>) -> Self{
        Self(numerator: lhs.numerator, denominator: lhs.denominator * rhs)
    }
    public static func / (lhs: Polynomial<Coefficient>, rhs: Self) -> Self{
        Self(numerator: lhs * rhs.denominator, denominator: rhs.numerator)
    }
    public static func /= (lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }
    public static func /= (lhs: inout Self, rhs: Polynomial<Coefficient>) {
        lhs = lhs / rhs
    }
}
extension PolynomialFraction where Coefficient == DSPDoubleComplex{
    public static func / (lhs: Self, rhs: Self) -> Self{
        Self(numerator: lhs.numerator * rhs.denominator, denominator: lhs.denominator * rhs.numerator)
    }
    public static func / (lhs: Self, rhs: Polynomial<Coefficient>) -> Self{
        Self(numerator: lhs.numerator, denominator: lhs.denominator * rhs)
    }
    public static func / (lhs: Polynomial<Coefficient>, rhs: Self) -> Self{
        Self(numerator: lhs * rhs.denominator, denominator: rhs.numerator)
    }
    public static func /= (lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }
    public static func /= (lhs: inout Self, rhs: Polynomial<Coefficient>) {
        lhs = lhs / rhs
    }
}
extension PolynomialFraction where Coefficient == Complex<Float>{
    public static func / (lhs: Self, rhs: Self) -> Self{
        Self(numerator: lhs.numerator * rhs.denominator, denominator: lhs.denominator * rhs.numerator)
    }
    public static func / (lhs: Self, rhs: Polynomial<Coefficient>) -> Self{
        Self(numerator: lhs.numerator, denominator: lhs.denominator * rhs)
    }
    public static func / (lhs: Polynomial<Coefficient>, rhs: Self) -> Self{
        Self(numerator: lhs * rhs.denominator, denominator: rhs.numerator)
    }
    public static func /= (lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }
    public static func /= (lhs: inout Self, rhs: Polynomial<Coefficient>) {
        lhs = lhs / rhs
    }
}
extension PolynomialFraction where Coefficient == Complex<Double>{
    public static func / (lhs: Self, rhs: Self) -> Self{
        Self(numerator: lhs.numerator * rhs.denominator, denominator: lhs.denominator * rhs.numerator)
    }
    public static func / (lhs: Self, rhs: Polynomial<Coefficient>) -> Self{
        Self(numerator: lhs.numerator, denominator: lhs.denominator * rhs)
    }
    public static func / (lhs: Polynomial<Coefficient>, rhs: Self) -> Self{
        Self(numerator: lhs * rhs.denominator, denominator: rhs.numerator)
    }
    public static func /= (lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }
    public static func /= (lhs: inout Self, rhs: Polynomial<Coefficient>) {
        lhs = lhs / rhs
    }
}


// MARK: - Evaluation
extension PolynomialFraction where Coefficient == Float{
    public func evaluate(variable x: Float) -> Float{
        self.numerator.evaluate(variable: x) / self.denominator.evaluate(variable: x)
    }
    public func evaluate(variable values: [Float]) -> [Float]{
        Vector<Coefficient>.divide(self.numerator.evaluate(variable: values), self.denominator.evaluate(variable: values))
    }
    public func evaluate(variable values: [Complex<Float>]) -> [Complex<Float>]{
        Vector<Complex<Float>>.divide(self.numerator.evaluate(variable: values), self.denominator.evaluate(variable: values))
    }
    public func evaluate(variable values: [DSPComplex]) -> [DSPComplex]{
        Vector<DSPComplex>.divide(self.numerator.evaluate(variable: values), self.denominator.evaluate(variable: values))
    }
    public func evaluate(variable z: Complex<Float>) -> Complex<Float>{
        evaluate(variable: [z])[0]
    }
    public func evaluate(variable z: DSPComplex) -> DSPComplex{
        evaluate(variable: [z])[0]
    }
}
extension PolynomialFraction where Coefficient == Double{
    public func evaluate(variable x: Double) -> Double{
        self.numerator.evaluate(variable: x) / self.denominator.evaluate(variable: x)
    }
    public func evaluate(variable values: [Double]) -> [Double]{
        Vector<Coefficient>.divide(self.numerator.evaluate(variable: values), self.denominator.evaluate(variable: values))
    }
    public func evaluate(variable values: [Complex<Double>]) -> [Complex<Double>]{
        Vector<Complex<Double>>.divide(self.numerator.evaluate(variable: values), self.denominator.evaluate(variable: values))
    }
    public func evaluate(variable values: [DSPDoubleComplex]) -> [DSPDoubleComplex]{
        Vector<DSPDoubleComplex>.divide(self.numerator.evaluate(variable: values), self.denominator.evaluate(variable: values))
    }
    public func evaluate(variable z: Complex<Double>) -> Complex<Double>{
        evaluate(variable: [z])[0]
    }
    public func evaluate(variable z: DSPDoubleComplex) -> DSPDoubleComplex{
        evaluate(variable: [z])[0]
    }
}
extension PolynomialFraction where Coefficient == Complex<Float>{
    public func evaluate(variable x: Coefficient) -> Coefficient{
        self.numerator.evaluate(variable: x) / self.denominator.evaluate(variable: x)
    }
    public func evaluate(variable values: [Coefficient]) -> [Coefficient]{
        Vector<Coefficient>.divide(self.numerator.evaluate(variable: values), self.denominator.evaluate(variable: values))
    }
}
extension PolynomialFraction where Coefficient == Complex<Double>{
    public func evaluate(variable x: Coefficient) -> Coefficient{
        self.numerator.evaluate(variable: x) / self.denominator.evaluate(variable: x)
    }
    public func evaluate(variable values: [Coefficient]) -> [Coefficient]{
        Vector<Coefficient>.divide(self.numerator.evaluate(variable: values), self.denominator.evaluate(variable: values))
    }
}
extension PolynomialFraction where Coefficient == DSPComplex{
    public func evaluate(variable x: Coefficient) -> Coefficient{
        evaluate(variable: [x])[0]
    }
    public func evaluate(variable values: [Coefficient]) -> [Coefficient]{
        Vector<Coefficient>.divide(self.numerator.evaluate(variable: values), self.denominator.evaluate(variable: values))
    }
}
extension PolynomialFraction where Coefficient == DSPDoubleComplex{
    public func evaluate(variable x: Coefficient) -> Coefficient{
        evaluate(variable: [x])[0]
    }
    public func evaluate(variable values: [Coefficient]) -> [Coefficient]{
        Vector<Coefficient>.divide(self.numerator.evaluate(variable: values), self.denominator.evaluate(variable: values))
    }
}
