import ComplexAccelerate
import Accelerate


let vA: [Complex<Double>] = [.init(real: 2, imag: 3), .init(real: 4, imag: 5), .init(real: 6, imag: 7)]
let vB: [Complex<Double>] = [.init(real: 1, imag: 3), .init(real:3, imag: 5), .init(real: 4, imag: 7)]
let rv: [Double] = [6,2,7]

let s: Complex<Double> = .init(real: 7, imag: 3)

let start = DispatchTime.now() // <<<<<<<<<< Start time


print(Vector<Complex<Double>>.asin(vA))

let end = DispatchTime.now()   // <<<<<<<<<<   end time
let nanoTime: UInt64 = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
let timeInterval = Double(Int64(nanoTime)) / 1e9 // Technically could overflow for long running tests
print("Time to evaluate problem: \(timeInterval) seconds")



