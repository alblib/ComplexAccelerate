import XCTest
@testable import ComplexAccelerate

final class ComplexAccelerateTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        //XCTAssertEqual(ComplexAccelerate().text, "Hello, World!")
        let mat = Matrix<Double>(elements: [1,2,3,4], rowCount: 2, columnCount: 2)!
        let mat2 = Matrix<Double>(elements: [5,6,7,8], rowCount: 2, columnCount: 2)!
        //print(mat?.transpose)
        print( Matrix<Double>.multiply(mat, mat2)!)
        let a: [Double] = [1,2 ,-3]
        print(Matrix.add(mat,mat2))
        print(Vector.absolute(a))
        Vector<Double>.multiply(a, a)
        let b = Vector<Double>.geometricProgression(initialValue: 2, ratio: 2, count: 3)
        print(b)
        print(Polynomial<Float>(coefficients: [1,2,1]) * Polynomial<Float>(coefficients: [1,1]))
        print(Polynomial<Double>(coefficients: [1,2,3,8]).evaluate(variable: Complex(real: 2, imag:1)))
        print(Polynomial<Complex<Double>>(coefficients: [1,2,3,8]))
        print(Polynomial<Complex<Double>>(coefficients: [1,2,3,8]).evaluate(variable: Complex(real: 2, imag:1)))
    }
}
