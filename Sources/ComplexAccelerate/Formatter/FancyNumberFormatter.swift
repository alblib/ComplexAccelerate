//
//  FanceNumberFormatter.swift
//  
//
//  Created by Albertus Liberius on 2023-01-18.
//

import Foundation

public class FancyNumberFormatter: NumberFormatter{
    public var usesThinSpaces: Bool = false
    public var isFancy: Bool = true
    public override func string(from number: NSNumber) -> String? {
        guard let result = NumberFormatter.string(self)(from: number) else {
            return nil
        }
        guard isFancy else{
            return result
        }
        return StringSubstituter.makeFancy(result, isStrictlyScientific: true, usesThinSpaces: usesThinSpaces)
    }
}
