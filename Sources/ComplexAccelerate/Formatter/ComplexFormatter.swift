//
//  ComplexFormatter.swift
//  
//
//  Created by Albertus Liberius on 2023-01-17.
//

import Foundation
/// Prints a complex number in various styles.
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
    public func string<Element>(for number: Complex<Element>) -> String?{
        if Element.self is Double.Type{
            guard let realStr = realNumberFormatter.string(for: number.real as! Double) else{
                return nil
            }
            guard let imagStr = realNumberFormatter.string(for: number.imag as! Double) else{
                return nil
            }
            if complexPrintingType == .algebraic{
                let thinSpace = usesThinSpaces ? StringSubstituter.thinSpace : ""
                return realStr + thinSpace + "+" + thinSpace + imagStr + thinSpace + "𝒊"
            }else{
                return "(" + realStr + ", " + imagStr + ")"
            }
        }else if Element.self is Float.Type{
            guard let realStr = realNumberFormatter.string(for: number.real as! Float) else{
                return nil
            }
            guard let imagStr = realNumberFormatter.string(for: number.imag as! Float) else{
                return nil
            }
            if complexPrintingType == .algebraic{
                let thinSpace = usesThinSpaces ? StringSubstituter.thinSpace : ""
                return realStr + thinSpace + "+" + thinSpace + imagStr + thinSpace + "𝒊"
            }else{
                return "(" + realStr + ", " + imagStr + ")"
            }
        }else{
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
    }
    public func string<Element>(from: Complex<Element>) -> String?{
        string(for: from)
    }
}

