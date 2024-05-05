//
//  ContentView.swift
//  FollowWeightApp
//
//  Created by Lucas Parreira on 05/05/2024.
//
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \WeightEntry.date, ascending: true)],
        animation: .default)
    private var entries: FetchedResults<WeightEntry>

    @State private var showingAddWeightView = false

    var body: some View {
        VStack {
            Text("Acompanhamento de Peso")
                        .font(.headline)
                        .navigationBarTitleDisplayMode(.inline)
                        .padding(.top, 20)
            // Botão para cadastrar peso
            Button(action: {
                showingAddWeightView.toggle()
            }) {
                Text("Adicionar Peso")
            }
            .padding()
            .foregroundColor(.green)
            
            if !entries.isEmpty {
                let initialWeight = String(format: "%.2f", entries.first?.weight ?? 0) // Peso inicial
                let lastWeight = String(format: "%.2f", entries.last?.weight ?? 0) // Último peso
                let difference = String(format: "%.2f", (entries.last?.weight ?? 0) - (entries.first?.weight ?? 0)) // Diferença entre os pesos
                
                // Gráfico com histórico de pesos
                LineChartView()
                    .frame(height: 200)
            } else {
                Text("Sem dados cadastrados")
            }
            
            // Resumo com peso inicial, último peso e diferença
            if let firstWeightString = entries.first?.weight,
               let lastWeightString = entries.last?.weight {
                if let firstWeight = Float(firstWeightString),
                   let lastWeight = Float(lastWeightString) {
                    let formattedFirstWeight = String(format: "%.2f", firstWeight)
                    let formattedLastWeight = String(format: "%.2f", lastWeight)
                    let difference = lastWeight - firstWeight
                    SummaryView(initialWeight: Float(formattedFirstWeight) ?? 0, lastWeight: Float(formattedLastWeight) ?? 0, difference: difference)
                        .padding()
                }
            }
                

        }
        .sheet(isPresented: $showingAddWeightView) {
            WeightEntryView().environment(\.managedObjectContext, viewContext)
        }
        
    }
        
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct SummaryView: View {
    let initialWeight: Float
    let lastWeight: Float
    let difference: Float

    var body: some View {
        VStack {
            Text("Resumo")
                .font(.headline)
            Text("Peso inicial: \(String(format: "%.2f", initialWeight)) kg")
            Text("Último peso: \(String(format: "%.2f", lastWeight)) kg")
            Text("Diferença: \(String(format: "%.2f", difference)) kg")
        }

    }
}
