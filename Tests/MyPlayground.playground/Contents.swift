import ComplexAccelerate
import Accelerate
/*
var greeting = "Hello, playground"
ComplexAccelerate.conjugate([.init(real: 1, imag: 2),.init(real: 6, imag: 7)])

let start = DispatchTime.now() // <<<<<<<<<< Start time
vDSPDoubleComplexVector.add([.init(real: 1, imag: 2)], [.init(real: 6, imag: 7)])

let end = DispatchTime.now()   // <<<<<<<<<<   end time
let nanoTime: UInt64 = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
let timeInterval = Double(Int64(nanoTime)) / 1e9 // Technically could overflow for long running tests
print("Time to evaluate problem: \(timeInterval) seconds")
*/

print(vDSPDoubleComplexVector.multiply([.init(real: 1, imag: 2),.init(real: 3, imag: 4)],.init(real: 5, imag: 6)))
