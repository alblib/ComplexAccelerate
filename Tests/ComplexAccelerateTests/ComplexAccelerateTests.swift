import XCTest
@testable import ComplexAccelerate

final class ComplexAccelerateTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        //XCTAssertEqual(ComplexAccelerate().text, "Hello, World!")
        print("hello")
        let a: [Complex<Float>] = [1,0,3]
        let b: [Complex<Float>] = Vector.multiply([1,1,4], .I)
        print(a)
        print(b)
        print(Vector.add(a,b))
        var str = "aaa"
        str = String(str.dropLast(2))
        print(str)
    }
}
