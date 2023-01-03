import XCTest
@testable import ComplexAccelerate

final class ComplexAccelerateTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        //XCTAssertEqual(ComplexAccelerate().text, "Hello, World!")
        
        var z = Complex<Float>(real: 0, imag: 2)

        var fdsfassdf: Float = abs(z)
        var dfdsafds: Float = log(abs(z))
        var fdsafag: Float = arg(z)
        var sglkwkje: Complex<Float> = Complex<Float>(real: Float(2), imag: Float(3))
        var fdsfasdf: Complex<Float> = log(z)
        print(fdsfasdf)
        
        var result = -Complex<Float>(floatLiteral: Float.eulerGamma) * z - log(z)
        print("result = \(result)")
        for i in 1...10{
            let zk = z / Complex<Float>(integerLiteral: Int64(i))
            let iter = zk - log(1+zk)
            print("iter = \(iter)")
            result += iter
        }
    }
}
