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
            HStack {
                Spacer()
                Button(action: {
                    showingAddWeightView.toggle()
                }) {
                    HStack {
//                        Text("Adicionar Peso")
                        Image(systemName: "plus")
                            .font(.headline)
                            .fontWeight(.bold)
                            
                    }
                    .padding(.horizontal)
                    .frame(height: 40)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .opacity(0.7)
                    .cornerRadius(20)
                }
                .padding()
                .padding(.bottom,50)
                
            }
            Spacer()
            
            Text("Acompanhamento de Peso")
                .font(.headline)
                .padding(.top, 10)
                .padding(.bottom,10)
            
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
            
            Spacer()
            
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
        .padding(.horizontal)
        .padding(.vertical)
        .navigationBarTitleDisplayMode(.inline)
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
        NavigationView {
            VStack {
                Text("Resumo")
                    .font(.headline)
                Text("Peso inicial: \(String(format: "%.2f", initialWeight)) kg")
                Text("Último peso: \(String(format: "%.2f", lastWeight)) kg")
                if (lastWeight > initialWeight){
                    Text("Diferença: + \(String(format: "%.2f", difference)) kg")
                } else if (lastWeight == initialWeight) {
                    Text("Diferença: \(String(format: "%.2f", difference)) kg")
                } else {
                    Text("Diferença: - \(String(format: "%.2f", difference)) kg")
                }
                
            }
            
        }
    }
}

