//
//  PlotView.swift
//  
//
//  Created by Albertus Liberius on 2023-01-21.
//

import SwiftUI
import Accelerate

struct RelativePlotShape: Shape{
    
    struct RelativePlotPoint{
        let x: Double
        let y: Double
        let dyOverDx: Double
        init(x: Double, y: Double){
            self.x = x
            self.y = y
            self.dyOverDx = .nan
        }
        init(x: Double, y: Double, dyOverDx: Double){
            self.x = x
            self.y = y
            self.dyOverDx = dyOverDx
        }
        func point(in rect: CGRect) -> CGPoint{
            let coordX = rect.minX + (rect.maxX - rect.minX) * x
            let coordY = rect.maxY - (rect.maxY - rect.minY) * y
            return .init(x: coordX, y: coordY)
        }
        func controlPoint(toward nextPoint: Self, in rect: CGRect) -> CGPoint{
            let relativeDx = nextPoint.x - self.x
            let relativeDy = nextPoint.y - self.y
            let relativeDyOverDx: Double
            if self.dyOverDx.isNaN == false{
                relativeDyOverDx = self.dyOverDx
            }else{
                if nextPoint.dyOverDx.isNaN{
                    relativeDyOverDx = relativeDy / relativeDx
                }else{
                    relativeDyOverDx = (relativeDy - nextPoint.dyOverDx * relativeDx / 3) / (relativeDx * 2 / 3)
                }
            }
            let relativeControlPointX = self.x + relativeDx / 3
            let relativeControlPointY = self.y + relativeDyOverDx * relativeDx / 3
            let relativeControlPoint = Self(x: relativeControlPointX, y: relativeControlPointY)
            return relativeControlPoint.point(in: rect)
        }
    }
    let relativePlotPoints: [RelativePlotPoint]
    
    @frozen enum FillStyle{
        case bottomFill
        case ceilingFill
    }
    let style: FillStyle
    let padding: CGFloat
    
    private func leftPaddingPoint(in rect: CGRect) -> CGPoint{ // not safe if relativePlotPoints is empty
        let relativeLeftBorderX = -padding / (rect.maxX - rect.minX)
        let relativeDx = relativePlotPoints.first!.x - relativeLeftBorderX
        let relativeDyOverDx = relativePlotPoints.first?.dyOverDx.isNaN == false ? relativePlotPoints.first!.dyOverDx: 0
        let relativeDy = relativeDyOverDx * relativeDx
        let relativeLeftBorderY = relativePlotPoints.first!.y - relativeDy
        return RelativePlotPoint(x: relativeLeftBorderX, y: relativeLeftBorderY).point(in: rect)
    }
    
    private func rightPaddingPoint(in rect: CGRect) -> CGPoint{ // not safe if relativePlotPoints is empty
        let relativeRightBorderX = 1 + padding / (rect.maxX - rect.minX)
        let relativeDx = relativeRightBorderX - relativePlotPoints.last!.x
        let relativeDyOverDx = relativePlotPoints.last?.dyOverDx.isNaN == false ? relativePlotPoints.first!.dyOverDx: 0
        let relativeDy = relativeDyOverDx * relativeDx
        let relativeRightBorderY = relativePlotPoints.last!.y + relativeDy
        return RelativePlotPoint(x: relativeRightBorderX, y: relativeRightBorderY).point(in: rect)
    }
    
    
    func path(in rect: CGRect) -> Path {
        let outsideY = style == .bottomFill ? rect.maxY + padding : rect.minY - padding
        var path = Path()
        path.move(to: .init(x: rect.maxX + padding, y: outsideY))
        path.addLine(to: .init(x: rect.minX - padding, y: outsideY))
        
        path.addLine(to: leftPaddingPoint(in: rect))
        
        if relativePlotPoints.isEmpty == false{
            path.addLine(to: relativePlotPoints.first!.point(in: rect))
            for i in 1..<relativePlotPoints.count{
                path.addCurve(to: relativePlotPoints[i].point(in: rect), control1: relativePlotPoints[i-1].controlPoint(toward: relativePlotPoints[i], in: rect), control2: relativePlotPoints[i].controlPoint(toward: relativePlotPoints[i-1], in: rect))
            }
        }
        
        path.addLine(to: rightPaddingPoint(in: rect))
        path.closeSubpath()
        return path
    }
}

