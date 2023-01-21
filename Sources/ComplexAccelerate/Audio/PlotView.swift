//
//  PlotView.swift
//  
//
//  Created by Albertus Liberius on 2023-01-21.
//

import SwiftUI
import Accelerate

struct RelativePlotShape: Shape{
    
    // everything must have same size, at least one element
    let relativePlotX: [Double]
    let relativePlotY: [Double]
    let relativePlotDyOverDx: [Double]
    
    @frozen enum FillStyle{
        case bottomFill
        case ceilingFill
    }
    let style: FillStyle
    let padding: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let outsideY = style == .bottomFill ? rect.maxY + padding : rect.minY - padding
        var path = Path()
        path.move(to: .init(x: rect.maxX + padding, y: outsideY))
        path.addLine(to: .init(x: rect.minX - padding, y: outsideY))
        
        let coordX = vDSP.add(rect.minX, vDSP.multiply(rect.maxX - rect.minX, relativePlotX))
        let coordY = vDSP.add(rect.maxY, vDSP.multiply(rect.minY - rect.maxY, relativePlotY))
        let coordDyDx = vDSP.multiply((rect.minY - rect.maxY) / (rect.maxX - rect.minX), relativePlotDyOverDx)
        
        path.addLine(to: .init(x: rect.minX - padding, y: coordY.first! - coordDyDx.first! * (coordX.first! - (rect.minX - padding))))
        path.addLine(to: .init(x: coordX.first!, y: coordY.first!))
        for i in 1..<relativePlotX.count{
            path.addCurve(to: .init(x: coordX[i], y: coordY[i]), control1: .init(x: 2.0 / 3 * coordX[i-1] + 1.0 / 3 * coordX[i], y: coordY[i-1] + coordDyDx[i-1] / 3 * (coordX[i] - coordX[i-1])), control2: .init(x: 1.0 / 3 * coordX[i-1] + 2.0 / 3 * coordX[i], y: coordY[i] - coordDyDx[i] / 3 * (coordX[i] - coordX[i-1])))
        }
        path.addLine(to: .init(x: rect.maxX + padding, y: coordY.last! + coordDyDx.last! * ((rect.maxX + padding) - coordX.last!)))
        path.closeSubpath()
        return path
    }
}

struct TestShape: Shape{
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: .init(x: -100, y: 0))
        path.addLine(to: .init(x: 1.1 * rect.maxX, y: 0.5 *  rect.maxY))
        path.addLine(to: .init(x: 0.5 * rect.maxX, y: 1.1 * rect.maxY))
        //path.closeSubpath()
        return path
    }
}

struct SwiftUIView: View {
    var body: some View {
        RelativePlotShape(relativePlotX: [0,1], relativePlotY: [0,1], relativePlotDyOverDx: [-1,1], style: .bottomFill, padding: 2)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
