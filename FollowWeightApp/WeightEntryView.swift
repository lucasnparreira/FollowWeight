//
//  WeightEntryView.swift
//  FollowWeightApp
//
//  Created by Lucas Parreira on 05/05/2024.
//

import SwiftUI

struct WeightEntryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var weight: String = ""

    var body: some View {
        VStack {
            TextField("Enter weight", text: $weight)
                .padding()

            Button("Save") {
                saveWeight()
            }
            .padding()
        }
        .navigationTitle("Add Weight")
    }

    private func saveWeight() {
        let newEntry = WeightEntry(context: viewContext)
        newEntry.date = Date()
        newEntry.weight = (weight as NSString).floatValue

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }

        weight = "" // Limpa o campo de texto após salvar
    }
}

struct WeightEntryView_Previews: PreviewProvider {
    static var previews: some View {
        WeightEntryView()
    }
}

