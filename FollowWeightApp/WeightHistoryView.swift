//
//  WeightHistoryView.swift
//  FollowWeightApp
//
//  Created by Lucas Parreira on 05/05/2024.
//

import SwiftUI
import CoreData

struct WeightHistoryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \WeightEntry.date, ascending: true)],
        animation: .default)
    private var entries: FetchedResults<WeightEntry>

    @State private var filterWeight: String = ""
    @State private var filterDate = Date()
    @State private var isExportingCSV = false

    var body: some View {
        VStack {
            Text("Histórico de Pesos")
                .font(.headline)
                .navigationBarTitleDisplayMode(.inline)
                .padding(.top, 20)
            HStack {
                DatePicker("Filtrar data", selection: $filterDate, displayedComponents: .date)
                    .padding()
            }
            HStack {
                TextField("Filtrar por peso", text: $filterWeight)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }

            List {
                ForEach(filteredEntries) { entry in
                    HStack {
                        Text("\(String(format:"%.2f", entry.weight)) kg - \(entry.date!, formatter: dateFormatter)")
                        Spacer()
                        Button(action: {
                            deleteWeightEntry(entry)
                        }) {
                            Image(systemName: "trash")
                        }
                    }
                }
            }
            .font(.system(size: 14))
            

            Button(action: {
                exportDataToCSV()
            }) {
                if isExportingCSV {
                    ProgressView()
                } else {
                    Label("Exportar CSV", systemImage: "square.and.arrow.up")
                }
            }
            .padding()
            .disabled(isExportingCSV)
        }
        .padding(.top, 20)
    }
        
        

    private var filteredEntries: [WeightEntry] {
        var result = Array(entries)

        if !filterWeight.isEmpty {
            let filterWeightFloat = (filterWeight as NSString).floatValue
            result = result.filter { $0.weight == filterWeightFloat }
        }

        if !Calendar.current.isDate(filterDate, inSameDayAs: Date()) {
            result = result.filter { Calendar.current.isDate($0.date!, inSameDayAs: filterDate) }
        }

        return result
    }


    private func exportDataToCSV() {
        isExportingCSV = true
        var csvString = "Date,Weight\n"
        for entry in filteredEntries {
            csvString.append("\(entry.date!),\(entry.weight)\n")
        }

        let filename = "weight_history.csv"
        let path = FileManager.default.temporaryDirectory.appendingPathComponent(filename)

        do {
            try csvString.write(to: path, atomically: true, encoding: .utf8)
            let activityViewController = UIActivityViewController(activityItems: [path], applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true) {
                isExportingCSV = false
            }
        } catch {
            print("Failed to create CSV file: \(error.localizedDescription)")
            isExportingCSV = false
        }
    }

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    private func deleteWeightEntry(_ entry: WeightEntry) {
        viewContext.delete(entry)

        do {
            try viewContext.save()
        } catch {
            print("Failed to delete weight entry: \(error.localizedDescription)")
        }
    }
}

