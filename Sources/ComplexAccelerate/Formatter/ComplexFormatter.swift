//
//  ComplexFormatter.swift
//  
//
//  Created by Albertus Liberius on 2023-01-17.
//

import Foundation
public class ComplexFormatter: Formatter{
    /// The system number formatter where most number printing style is defined.
    ///
    /// The is `NumberFormatter` which this formatter is based on. The
    @NSCopying public var realNumberFormatter = ScientificNumberFormatter()
    @frozen public enum ComplexFormatType{
        case cartesian
        case algebraic
    }
    public var complexPrintingType: ComplexFormatType = .algebraic
    public var usesThinSpaces: Bool{
        get{
            realNumberFormatter.usesThinSpaces
        }
        set{
            realNumberFormatter.usesThinSpaces = newValue
        }
    }
    public override init(){
        super.init()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    public func string(for number: Complex<Any>) -> String?{
        guard let realStr = realNumberFormatter.string(for: number.real) else{
            return nil
        }
        guard let imagStr = realNumberFormatter.string(for: number.imag) else{
            return nil
        }
        if complexPrintingType == .algebraic{
            let thinSpace = usesThinSpaces ? StringSubstituter.thinSpace : ""
            return realStr + thinSpace + "+" + thinSpace + imagStr + thinSpace + "𝒊"
        }else{
            return "(" + realStr + ", " + imagStr + ")"
        }
    }
    public func string(from: Complex<Any>) -> String?{
        string(for: from)
    }
}

