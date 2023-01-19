import XCTest
@testable import ComplexAccelerate

struct Test{
    var test: Complex<Double> = 1{
        didSet{
            print("didset")
        }
    }
}

final class ComplexAccelerateTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        //XCTAssertEqual(ComplexAccelerate().text, "Hello, World!")
        print("hey!")
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.minimumSignificantDigits = 2
        print(formatter.string(from: 1e-20))
        formatter.numberStyle = .spellOut
        print(formatter.string(from: 1e-20))
        formatter.numberStyle = .scientific
        print(formatter.string(from: 1e-20))
        formatter.numberStyle = .decimal
        print(formatter.string(for: 1e-20))
        
        let start = DispatchTime.now() // <<<<<<<<<< Start time
        
         let end = DispatchTime.now()   // <<<<<<<<<<   end time

         let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
         let timeInterval = Double(nanoTime) / 1_000_000_000 // Technically could overflow for long running tests

         print("Time to evaluate problem : \(timeInterval) seconds")
        print(StringSubstituter.makeFancy("1E-4"))
        print(StringSubstituter.makeFancy(0.12345678901234567890.description))
        print(StringSubstituter.makeFancy(1.2345678000004567890e16.description, chops: true))
        print(1.2345678000004567890e16.description)
        print("003400".replacingOccurrences(of: "^0+", with: "", options: .regularExpression))
        print("32.623.2".replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range: nil))
        print("003400".replacingOccurrences(of: "0+$", with: "", options: .regularExpression))
        print(ComplexFormatter().string(from: Complex<Double>(real:2, imag:1)))
        print(ScientificNumberFormatter().string(for: 2.0))
        print(Int64(+2).description)
        print(PolynomialFormatter().string(from: Polynomial(coefficients: [1,2,4])))
        var a = Test()
        a.test.real = 2
        print(AudioPhase(inRadians: 0.00000001))
    }
}
