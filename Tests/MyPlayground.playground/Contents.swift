import ComplexAccelerate
import Accelerate


let sA: [Complex<Float>] = .init(repeating: .I, count: 100)
let sB: [Complex<Float>] = .init(repeating: .one, count: 100)


let vA: [Float] = .init(repeating: 1, count: 100)
let vB: [Float] = .init(repeating: 5, count: 100)
let afd: [Float] = []

let start = DispatchTime.now() // <<<<<<<<<< Start time

let aaa: [Int32] = [1,2,4]

print(Vector<Complex<Float>>.multiply(vA,sB))
//print(vDSP.add(vA,vB))
print(Vector<Int32>.add(2, aaa))

print(vDSP.negative(afd))

let end = DispatchTime.now()   // <<<<<<<<<<   end time
let nanoTime: UInt64 = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
let timeInterval = Double(Int64(nanoTime)) / 1e9 // Technically could overflow for long running tests
print("Time to evaluate problem: \(timeInterval) seconds")

print(Complex(real: 0, imag: 1))


