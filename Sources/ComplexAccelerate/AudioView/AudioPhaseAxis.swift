//
//  AudioPhaseAxis.swift
//  
//
//  Created by Albertus Liberius on 2023-01-25.
//

import SwiftUI
import Accelerate

struct AudioPhaseAxis: View {
    let minimum: AudioPhase
    let maximum: AudioPhase
    var measureInDegrees: [AudioPhase]{
        let unit: Double
        if abs(minimum.inDegrees - maximum.inDegrees) > 180{
            unit = 90
        }else if abs(minimum.inDegrees - maximum.inDegrees) < 90{
            unit = 0
            return [minimum, maximum]
        }else{
            unit = 45
        }
        let firstTick: Double
        let ticks: [Double]
        if minimum.inDegrees <= maximum.inDegrees{
            firstTick = ceil(minimum.inDegrees / unit) * unit
            ticks = vDSP.ramp(withInitialValue: firstTick, increment: unit, count: Int(abs(maximum.inDegrees - firstTick) / unit) + 1)
        }else{
            firstTick = floor(minimum.inDegrees / unit) * unit
            ticks = vDSP.ramp(withInitialValue: firstTick, increment: -unit, count: Int(abs(maximum.inDegrees - firstTick) / unit) + 1)
        }
        return Vector.create(degrees: ticks)
    }
    let lineWidth: CGFloat = 1
    var body: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: lineWidth / 2)
                .frame(width: lineWidth, height: geometry.size.height + lineWidth)
                .foregroundColor(.gray)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            ForEach(measureInDegrees, id: \.inDegrees) { degree in
                RoundedRectangle(cornerRadius: lineWidth / 2)
                    .frame(width: 3 * lineWidth + 2 , height: lineWidth)
                    .foregroundColor(.gray)
                    .position(x: geometry.size.width / 2 - lineWidth - 1, y: (maximum.inDegrees - degree.inDegrees) / (maximum.inDegrees - minimum.inDegrees) * geometry.size.height)
                HStack{
                    Spacer(minLength: 0)
                    Text(degree.description).foregroundColor(.gray)
                        .font(.caption)
                }
                .frame(width: 40, height: 16)
                    .position(x: geometry.size.width / 2 - lineWidth - 1 - 25, y: (maximum.inDegrees - degree.inDegrees) / (maximum.inDegrees - minimum.inDegrees) * geometry.size.height - 1)
            }
        }
    }
}

struct AudioPhaseAxis_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color.red.frame(width: 95)
            AudioPhaseAxis(minimum: .init(inDegrees: 0), maximum: .init(inDegrees: -1080))
        }
    }
}
