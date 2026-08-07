//
// iosviews.com
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: CoffeeTab = .home

    // MARK: - Main View

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house.fill", value: .home) {
                HomeView()
            }
            Tab("Scan", systemImage: "qrcode", value: .scan) {
                PlaceholderView(title: "Scan to pay", icon: "qrcode")
            }
            Tab("Order", systemImage: "cup.and.saucer.fill", value: .order) {
                PlaceholderView(title: "Order ahead", icon: "cup.and.saucer.fill")
            }
            Tab("Gifts", systemImage: "gift.fill", value: .gifts) {
                PlaceholderView(title: "Gifts", icon: "gift.fill")
            }
            Tab("Rewards", systemImage: "star.fill", value: .rewards) {
                PlaceholderView(title: "Rewards", icon: "star.fill")
            }
        }
        .tint(CoffeeTheme.green)
    }
}

// MARK: - Home

private struct HomeView: View {
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        greeting
                        quickActions
                        Divider()
                        RewardsBalance()
                            .padding(.horizontal, 18)
                            .padding(.top, 20)
                        ChallengeCard()
                            .padding(.horizontal, 18)
                            .padding(.top, 16)
                        gettingStarted
                    }
                    .padding(.bottom, 100)
                }

                Button { } label: {
                    Label("Scan in store", systemImage: "qrcode")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 25)
                        .frame(height: 67)
                        .background(CoffeeTheme.green)
                        .clipShape(Capsule())
                        .shadow(color: CoffeeTheme.green.opacity(0.28), radius: 13, y: 7)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 19)
            }
        }
    }

    // MARK: - Header

    private var greeting: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Morning, Alex")
                .font(.system(size: 37, weight: .bold, design: .rounded))
            Text("Ready for your next favorite?")
                .font(.system(size: 16))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 34)
    }

    private var quickActions: some View {
        HStack(spacing: 0) {
            QuickAction(icon: "envelope", title: "Inbox", hasNotification: true)
            QuickAction(icon: "mappin.and.ellipse", title: "Stores")
            Spacer(minLength: 12)
            QuickAction(icon: "receipt", title: "")
                .padding(.trailing, 18)
            QuickAction(icon: "person.circle", title: "")
        }
        .padding(.horizontal, 20)
        .frame(height: 44)
        .padding(.bottom, 20)
    }

    private var gettingStarted: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("LET'S GET STARTED")
                .font(.system(size: 13, weight: .bold))
                .tracking(1.1)
                .foregroundStyle(.secondary)
            HStack(spacing: 14) {
                Image(systemName: "cup.and.saucer.fill")
                    .font(.system(size: 30))
                    .foregroundStyle(CoffeeTheme.green)
                    .frame(width: 61, height: 61)
                    .background(CoffeeTheme.lightGreen)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 4) {
                    Text("Find your usual")
                        .font(.system(size: 19, weight: .semibold))
                    Text("Order your favorite drink with a few taps.")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                }
            }
            .padding(17)
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .padding(.horizontal, 20)
        .padding(.top, 31)
    }
}

// MARK: - Rewards

private struct RewardsBalance: View {
    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(CoffeeTheme.gold)

            CoffeeLeaves()
                .opacity(0.35)
                .offset(x: 4, y: -20)

            VStack(alignment: .leading, spacing: 5) {
                Text("Star balance")
                    .font(.system(size: 16, weight: .medium))
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text("597")
                        .font(.system(size: 46, weight: .bold, design: .rounded))
                    Text(" ★")
                        .font(.system(size: 35, weight: .bold))
                }
            }
            .foregroundStyle(CoffeeTheme.ink)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)

            VStack(alignment: .trailing, spacing: 4) {
                Text("GOLD")
                Text("STATUS")
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .bold))
                    .padding(.top, 4)
            }
            .font(.system(size: 14, weight: .bold))
            .foregroundStyle(CoffeeTheme.ink)
            .padding(19)
        }
        .frame(height: 164)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: .black.opacity(0.1), radius: 5, y: 2)
    }
}

private struct ChallengeCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Collect")
                    .font(.system(size: 16, weight: .semibold))
                (Text("75 Bonus Stars") + Text(" ★").foregroundStyle(CoffeeTheme.gold))
                    .font(.system(size: 27, weight: .bold, design: .rounded))
                Text("Jun 15 – 21")
                    .font(.system(size: 16))
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(CoffeeTheme.cream)

            VStack(alignment: .leading, spacing: 16) {
                Text("Try these 5 delicious things")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                Text("Come in and try these menu items in any order you want—or all at the same time.")
                    .font(.system(size: 17))
                    .foregroundStyle(.primary.opacity(0.84))
                    .fixedSize(horizontal: false, vertical: true)
                VStack(alignment: .leading, spacing: 9) {
                    Text("• any Green Tea")
                    Text("• any Croissant or Danish")
                    Text("• a Strawberry Açaí Refresher")
                    Text("• any Breakfast Sandwich or Wrap")
                    Text("• any Loaf, Muffin or Cake")
                }
                .font(.system(size: 16))
                .foregroundStyle(.primary.opacity(0.9))
                HStack {
                    Button("Start") { }
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 25)
                        .frame(height: 48)
                        .background(CoffeeTheme.green)
                        .clipShape(Capsule())
                    Spacer()
                    Button("Terms") { }
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(CoffeeTheme.green)
                }
                .padding(.top, 6)
            }
            .padding(20)
        }
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(.gray.opacity(0.22)))
        .shadow(color: .black.opacity(0.09), radius: 5, y: 2)
    }
}

// MARK: - Supporting Views

private struct QuickAction: View {
    let icon: String
    let title: String
    var hasNotification = false

    var body: some View {
        HStack(spacing: 9) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: icon)
                    .font(.system(size: 25, weight: .light))
                    .frame(width: 29, height: 32)
                if hasNotification {
                    Circle().fill(CoffeeTheme.green).frame(width: 10, height: 10)
                        .offset(x: 4, y: -1)
                }
            }
            if !title.isEmpty {
                Text(title).font(.system(size: 18, weight: .medium))
            }
        }
        .foregroundStyle(.primary.opacity(0.72))
        .frame(height: 36)
        .padding(.trailing, title.isEmpty ? 0 : 26)
    }
}

private struct CoffeeLeaves: View {
    var body: some View {
        ZStack {
            ForEach(0..<6, id: \.self) { index in
                Ellipse()
                    .fill(Color.white)
                    .frame(width: 66, height: 25)
                    .rotationEffect(.degrees(Double(index) * 26 - 25))
                    .offset(x: CGFloat(index % 3) * 50 - 27, y: CGFloat(index / 3) * 48)
            }
        }
        .frame(width: 190, height: 135)
    }
}

private struct PlaceholderView: View {
    let title: String
    let icon: String

    var body: some View {
        ContentUnavailableView(title, systemImage: icon)
    }
}

// MARK: - Theme & Models

private enum CoffeeTheme {
    static let green = Color(red: 0.0, green: 0.42, blue: 0.25)
    static let lightGreen = Color(red: 0.88, green: 0.96, blue: 0.92)
    static let gold = Color(red: 0.84, green: 0.63, blue: 0.23)
    static let cream = Color(red: 0.98, green: 0.94, blue: 0.86)
    static let ink = Color(red: 0.10, green: 0.12, blue: 0.11)
}

private enum CoffeeTab: Hashable { case home, scan, order, gifts, rewards }

#Preview {
    ContentView()
}
