//
//  HealthTipsView.swift
//  FollowWeightApp
//
//  Created by Lucas Parreira on 05/05/2024.
//

import SwiftUI
import Foundation

struct HealthTipsView: View {
    @State private var randomTip: String = ""
    
    var body: some View {
        VStack {
            Text(randomTip)
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
                .onAppear {
                    loadRandomTip()
                }
            
            Button("Nova Dica") {
                loadRandomTip()
            }
            .padding()
        }
    }
    
    func loadRandomTip() {
        guard let url = Bundle.main.url(forResource: "data", withExtension: "json") else {
            fatalError("Arquivo JSON não encontrado")
        }
        
        do {
            let data = try Data(contentsOf: url)
            let tips = try JSONDecoder().decode([String].self, from: data)
            randomTip = tips.randomElement() ?? "Nenhuma dica encontrada"
        } catch {
            print("Erro ao carregar dicas motivacionais: \(error)")
            randomTip = "Erro ao carregar dicas motivacionais"
        }
    }
}

struct HealthTipsView_Previews: PreviewProvider {
    static var previews: some View {
        HealthTipsView()
    }
}

