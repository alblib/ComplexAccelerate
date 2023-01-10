import ComplexAccelerate
import Accelerate


let sA: [Complex<Float>] = .init(repeating: .I, count: 100)
let sB: [Complex<Float>] = .init(repeating: .init(real: 2, imag: 3), count: 100)

let sss: [Complex<Float>] = [.init(real: 2, imag: 3), .init(real: 4, imag: 5), .init(real: 6, imag: 7)]
let sss2: [Complex<Float>] = [.init(real: 1, imag: 3), .init(real:3, imag: 5), .init(real: 4, imag: 7)]

let vA: [Float] = .init(repeating: 1, count: 100)
let vB: [Float] = .init(repeating: 5, count: 100)
let afd: [Float] = []

let start = DispatchTime.now() // <<<<<<<<<< Start time
let aaaa: [Double] = []
let aaa: [Int32] = [1,2,4]

print(Vector<Complex<Float>>.multiply(sss,.init(real: 2, imag:2)))

let end = DispatchTime.now()   // <<<<<<<<<<   end time
let nanoTime: UInt64 = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
let timeInterval = Double(Int64(nanoTime)) / 1e9 // Technically could overflow for long running tests
print("Time to evaluate problem: \(timeInterval) seconds")



