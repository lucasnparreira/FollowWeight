//
//  LineChartView.swift
//  FollowWeightApp
//
//  Created by Lucas Parreira on 05/05/2024.
//

import SwiftUI

struct HistogramBar: View {
    let value: Float
    let color: Color

    var body: some View {
        VStack {
            Spacer(minLength: 0)
            Rectangle()
                .fill(color)
                .frame(height: barHeight(value: value))
            Text(String(format: "%.1f", value))
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, 2)
        }
    }

    private func barHeight(value: Float) -> CGFloat {
        return CGFloat(value)
    }
}

struct HistogramChartView: View {
    let data: [Float]
    let colors: [Color]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(data.indices, id: \.self) { index in
                HistogramBar(value: data[index], color: colors[index])
            }
        }
    }
}

struct LineChartView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \WeightEntry.date, ascending: true)],
        animation: .default)
    private var entries: FetchedResults<WeightEntry>

    var body: some View {
        GeometryReader { geometry in
            VStack {
                // Linhas verticais (Y) com os valores de peso
//                ForEach(getYLabels(), id: \.self) { label in
//                    Text(label)
//                        .font(.caption)
//                        .foregroundColor(.secondary)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .padding(.leading)
//                }

                // Gráfico de histograma para o peso inicial, final e diferença
                HistogramChartView(data: histogramData(), colors: [.blue, .green, .red])

                // Linha horizontal (X) com datas
                HStack {
                    Text("Peso Inicial")
                        .font(.caption)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .foregroundColor(.blue)
                    Text("Ultimo Peso")
                        .font(.caption)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .foregroundColor(.green)
                    Text("Diferença")
                        .font(.caption)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .foregroundColor(.red)
                }
                .padding(.top)
                .padding(.horizontal)
            }
            .frame(height: geometry.size.height)
            .padding(.horizontal) // Espaço horizontal para alinhar com o eixo vertical
        }
    }

    private func getYLabels() -> [String] {
        guard let firstWeight = entries.first?.weight, let lastWeight = entries.last?.weight else {
            return []
        }

        let maxWeight = max(firstWeight, lastWeight)
        let minWeight = min(firstWeight, lastWeight)
        let step = (maxWeight - minWeight) / 5
        var labels: [String] = []

        for i in 0...5 {
            let weight = minWeight + (step * Float(i))
            labels.append(String(format: "%.1f", weight))
        }

        return labels.reversed()
    }

    private func histogramData() -> [Float] {
        guard let firstWeight = entries.first?.weight, let lastWeight = entries.last?.weight else {
            return []
        }
        
        let difference = lastWeight - firstWeight
        return [firstWeight, lastWeight, difference]
    }
}




extension WeightEntry {
    static var preview: [WeightEntry] {
        let context = PersistenceController.preview.container.viewContext

        let weights: [Float] = [70.5, 71.2, 69.8, 72.1, 70.9] // Dados de exemplo
        var entries: [WeightEntry] = []

        for weight in weights {
            let entry = WeightEntry(context: context)
            entry.date = Date()
            entry.weight = weight
            entries.append(entry)
        }

        return entries
    }
}

struct LineChartView_Previews: PreviewProvider {
    static var previews: some View {
        LineChartView()
    }
}


