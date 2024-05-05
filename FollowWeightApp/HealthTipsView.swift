//
//  HealthTipsView.swift
//  FollowWeightApp
//
//  Created by Lucas Parreira on 05/05/2024.
//

import SwiftUI

struct HealthTipsView: View {
    @State private var tips: [HealthTip] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else {
                List(tips, id: \.id) { tip in
                    VStack(alignment: .leading) {
                        Text(tip.title)
                            .font(.headline)
                        Text(tip.description)
                            .font(.body)
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            fetchHealthTips()
        }
    }

    func fetchHealthTips() {
        isLoading = true
        let apiUrl = URL(string: "https://api.healthtips.com/tips")!
        URLSession.shared.dataTask(with: apiUrl) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                if let error = error {
                    errorMessage = "Error: \(error.localizedDescription)"
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    errorMessage = "Error: Invalid response"
                    return
                }
                guard let data = data else {
                    errorMessage = "Error: No data received"
                    return
                }
                do {
                    tips = try JSONDecoder().decode([HealthTip].self, from: data)
                } catch {
                    errorMessage = "Error: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}

struct HealthTip: Decodable {
    let id: Int
    let title: String
    let description: String
}

struct HealthTipsView_Previews: PreviewProvider {
    static var previews: some View {
        HealthTipsView()
    }
}

