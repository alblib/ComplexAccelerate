import XCTest
@testable import ComplexAccelerate
import Accelerate


final class ComplexAccelerateTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        //XCTAssertEqual(ComplexAccelerate().text, "Hello, World!")
        let start = DispatchTime.now() // <<<<<<<<<< Start time
        print(Vector.createFrequenciesLogScale(in: 20...20000, count: 10))
        print(AudioGain(byAmplitude: 0.5))
        print( AnalogTransferFunction.firstOrderLowPassFilter(cutoffFrequency: 1000).sExpression.evaluate(variable: Complex.I * 10000))
        print(Vector.angularVelocities(of: [1000]))
        print(Vector<DSPDoubleComplex>.multiply(DSPDoubleComplex(real: 0, imag: 1), Vector<DSPDoubleComplex>.castToComplexes(Vector.angularVelocities(of: [1000]))))
        print(AnalogTransferFunction.firstOrderLowPassFilter(cutoffFrequency: 1000).gainFrequencyResponse())
         let end = DispatchTime.now()   // <<<<<<<<<<   end time

         let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
         let timeInterval = Double(nanoTime) / 1_000_000_000 // Technically could overflow for long running tests

         print("Time to evaluate problem : \(timeInterval) seconds")
    }
}