public struct PlotView: View{
    public struct PlotPoint{
        public let x: Double
        public let y: Double
        public let dyOverDx: Double
        
        public init(x: Double, y: Double){
            self.x = x
            self.y = y
            self.dyOverDx = .nan
        }
        public init(x: Double, y: Double, dyOverDx: Double){
            self.x = x
            self.y = y
            self.dyOverDx = dyOverDx
        }
        func convertToRelativePoint(xRange: ClosedRange<Double>, yRange: ClosedRange<Double>) -> RelativePlotShape.RelativePlotPoint{
            let xSize = xRange.upperBound - xRange.lowerBound
            let ySize = yRange.upperBound - yRange.lowerBound
            let relX = (x - xRange.lowerBound) / xSize
            let relY = (y - yRange.lowerBound) / ySize
            let relDeriv = dyOverDx / ySize * xSize
            return RelativePlotShape.RelativePlotPoint(x: relX, y: relY, dyOverDx: relDeriv)
        }
        static func convertToRelativePoints<PlotPointArray>(absolutePoints: PlotPointArray, xRange: ClosedRange<Double>, yRange: ClosedRange<Double>) -> [RelativePlotShape.RelativePlotPoint]
        where PlotPointArray: AccelerateBuffer, PlotPointArray.Element == PlotPoint
        {
            guard absolutePoints.count > 0 else{
                return []
            }
            let count = absolutePoints.count
            let xSize = xRange.upperBound - xRange.lowerBound
            let ySize = yRange.upperBound - yRange.lowerBound
            return absolutePoints.withUnsafeBufferPointer { absPointsBuffer in
                absPointsBuffer.baseAddress!.withMemoryRebound(to: Double.self, capacity: count * 3) { absPointsPointer in
                    let xFromLowerBound = [Double](unsafeUninitializedCapacity: count) { buffer, initializedCount in
                        let anchoringBound = -xRange.lowerBound
                        withUnsafePointer(to: anchoringBound) { anchorPtr in
                            vDSP_vsaddD(absPointsPointer, 3, anchorPtr, buffer.baseAddress!, 1, vDSP_Length(count))
                        }
                        initializedCount = count
                    }
                    let yFromLowerBound = [Double](unsafeUninitializedCapacity: count) { buffer, initializedCount in
                        let anchoringBound = -yRange.lowerBound
                        withUnsafePointer(to: anchoringBound) { anchorPtr in
                            vDSP_vsaddD(absPointsPointer + 1, 3, anchorPtr, buffer.baseAddress!, 1, vDSP_Length(count))
                        }
                        initializedCount = count
                    }
                    return [RelativePlotShape.RelativePlotPoint](unsafeUninitializedCapacity: count) { buffer, initializedCount in
                        buffer.baseAddress!.withMemoryRebound(to: Double.self, capacity: 3 * count) { resultPointer in
                            withUnsafePointer(to: xSize) { xSizePtr in
                                vDSP_vsdivD(xFromLowerBound, 1, xSizePtr, resultPointer, 3, vDSP_Length(count))
                            }
                            withUnsafePointer(to: ySize) { ySizePtr in
                                vDSP_vsdivD(yFromLowerBound, 1, ySizePtr, resultPointer + 1, 3, vDSP_Length(count))
                            }
                            let dydxSize = xSize / ySize
                            withUnsafePointer(to: dydxSize) { derivSizePtr in
                                vDSP_vsmulD(absPointsPointer + 2, 3, derivSizePtr, resultPointer + 2, 3, vDSP_Length(count))
                            }
                        }
                        initializedCount = count
                    }
                }
            }
        }
    }
    
