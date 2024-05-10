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
    @State private var isRunning = false

    var body: some View {
        VStack {
            
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




