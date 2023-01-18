//
//  Subscripter.swift
//  
//
//  Created by Albertus Liberius on 2023-01-17.
//

import Foundation

/// Accomodates string substitution function.
public class StringSubstituter{
    /// Substitutes characters in the given character set to the characters in the other character set from the given string.
    ///
    /// This function, first, finds the chacracters in `find` from `from`. Then, nth character of `find` string would be substituted with nth character of `with`.
    /// - Parameters:
    ///     - from: The string the substitution should occur.
    ///     - find: The character set that shall be substituted.
    ///     - with: The replacing character set in the same order with `find`
    ///
    /// > Note: Even if `find` and `with` have different length, error is prevented and just the substitution does not occur for the size-mismatched part.
    ///
    /// > Remark: Character counts in `Character` unit not `Unicode.Scalar`. Be aware that some character like national flags requires two scalars to make one character.
    public static func substitute(_ from: any StringProtocol, find characterSet: any StringProtocol, with substituteCharSet: any StringProtocol) -> String{
        let map: [String.Element] = from.map{ ch in
            if let idx = characterSet.firstIndex(of: ch){
                let intIdx: Int = characterSet.distance(from: characterSet.startIndex, to: idx)
                if intIdx >= substituteCharSet.count{
                    return ch
                }else{
                    let returnIndex: String.Index = substituteCharSet.index(substituteCharSet.startIndex, offsetBy: intIdx, limitedBy: substituteCharSet.endIndex)!
                    return substituteCharSet[returnIndex]
                }
            }else{
                return ch
            }
        }
        return String(map)
    }
    
    /// Substitutes the given flat string with superscript version unicode characters if available.
    public static func convertToSuperscript(_ flatString: any StringProtocol) -> String{
        substitute(
            flatString,
            find: "0123456789+-=()ABDEGHIJKLMNOPRTUVWabcdefghijklmnoprstuvwxyzβ𝛽ꞵγƔ𝛾δẟ𝛿ε𝜀θ𝜃ɩιυ𝜐φ𝜑χ",
            with: "⁰¹²³⁴⁵⁶⁷⁸⁹⁺⁻⁼⁽⁾ᴬᴮᴰᴱᴳᴴᴵᴶᴷᴸᴹᴺᴼᴾᴿᵀᵁⱽᵂᵃᵇᶜᵈᵉᶠᵍʰⁱʲᵏˡᵐⁿᵒᵖʳˢᵗᵘᵛʷˣʸᶻᵝᵝᵝᵞᵞᵞᵟᵟᵟᵋᵋᶿᶿᶥᶥᶹᶹᵠᵠᵡ")
    }
    
    /// Substitutes the given flat string with subscript version unicode characters if available.
    public static func convertToSubscript(_ flatString: any StringProtocol) -> String{
        substitute(
            flatString,
            find: "0123456789+-=()aehijklmnoprstuvxβ𝛽ꞵγƔ𝛾ρϱ⍴𝛒𝛠𝜌𝜚𝝆𝝔𝞀𝞎𝞺𝟈φ𝜑χ",
            with: "₀₁₂₃₄₅₆₇₈₉₊₋₌₍₎ₐₑₕᵢⱼₖₗₘₙₒₚᵣₛₜᵤᵥₓᵦᵦᵦᵧᵧᵧᵨᵨᵨᵨᵨᵨᵨᵨᵨᵨᵨᵨᵨᵩᵩᵪ")
    }
    /// Converts the scientific style floating point description to human-written style.
    public static func makeFancy(_ scientific: String, isStrictlyScientific: Bool = false) -> String{
        var Eseparated = scientific.split(separator: "e", maxSplits: 2)
        if Eseparated.count != 2{
            Eseparated = scientific.split(separator: "E", maxSplits: 2)
            if Eseparated.count != 2{
                return scientific
            }
        }
        let result = Eseparated[0] + "×10" + convertToSuperscript(String(Eseparated[1]))
        if isStrictlyScientific{
            return result
        }
        if ["1", "1.0"].contains(Eseparated[0]){
            return "10" + convertToSuperscript(String(Eseparated[1]))
        }else if ["0", "0.0"].contains(Eseparated[0]){
            return "0"
        }else{
            return result
        }
    }
}
