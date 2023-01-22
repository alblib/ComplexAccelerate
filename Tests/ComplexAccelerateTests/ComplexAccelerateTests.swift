import XCTest
@testable import ComplexAccelerate
import Accelerate

func test() -> AnalogTransferFunction{
    AnalogTransferFunction(sExpression: [1.125945072697908e8, 18886.914378028894, 1.5848647011308556] / [1.125945072697908e8, 15004.846526655718, 1])
}

final class ComplexAccelerateTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        //XCTAssertEqual(ComplexAccelerate().text, "Hello, World!")
        let start = DispatchTime.now() // <<<<<<<<<< Start time
        print(AnalogTransferFunction.firstOrderLowPassFilter(cutoffFrequency: 1000).bilinearTransformToDigital(sampleRate: .sample_48kHz).gainFrequencyResponse())
        print(AnalogTransferFunction.firstOrderLowPassFilter(cutoffFrequency: 1000).gainFrequencyResponse())
         let end = DispatchTime.now()   // <<<<<<<<<<   end time

         let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
         let timeInterval = Double(nanoTime) / 1_000_000_000 // Technically could overflow for long running tests

         print("Time to evaluate problem : \(timeInterval) seconds")
        print(DigitalTransferFunction.LinearPhaseFIRFilter(frequencyResponse: {_ in AudioGain(byAmplitude: 1)}, sampleRate: 48000, sampleSize: 16)?.zInverseExpression.numerator.coefficients)
        
       print("gains ", DigitalTransferFunction.LinearPhaseFIRFilter(frequencyResponse: {_ in AudioGain(byAmplitude: 1)}, sampleRate: 48000, sampleSize: 16)?.gainFrequencyResponse())
        print("filter ", DigitalTransferFunction.LinearPhaseFIRFilter(frequencyResponse: {_ in AudioGain(byAmplitude: 1)}, sampleRate: 48000, sampleSize: 16))
        print(DigitalTransferFunction.LinearPhaseFIRFilter(frequencyResponse: {_ in AudioGain(byAmplitude: 1)}, sampleRate: 48000, sampleSize: 16)?.phaseFrequencyResponse([0.1,0.2,0.3]))
        print(test())
    }
}
