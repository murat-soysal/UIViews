//
// iosviews.com
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: FinanceTab = .home

    // MARK: - Main View

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "r.square.fill", value: .home) {
                dashboard
            }
            Tab("Invest", systemImage: "chart.line.uptrend.xyaxis", value: .invest) {
                FinancePlaceholder(title: "Invest", icon: "chart.line.uptrend.xyaxis")
            }
            Tab("Payments", systemImage: "arrow.left.arrow.right", value: .payments) {
                FinancePlaceholder(title: "Payments", icon: "arrow.left.arrow.right")
            }
            Tab("Crypto", systemImage: "bitcoinsign.circle", value: .crypto) {
                FinancePlaceholder(title: "Crypto", icon: "bitcoinsign.circle")
            }
            Tab("Lifestyle", systemImage: "circle.grid.2x2.fill", value: .lifestyle) {
                FinancePlaceholder(title: "Lifestyle", icon: "circle.grid.2x2.fill")
            }
        }
        .tint(.white)
        .preferredColorScheme(.dark)
    }

    // MARK: - Dashboard

    private var dashboard: some View {
        ZStack(alignment: .bottom) {
            FinanceTheme.background.ignoresSafeArea()
            Circle()
                .fill(Color(red: 0.38, green: 0.58, blue: 1.0).opacity(0.28))
                .frame(width: 330, height: 330)
                .blur(radius: 55)
                .offset(x: 115, y: -310)
            Circle()
                .fill(Color(red: 0.31, green: 0.20, blue: 0.90).opacity(0.22))
                .frame(width: 270, height: 270)
                .blur(radius: 65)
                .offset(x: -145, y: -10)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    topBar
                    accountSummary
                    quickActions
                    activityCard
                    productsCard
                }
                .padding(.bottom, 28)
            }
        }
    }

    // MARK: - Header

    private var topBar: some View {
        HStack(spacing: 13) {
            ZStack(alignment: .topTrailing) {
                Circle().fill(LinearGradient(colors: [.brown, .black.opacity(0.85)], startPoint: .top, endPoint: .bottom))
                Image(systemName: "person.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.white.opacity(0.8))
                Circle().fill(.red).frame(width: 10, height: 10).offset(x: 2, y: -1)
            }
            .frame(width: 46, height: 46)

            HStack(spacing: 11) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 24, weight: .medium))
                Text("Search")
                    .font(.system(size: 18))
                    .foregroundStyle(.white.opacity(0.9))
                Spacer()
            }
            .padding(.horizontal, 16)
            .frame(height: 55)
            .background(.white.opacity(0.23))
            .clipShape(Capsule())
            .overlay(Capsule().stroke(.white.opacity(0.13), lineWidth: 1))

            roundHeaderButton("chart.bar.fill")
            roundHeaderButton("creditcard.fill")
        }
        .padding(.horizontal, 20)
        .padding(.top, 13)
    }

    private func roundHeaderButton(_ icon: String) -> some View {
        Button { } label: {
            Image(systemName: icon)
                .font(.system(size: 21, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 55, height: 55)
                .background(.white.opacity(0.23))
                .clipShape(Circle())
                .overlay(Circle().stroke(.white.opacity(0.13), lineWidth: 1))
        }
    }

    // MARK: - Account

    private var accountSummary: some View {
        VStack(spacing: 10) {
            HStack(spacing: 7) {
                Circle().fill(Color(red: 0.48, green: 0.92, blue: 0.75)).frame(width: 7, height: 7)
                Text("Personal · All accounts")
            }
            .font(.system(size: 17, weight: .medium))
            .foregroundStyle(.white.opacity(0.86))
            HStack(alignment: .lastTextBaseline, spacing: 1) {
                Text("$19")
                    .font(.system(size: 58, weight: .bold, design: .rounded))
                Text(".98")
                    .font(.system(size: 31, weight: .bold, design: .rounded))
            }
            .foregroundStyle(.white)
            Button("Accounts") { }
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.white)
                .padding(.horizontal, 31)
                .frame(height: 56)
                .background(.white.opacity(0.24))
                .clipShape(Capsule())
                .overlay(Capsule().stroke(.white.opacity(0.14), lineWidth: 1))
            HStack(spacing: 6) {
                Circle().fill(.white.opacity(0.65)).frame(width: 7, height: 7)
                Circle().fill(.white.opacity(0.65)).frame(width: 7, height: 7)
                Circle().fill(.white).frame(width: 8, height: 8)
            }
            .padding(.top, 58)
        }
        .padding(.top, 150)
        .padding(.bottom, 58)
    }

    private var quickActions: some View {
        HStack {
            FinanceAction(icon: "plus", title: "Add money")
            FinanceAction(icon: "arrow.triangle.2.circlepath", title: "Move")
            FinanceAction(icon: "building.columns.fill", title: "Details")
            FinanceAction(icon: "ellipsis", title: "More")
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 35)
    }

    // MARK: - Activity

    private var activityCard: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Recent activity")
                    .font(.system(size: 17, weight: .semibold))
                Spacer()
                Image(systemName: "clock.arrow.circlepath")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white.opacity(0.52))
            }
            .padding(.horizontal, 20)
            .padding(.top, 19)
            ExchangeRow(
                from: "SGD",
                to: "USD",
                time: "Today, 23:27",
                primary: "+US$1.49",
                secondary: "-$2",
                isOutgoing: false
            )
            ExchangeRow(
                from: "SGD",
                to: "USD",
                time: "Today, 23:27",
                primary: "-$2",
                secondary: "+US$1.49",
                isOutgoing: true
            )
            Button("See all") { }
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.white)
                .padding(.top, 8)
                .padding(.bottom, 24)
        }
        .background(FinanceTheme.card.opacity(0.94))
        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 25, style: .continuous).stroke(.white.opacity(0.07), lineWidth: 1))
        .padding(.horizontal, 18)
    }

    private var productsCard: some View {
        VStack(alignment: .leading, spacing: 13) {
            HStack {
                Text("Products for you")
                    .font(.system(size: 18, weight: .semibold))
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                Spacer()
            }
            HStack(spacing: 10) {
                ProductBadge(icon: "chart.pie.fill", title: "Invest")
                ProductBadge(icon: "bitcoinsign.circle.fill", title: "Crypto")
                ProductBadge(icon: "shield.checkered", title: "Protection")
            }
        }
        .foregroundStyle(.white.opacity(0.65))
        .padding(22)
        .background(FinanceTheme.card.opacity(0.94))
        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 25, style: .continuous).stroke(.white.opacity(0.07), lineWidth: 1))
        .padding(.horizontal, 18)
        .padding(.top, 19)
    }

}

