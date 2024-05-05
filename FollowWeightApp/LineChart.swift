//
//  LineChart.swift
//  FollowWeightApp
//
//  Created by Lucas Parreira on 05/05/2024.
//

import SwiftUI

struct LineChart: View {
    let dataPoints: [CGPoint]
    @Binding var frame: CGRect

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Linhas verticais
                ForEach(1..<5) { index in
                    let yPosition = CGFloat(index) / 5 * frame.height
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: yPosition))
                        path.addLine(to: CGPoint(x: frame.width, y: yPosition))
                    }
                    .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round))
                }

                // Linhas horizontais
                ForEach(1..<dataPoints.count) { index in
                    if index < dataPoints.count {
                        let previousPoint = dataPoints[index - 1]
                        let currentPoint = dataPoints[index]
                        Path { path in
                            path.move(to: CGPoint(x: previousPoint.x * frame.width, y: (1 - previousPoint.y) * frame.height))
                            path.addLine(to: CGPoint(x: currentPoint.x * frame.width, y: (1 - currentPoint.y) * frame.height))
                        }
                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            .onAppear {
                frame = geometry.frame(in: .local)
            }
            .frame(maxWidth: geometry.size.width * 0.6)
        }
    }
}

struct LineChart_Previews: PreviewProvider {
    static var previews: some View {
        LineChart(dataPoints: [CGPoint(x: 0, y: 0.2), CGPoint(x: 0.25, y: 0.5), CGPoint(x: 0.5, y: 0.8), CGPoint(x: 0.75, y: 0.4), CGPoint(x: 1, y: 0.6)], frame: .constant(CGRect(x: 0, y: 0, width: 300, height: 200)))
    }
}


