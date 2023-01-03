import ComplexAccelerate
import Accelerate

let start = DispatchTime.now() // <<<<<<<<<< Start time

var z = Complex<Float>(real: 0, imag: 2)
var fdsfassdf: Float = abs(z)
var dfdsafds: Float = log(abs(z))
var fdsafag: Float = arg(z)
var sglkwkje: Complex<Float> = Complex<Float>(real: Float(2), imag: Float(3))
var fdsfasdf: Complex<Float> = log(z)

let end = DispatchTime.now()   // <<<<<<<<<<   end time
let nanoTime: UInt64 = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
let timeInterval = Double(Int64(nanoTime)) / 1e9 // Technically could overflow for long running tests
print("Time to evaluate problem: \(timeInterval) seconds")