// MARK: - Components

private struct FinanceAction: View {
    let icon: String
    let title: String

    var body: some View {
        VStack(spacing: 11) {
            Image(systemName: icon)
                .font(.system(size: 28, weight: .medium))
                .foregroundStyle(.white)
                .frame(width: 82, height: 82)
                .background(.white.opacity(0.25))
                .clipShape(Circle())
                .overlay(Circle().stroke(.white.opacity(0.13), lineWidth: 1))
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.white)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct ExchangeRow: View {
    let from: String
    let to: String
    let time: String
    let primary: String
    let secondary: String
    let isOutgoing: Bool

    var body: some View {
        HStack(spacing: 15) {
            FlagPair()
                .frame(width: 74, height: 70)
            VStack(alignment: .leading, spacing: 8) {
                Text("\(from) → \(to)")
                    .font(.system(size: 21, weight: .medium))
                Text(time)
                    .font(.system(size: 16))
                    .foregroundStyle(.white.opacity(0.58))
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 10) {
                Text(primary)
                    .font(.system(size: 20, weight: .medium))
                Text(secondary)
                    .font(.system(size: 17))
                    .foregroundStyle(.white.opacity(0.58))
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 26)
    }
}

private struct FlagPair: View {
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Circle()
                .fill(LinearGradient(colors: [.red, .red, .white], startPoint: .top, endPoint: .bottom))
                .overlay(Text("✦").font(.system(size: 13)).foregroundStyle(.white).offset(x: -11, y: -10))
                .frame(width: 51, height: 51)
                .overlay(Circle().stroke(FinanceTheme.card, lineWidth: 2))
            Circle()
                .fill(LinearGradient(colors: [.red, .white, .red, .white, .red], startPoint: .top, endPoint: .bottom))
                .overlay(Rectangle().fill(.blue).frame(height: 22).offset(y: -12))
                .frame(width: 51, height: 51)
                .overlay(Circle().stroke(FinanceTheme.card, lineWidth: 2))
        }
    }
}

private struct ProductBadge: View {
    let icon: String
    let title: String

    var body: some View {
        VStack(spacing: 7) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.white.opacity(0.92))
                .frame(width: 42, height: 42)
                .background(.white.opacity(0.09))
                .clipShape(Circle())
            Text(title)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.white.opacity(0.68))
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Theme

private enum FinanceTheme {
    static let background = LinearGradient(
        colors: [Color(red: 0.26, green: 0.49, blue: 0.99), Color(red: 0.02, green: 0.04, blue: 0.30), Color(red: 0.0, green: 0.01, blue: 0.14)],
        startPoint: .top,
        endPoint: .bottom
    )
    static let card = Color(red: 0.10, green: 0.11, blue: 0.23)
}

private enum FinanceTab: Hashable { case home, invest, payments, crypto, lifestyle }

private struct FinancePlaceholder: View {
    let title: String
    let icon: String

    var body: some View {
        ZStack {
            FinanceTheme.background.ignoresSafeArea()
            ContentUnavailableView(title, systemImage: icon)
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    ContentView()
}
