//
//  MainView.swift
//  FollowWeightApp
//
//  Created by Lucas Parreira on 05/05/2024.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Add Peso", systemImage: "plus.circle")
                }

            WeightHistoryView()
                .tabItem {
                    Label("Historico", systemImage: "chart.bar.xaxis")
                }
             HealthTipsView()
                .tabItem {
                    Label("Motivacional", systemImage: "figure.cooldown")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
