//
//  AudioHorizontalAxis.swift
//  
//
//  Created by Albertus Liberius on 2023-01-25.
//

import Foundation
import SwiftUI
/*
extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}
*/

/*
// GitHub: zalogatomek
// https://zalogatomek.medium.com/swiftui-missing-intrinsic-content-size-how-to-get-it-6eca8178a71f
struct IntrinsicContentSizePreferenceKey: PreferenceKey {
    static let defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

extension View {
    func readIntrinsicContentSize(to size: Binding<CGSize>) -> some View {
        background(GeometryReader { proxy in
            Color.clear.preference(
                key: IntrinsicContentSizePreferenceKey.self,
                value: proxy.size
            )
        })
        .onPreferenceChange(IntrinsicContentSizePreferenceKey.self) {
            size.wrappedValue = $0
        }
    }
}
 
 */

/// Auto-scaled 20-20kHz axis.
struct AudioHorizontalAxis: View {
    //@State var axisLabels: [AudioFrequency] = [20,20000]
    private let lineWidth: CGFloat = 1
    private let color: Color = .gray
    private static let numberFormatter = {
        var formatter = NumberFormatter()
        //formatter.minimumFractionDigits = 0
        //formatter.maximumFractionDigits = 2
        formatter.usesSignificantDigits = true
        formatter.maximumSignificantDigits = 3
        formatter.minimumSignificantDigits = 0
        return formatter
    }()
    private func axisLabelsBy(width: CGFloat) -> [AudioFrequency]{
        if width < 55{
            return [20, 20000]
        }else if width < 80{
            return [20, 600, 20000]
        }else if width < 110	{
            return [20, 200, 2000, 20000]
        }else if width < 140	{
            return [20, 100, 600, 3000, 20000]
        }else if width < 180{
            return [20, 80, 300, 1000, 5000, 20000]
        }else if width < 200{
            return [20, 60, 200, 600, 2000, 6000, 20000]
        }else if width < 230{
            return [20, 50, 150, 400, 1000, 3000, 7000, 20000]
        }else if width < 240{
            return [20, 50, 100, 250, 600, 1500, 3500, 8000, 20000]
        }else if width < 360{
            return [20, 40, 80, 200, 500, 1000, 2000, 4000, 8000, 20000]
        }else{
            return [20, 35, 60, 100, 200, 350, 630, 1200, 2000, 3500, 6300, 12000, 20000]
        }
    }
    
    //@Environment(\.dynamicTypeSize) var dynamicTypeSize: DynamicTypeSize
    //@State var lastLabelSize: CGSize = .zero
    
    var body: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: lineWidth / 2)
                .frame(width: geometry.size.width + lineWidth, height: lineWidth)
                .foregroundColor(.gray)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            ForEach(axisLabelsBy(width: geometry.size.width), id: \.self) { label in
                RoundedRectangle(cornerRadius: lineWidth / 2)
                    .frame(width: lineWidth, height: lineWidth * 3 + 2)
                    .foregroundColor(.gray)
                    .position(x: label.inAudibleRangeLogScale * geometry.size.width, y: geometry.size.height / 2 + lineWidth + 1)
                Text(label.inHertz < 999.5 ? Self.numberFormatter.string(from: NSNumber(value: label.inHertz))! : Self.numberFormatter.string(from: NSNumber(value: label.inHertz / 1000))! + "k")
                    .font(.footnote)
                    .position(x: label.inAudibleRangeLogScale * geometry.size.width, y: geometry.size.height / 2 + lineWidth * 1.5 + 10)
                    .foregroundColor(color)
            }
            //Text("20k").font(.footnote).foregroundColor(.clear).readIntrinsicContentSize(to: $lastLabelSize)
            //Text(rightNegativeMargin.description)
            //Text(UIFont.preferredFont(forTextStyle: .footnote, compatibleWith: .current).pointSize.description)
            //Text(UIFontMetrics.default.scaledValue(for: 10).description)
            //DynamicTypeSize
        }
    }
}

struct AudioHorizontalAxis_Previews: PreviewProvider {
    static var previews: some View{
        ZStack{
            Color.red.frame(width: 382, height: 40)
            AudioHorizontalAxis()
                .frame(width:360)
        }
            .padding()
    }
}
