//
//  AudioPhasePlot.swift
//  
//
//  Created by Albertus Liberius on 2023-01-22.
//

import SwiftUI
import Accelerate

public struct AudioPhasePlot: View {
    public let transferFunction: TransferFunction
    public let plotColor: Color
    private let data: [AudioPhase]
    private let phaseAxis: AudioPhaseAxis
    private let horizontalAxis = AudioHorizontalAxis()
    public init(transferFunction: TransferFunction, color: Color = .red) {
        self.transferFunction = transferFunction
        data = transferFunction.continuousPhaseFrequencyResponse(in: 20...20000, count: 256)
        let degrees = Vector.degrees(data)
        let maxDegrees = vDSP.maximum(degrees)
        let minDegrees = vDSP.minimum(degrees)
        let maxPlotDeg = ceil(maxDegrees / 90) * 90
        let minPlotDeg = floor(minDegrees / 90) * 90
        
        self.phaseAxis = .init(minimum: AudioPhase(inDegrees: minPlotDeg), maximum: .init(inDegrees: maxPlotDeg))
        
        self.plotColor = color
    }
    
    public var body: some View {
        GeometryReader { geometry in
            PlotLerpView(points: zip(Vector<Double>.arithmeticProgression(initialValue: 0, to: 1, count: data.count), Vector.radians(data)).map{.init(x: $0.0, y: $0.1)}, xRange: 0...1, yRange: phaseAxis.minimum.inRadians...phaseAxis.maximum.inRadians, fillStyle: .noFill, strokeStyle: .init(lineWidth: 2), fillColor: .clear, strokeColor: .red)
                .frame(width: geometry.size.width - 95.0 / 2 - 11, height: geometry.size.height - 40 / 2)
                .position(x: geometry.size.width / 2 + 95.0 / 4 - 11.0 / 2, y: geometry.size.height / 2 - 40 / 4)
            phaseAxis.frame(width: 95, height: geometry.size.height - 40 / 2)
                .position(x: 95 / 2, y: geometry.size.height / 2 - 40 / 4)
            horizontalAxis
                .frame(width: geometry.size.width - 95.0 / 2 - 11, height: 40)
                .position(x: geometry.size.width / 2 + 95.0 / 4 - 11.0 / 2, y: geometry.size.height - 40 / 2)
        }
    }
}

struct AudioPhasePlot_Previews: PreviewProvider {
    static var previews: some View {
        AudioPhasePlot(transferFunction: AnalogTransferFunction.secondOrderBandPassFilter(centerFrequency: 1000, qualityFactor: 2))
            .frame(height: 200)
            .padding()
    }
}
