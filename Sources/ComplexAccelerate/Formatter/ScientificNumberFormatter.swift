//
//  ScientificNumberFormatter.swift
//  
//
//  Created by Albertus Liberius on 2023-01-18.
//

import Foundation

public class ScientificNumberFormatter: NumberFormatter{
    /// Indicates whether the thin space is used in proper places when ``isHumanstyle`` is true. In console, the thin space has no proper width, so this is false by default. Turn this on for labels.
    public var usesThinSpaces: Bool = false
    /// Indicates whether the scientific notation uses math symbols instead of machine notation.
    public var isHumanStyle: Bool = true
    /// Indicates whether trival error of multiples of epsilons is chopped when printed only if the value is `Double`.
    public var chopsEpsilons: Bool = true
    public override func string(from number: NSNumber) -> String? {
        guard let result = super.string(from: number) else {
            return nil
        }
        guard isHumanStyle else{
            return result
        }
        guard numberStyle == .scientific else{
            return result
        }
        return StringSubstituter.makeFancy(result, isStrictlyScientific: true, usesThinSpaces: usesThinSpaces, chops: chopsEpsilons)
    }
    public func string(from number: Double) -> String? {
        return string(from: NSNumber(value: number))
    }
    public func string(from number: Float) -> String? {
        return string(from: NSNumber(value: number))
    }
    public func string(for number: NSNumber) -> String? {
        string(from: number)
    }
    public func string(for number: Double) -> String? {
        string(from: number)
    }
    public func string(for number: Float) -> String? {
        string(from: number)
    }
    override public init(){
        super.init()
        super.numberStyle = .scientific
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
