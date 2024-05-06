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
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            
            Spacer()

            TextField("Informe o peso", text: $weight)
                .padding()
                .keyboardType(.decimalPad)

            HStack {
                Button("Salvar") {
                    saveWeight()
                }
                .padding()
                
                Button(action: {
    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancelar")
                        .padding(.horizontal)
    //                    .frame(height: 40)
    //                    .background(Color.green)
                        .foregroundColor(.red)
    //                    .cornerRadius(20)
                }
            }
            
            
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
//        .padding(.horizontal)
        .padding(.vertical)
        
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
        presentationMode.wrappedValue.dismiss()
    }
}

struct WeightEntryView_Previews: PreviewProvider {
    static var previews: some View {
        WeightEntryView()
    }
}