    @frozen public enum FillStyle{
        case bottomFill
        case topFill
        case noFill
    }
    
    public let xRange: ClosedRange<Double>
    public let yRange: ClosedRange<Double>
    
    public let points: [PlotPoint]
    
    let fillStyle: FillStyle
    let strokeStyle: StrokeStyle
    let fillColor: Color
    let strokeColor: Color
    
    public init(points: [PlotPoint], xRange: ClosedRange<Double>, yRange: ClosedRange<Double>, fillStyle: FillStyle = .noFill){
        self.xRange = xRange
        self.yRange = yRange
        self.points = points
        self.fillStyle = fillStyle
        self.strokeStyle = fillStyle == .noFill ? .init() : .init(lineWidth: 0)
        self.fillColor = .primary
        self.strokeColor = .primary
    }
    
    init(points: [PlotPoint], xRange: ClosedRange<Double>, yRange: ClosedRange<Double>, fillStyle: FillStyle, strokeStyle: StrokeStyle, fillColor: Color, strokeColor: Color){
        self.xRange = xRange
        self.yRange = yRange
        self.points = points
        self.fillStyle = fillStyle
        self.strokeStyle = strokeStyle
        self.fillColor = fillColor
        self.strokeColor = strokeColor
    }
    

    public func stroke(style: StrokeStyle) -> Self{
        Self(points: points, xRange: xRange, yRange: yRange, fillStyle: fillStyle, strokeStyle: style, fillColor: fillColor, strokeColor: strokeColor)
    }
    public func stroke(lineWidth: CGFloat = 1) -> Self{
        Self(points: points, xRange: xRange, yRange: yRange, fillStyle: fillStyle, strokeStyle: .init(lineWidth: lineWidth), fillColor: fillColor, strokeColor: strokeColor)
    }
    
    public func fillColor(_ color: Color) -> Self{
        Self(points: points, xRange: xRange, yRange: yRange, fillStyle: fillStyle, strokeStyle: strokeStyle, fillColor: color, strokeColor: strokeColor)
    }
    public func strokeColor(_ color: Color) -> Self{
        Self(points: points, xRange: xRange, yRange: yRange, fillStyle: fillStyle, strokeStyle: strokeStyle, fillColor: fillColor, strokeColor: color)
    }
    public func fillBelow() -> Self{
        Self(points: points, xRange: xRange, yRange: yRange, fillStyle: .bottomFill, strokeStyle: strokeStyle, fillColor: fillColor, strokeColor: strokeColor)
    }
    public func fillUpper() -> Self{
        Self(points: points, xRange: xRange, yRange: yRange, fillStyle: .topFill, strokeStyle: strokeStyle, fillColor: fillColor, strokeColor: strokeColor)
    }
    
    var actualFillColor: Color{
        if fillStyle == .noFill{
            return .clear
        }else{
            return fillColor
        }
    }
    
    public var body: some View{
        let shape = RelativePlotShape(relativePlotPoints: PlotPoint.convertToRelativePoints(absolutePoints: points, xRange: xRange, yRange: yRange), style: self.fillStyle == .topFill ? .ceilingFill : .bottomFill, padding: strokeStyle.lineWidth)
        return GeometryReader{geometry in
            ZStack{
                shape.foregroundColor(actualFillColor).clipped()
                shape.stroke(style: strokeStyle).foregroundColor(strokeColor).clipped()
            }
        }
    }
}

struct PlotView_Previews: PreviewProvider {
    static var previews: some View {
        PlotView(points: [.init(x: 0, y: 0), .init(x: 0.4, y: 0.4, dyOverDx: 2), .init(x: 1, y: 1)], xRange: 0...1, yRange: 0...1, fillStyle: .bottomFill).stroke(lineWidth: 100).strokeColor(.red)
    }
}
