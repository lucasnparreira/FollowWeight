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
                    Label("Add Weight", systemImage: "plus.circle")
                }

            WeightHistoryView()
                .tabItem {
                    Label("History", systemImage: "chart.bar.xaxis")
                }
             HealthTipsView()
                .tabItem {
                    Label("Tips", systemImage: "chart.bar.xaxis")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
