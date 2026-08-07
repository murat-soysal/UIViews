//
// iosviews.com
//

import SwiftUI

struct SettingItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let color: Color
}

struct ContentView: View {

    let settings = [

        SettingItem(title: "Wi-Fi", icon: "wifi", color: .blue),
        SettingItem(title: "Bluetooth", icon: "bolt.horizontal.fill", color: .blue),
        SettingItem(title: "Cellular", icon: "antenna.radiowaves.left.and.right", color: .green),
        SettingItem(title: "Notifications", icon: "bell.badge.fill", color: .red),
        SettingItem(title: "Sounds & Haptics", icon: "speaker.wave.3.fill", color: .pink),
        SettingItem(title: "Focus", icon: "moon.fill", color: .indigo),
        SettingItem(title: "Screen Time", icon: "hourglass", color: .purple),
        SettingItem(title: "General", icon: "gearshape.fill", color: .gray),
        SettingItem(title: "Privacy & Security", icon: "hand.raised.fill", color: .blue),
        SettingItem(title: "Battery", icon: "battery.100", color: .green)
    ]

    var body: some View {

        NavigationStack {

            List {

                // Profile

                Section {

                    HStack(spacing: 15) {

                        Circle()
                            .fill(.blue.gradient)
                            .frame(width: 65, height: 65)
                            .overlay {

                                Image(systemName: "person.fill")
                                    .font(.system(size: 30))
                                    .foregroundStyle(.white)
                            }

                        VStack(alignment: .leading, spacing: 4) {

                            Text("Alex Johnson")
                                .font(.headline)

                            Text("Apple Account, iCloud, Media & Purchases")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .foregroundStyle(.gray)
                    }
                    .padding(.vertical, 5)

                }

                // Search

                Section {

                    HStack {

                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.gray)

                        Text("Search")
                            .foregroundStyle(.secondary)

                        Spacer()
                    }
                }

                // Settings

                Section {

                    ForEach(settings) { item in

                        NavigationLink {

                            DetailView(title: item.title)

                        } label: {

                            HStack(spacing: 15) {

                                RoundedRectangle(cornerRadius: 8)
                                    .fill(item.color)
                                    .frame(width: 32, height: 32)
                                    .overlay {

                                        Image(systemName: item.icon)
                                            .foregroundStyle(.white)
                                    }

                                Text(item.title)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct DetailView: View {

    let title: String

    @State private var enabled = true

    var body: some View {

        Form {

            Section {

                Toggle("Enabled", isOn: $enabled)

                Toggle("Automatic", isOn: .constant(false))

            }

            Section("Information") {

                LabeledContent("Version", value: "1.0")

                LabeledContent("Status", value: "Active")
            }
        }
        .navigationTitle(title)
    }
}

#Preview {
    ContentView()
}
