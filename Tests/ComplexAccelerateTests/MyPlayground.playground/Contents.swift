import UIKit
import ComplexAccelerate
var greeting = "Hello, playground"

PlotView(points: AnalogTransferFunction.weightK.phaseFrequencyResponse().enumerated().map{.init(x: Double($0.offset), y: $0.element.inDegrees)}, xRange: 0...255, yRange: -360...0)
