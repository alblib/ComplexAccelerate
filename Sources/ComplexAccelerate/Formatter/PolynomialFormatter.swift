//
//  PolynomialFormatter.swift
//
//
//  Created by Albertus Liberius on 2022-12-12.
//

import Foundation

/// Defines the style to convert ``Polynomial`` and ``PolynomialFraction`` to `String`.
public class PolynomialFormatter{
    
    /// Defines the indefinitive of the polynomial.
    public struct Monomial: CustomStringConvertible, ExpressibleByStringLiteral{
        public let product: [(symbol: String, exponent: Int64)]
        private init(product: [(symbol: String, exponent: Int64)]){
            self.product = product
        }
        public init(_ variable: String, exponent: Int64 = 1){
            self.product = [(symbol: variable, exponent: exponent)]
        }
        public init(stringLiteral value: StringLiteralType) {
            self.product = [(symbol: value, exponent: 1)]
        }
        public static func * (lhs: Self, rhs: Self) -> Self{
            if lhs.product.count < rhs.product.count{
                return rhs * lhs
            }
            var batch: [String: Int64] = Dictionary(uniqueKeysWithValues: lhs.product.map{($0.symbol, $0.exponent)})
            for element in rhs.product{
                if let variableExponent = batch[element.symbol]{
                    batch[element.symbol] = variableExponent + element.exponent
                }else{
                    batch[element.symbol] = element.exponent
                }
            }
            return Self.init(product: batch.map{(symbol: $0.key, exponent: $0.value)})
        }
        public static func pow(_ base: Self, _ exponent: Int64) -> Self{
            Self.init(product: base.product.map{(symbol: $0.symbol, exponent: $0.exponent * exponent)})
        }
        public static func pow(_ base: Self, _ exponent: Int) -> Self{
            pow(base, Int64(exponent))
        }
        public var description: String{
            product.sorted(by: { $0.symbol < $1.symbol}).map{
                switch $0.exponent{
                case 0:
                    return ""
                case 1:
                    return $0.symbol
                default:
                    return $0.symbol + StringSubstituter.convertToSuperscript($0.exponent.description)
                }
            }.joined(separator: StringSubstituter.thinSpace)
        }
    }
    
    
    /// Defines the description of the base variable of the monomials.
    public var variable: Monomial = "𝑥"
    /// Defines the format of the coefficient. If `nil`, the formatter simplifies the number most.
    public var numberFormatter: NumberFormatter? = nil
    /// Defines whether to omit the terms with zero coefficients.
    public var omitsMonomials: Bool = true
    
    public init(){
    }
    public init(variable: Monomial){
        self.variable = variable
    }
    
    private func coefficientStringList<Coefficient>(coefficientList: [Coefficient]) -> [String]
    where Coefficient: CustomStringConvertible
    {
        return coefficientList.map{
            var coeff = $0.description
            if coeff.hasSuffix(".0"){
                coeff = String(coeff.prefix(coeff.count - 2))
            }
            return coeff
        }
    }
    
    private func coefficientStringList<Coefficient>(coefficientList: [Coefficient]) -> [String]
    where Coefficient: CustomStringConvertible & BinaryFloatingPoint
    {
        if numberFormatter != nil{
            return coefficientList.map{
                numberFormatter!.string(from: NSNumber(floatLiteral: Double($0)))!
            }
        }else{
            return coefficientList.map{
                var coeff = $0.description
                if coeff.hasSuffix(".0"){
                    coeff = String(coeff.prefix(coeff.count - 2))
                }
                return coeff
            }
        }
    }
    
    public func string<Coefficient>(from polynomial: Polynomial<Coefficient>) -> String
    where Coefficient: CustomStringConvertible & AdditiveArithmetic
    {
        return string(from: polynomial, isBracketed: false)
    }
    
    private func string<Coefficient>(from polynomial: Polynomial<Coefficient>, isBracketed: Bool) -> String
    where Coefficient: CustomStringConvertible & AdditiveArithmetic
    {
        if polynomial.coefficients.isEmpty{
            return "0"
        }
        var coefficientList = Array(polynomial.coefficients.enumerated())
        if omitsMonomials && Coefficient.self is (any AdditiveArithmetic){
            coefficientList = coefficientList.filter{$0.element != .zero}
        }
        let coeffStrList =
            coefficientStringList(coefficientList: coefficientList.map{$0.element})
        let monomialStrList = coefficientList.map{Monomial.pow(self.variable, $0.offset).description}
        var termStrList = zip(coeffStrList, monomialStrList).map{
            if $0.1.isEmpty{
                return $0.0
            }else if $0.0 == "1"{
                return $0.1
            }else{
                return $0.0 + StringSubstituter.thinSpace + $0.1
            }
        }
        for i in 1..<termStrList.count{
            if termStrList[i].hasPrefix("-"){
                termStrList[i].removeFirst(1)
                termStrList[i] = " - " + termStrList[i]
            }else{
                termStrList[i] = " + " + termStrList[i]
            }
        }
        let result = termStrList.joined()
        if isBracketed && termStrList.count > 1{
            return "( " + result + " )"
        }else{
            return result
        }
    }
    
    public func string<Coefficient>(from polynomialFraction: PolynomialFraction<Coefficient>) -> String
    where Coefficient: CustomStringConvertible & AdditiveArithmetic & BinaryFloatingPoint
    {
        string(from: polynomialFraction.numerator, isBracketed: true) + " / "
        + string(from: polynomialFraction.denominator, isBracketed: true)
    }
}
