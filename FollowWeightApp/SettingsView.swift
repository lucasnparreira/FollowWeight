//
//  SettingsView.swift
//  FollowWeightApp
//
//  Created by Lucas Parreira on 07/05/2024.
//

import SwiftUI
import UserNotifications

struct SettingsView: View {
    @AppStorage("reminderEnabled") private var reminderEnabled = false
    @AppStorage("reminderFrequency") private var reminderFrequency: ReminderFrequency = .daily
    @AppStorage("motivationalQuotesEnabled") private var motivationalQuotesEnabled = false
    private var isRunning = false

    var body: some View {
        VStack {
            Toggle("Frases motivacionais", isOn: $motivationalQuotesEnabled)
                .padding()
                .onChange(of: motivationalQuotesEnabled) { enabled in
                    if enabled {
                        isRunning = true
                        scheduleMotivationalQuotes()
                    } else {
                        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["motivationalQuotes"])
                        stopScheduleMotivationalQuotes()
                    }
                } 
            
            Toggle("Lembrete de atualização de peso", isOn: $reminderEnabled)
                .padding()
                .onChange(of: reminderEnabled) { enabled in
                    if enabled {
                        requestNotificationAuthorization()
                    } else {
                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                    }
                }
            
            if reminderEnabled {
                Picker("Frequência do lembrete", selection: $reminderFrequency) {
                    ForEach(ReminderFrequency.allCases, id: \.self) { frequency in
                        Text(frequency.rawValue.capitalized)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Configurações")
    }
    
    private func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
            if let error = error {
                print("Erro ao solicitar autorização para notificações: \(error.localizedDescription)")
            } else {
                if success {
                    scheduleNotification()
                } else {
                    print("Usuário negou permissão para notificações")
                }
            }
        }
    }
    
    private func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Atualizar Peso"
        content.body = "Lembre-se de atualizar o seu peso no aplicativo!"
        content.sound = UNNotificationSound.default
        
        let trigger: UNNotificationTrigger
        
        switch reminderFrequency {
        case .daily:
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60 * 60 * 24, repeats: true)
        case .weekly:
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60 * 60 * 24 * 7, repeats: true)
        case .biweekly:
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60 * 60 * 24 * 14, repeats: true)
        case .monthly:
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60 * 60 * 24 * 30, repeats: true)
        }
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    private func scheduleMotivationalQuotes() {
        while isRunning {
            guard let quotes = loadMotivationalQuotes() else {
                print("Erro ao carregar as frases motivacionais")
                return
            }
            // Selecionar aleatoriamente uma frase motivacional
            let randomIndex = Int.random(in: 0..<quotes.count)
            let randomQuote = quotes[randomIndex]
            
            let content = UNMutableNotificationContent()
            content.title = "Frase Motivacional"
            content.body = randomQuote
            content.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
            
            let request = UNNotificationRequest(identifier: "motivationalQuotes", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Erro ao agendar notificação de frases motivacionais: \(error.localizedDescription)")
                } else {
                    print("Notificação de frases motivacionais agendada com sucesso")
                    print(randomQuote)
                }
            }
        }
    }

    // Função para parar a execução
    private func stopScheduleMotivationalQuotes() {
        isRunning = false
    }
    
    private func loadMotivationalQuotes() -> [String]? {
        if let path = Bundle.main.path(forResource: "data", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let quotes = try JSONDecoder().decode([String].self, from: data)
                return quotes
            } catch {
                print("Erro ao ler o arquivo JSON: \(error.localizedDescription)")
                return nil
            }
        } else {
            print("Arquivo JSON não encontrado")
            return nil
        }
    }
}

enum ReminderFrequency: String, CaseIterable {
    case daily = "diario"
    case weekly = "semanal"
    case biweekly = "quinzenal"
    case monthly = "mensal"
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}




