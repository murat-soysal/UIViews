//
// iosviews.com
//

import SwiftUI

// MARK: - App Model

struct AppItem: Identifiable {
    let id = UUID()
    let name: String
    let subtitle: String
    let description: String
    let category: String
    let icon: String
    let color: Color
    let rating: Double
    let reviews: String
    let size: String
    let age: String
    let developer: String
}

// MARK: - Sample Data

let storeApps: [AppItem] = [

    AppItem(
        name: "Focus",
        subtitle: "Focus better. Do more.",
        description: "Focus helps you stay productive with powerful tools designed to eliminate distractions and help you achieve your goals.",
        category: "Productivity",
        icon: "target",
        color: .blue,
        rating: 4.8,
        reviews: "12K",
        size: "84 MB",
        age: "4+",
        developer: "Focus Labs"
    ),

    AppItem(
        name: "Travel",
        subtitle: "Explore the world.",
        description: "Discover amazing places, plan your next adventure and keep all your travel plans in one beautiful app.",
        category: "Travel",
        icon: "airplane",
        color: .purple,
        rating: 4.7,
        reviews: "8.4K",
        size: "112 MB",
        age: "4+",
        developer: "Travel Studio"
    ),

    AppItem(
        name: "Notely",
        subtitle: "Notes made simple.",
        description: "A beautiful and powerful notes app for capturing ideas, organizing thoughts and getting things done.",
        category: "Productivity",
        icon: "note.text",
        color: .orange,
        rating: 4.9,
        reviews: "24K",
        size: "62 MB",
        age: "4+",
        developer: "Notely Inc."
    ),

    AppItem(
        name: "Weatherly",
        subtitle: "Weather at a glance.",
        description: "Beautiful weather forecasts, live conditions and detailed information wherever you go.",
        category: "Weather",
        icon: "cloud.sun.fill",
        color: .cyan,
        rating: 4.6,
        reviews: "9.2K",
        size: "48 MB",
        age: "4+",
        developer: "Weatherly"
    ),

    AppItem(
        name: "Music Box",
        subtitle: "Music everywhere.",
        description: "Discover new music, build playlists and enjoy your favorite songs wherever you are.",
        category: "Music",
        icon: "music.note",
        color: .pink,
        rating: 4.8,
        reviews: "31K",
        size: "95 MB",
        age: "12+",
        developer: "Music Box"
    ),

    AppItem(
        name: "Finance",
        subtitle: "Your money, organized.",
        description: "Track expenses, manage budgets and understand your finances with a simple and beautiful interface.",
        category: "Finance",
        icon: "chart.bar.fill",
        color: .green,
        rating: 4.7,
        reviews: "15K",
        size: "72 MB",
        age: "4+",
        developer: "Finance Labs"
    )
]

// MARK: - Main Content

struct ContentView: View {

    var body: some View {

        TabView {

            DiscoverView()
                .tabItem {
                    Label("Today", systemImage: "square.grid.2x2.fill")
                }

            GamesView()
                .tabItem {
                    Label("Games", systemImage: "gamecontroller.fill")
                }

            AppsView()
                .tabItem {
                    Label("Apps", systemImage: "square.stack.3d.up.fill")
                }

            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        }
        .tint(.blue)
    }
}

// MARK: - Discover

struct DiscoverView: View {

    @State private var selectedApp: AppItem?

    var body: some View {

        NavigationStack {

            ScrollView(.vertical, showsIndicators: false) {

                VStack(alignment: .leading, spacing: 30) {

                    header

                    featuredSection

                    popularSection

                    categoriesSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 40)
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $selectedApp) { app in
                AppDetailView(app: app)
            }
        }
    }

    private var header: some View {

        VStack(alignment: .leading, spacing: 5) {

            Text("Saturday, August 1")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text("Today")
                .font(.system(size: 38, weight: .bold))
        }
    }

    private var featuredSection: some View {

        VStack(alignment: .leading, spacing: 15) {

            SectionHeader(title: "Featured")

            ScrollView(.horizontal, showsIndicators: false) {

                HStack(spacing: 16) {

                    ForEach(storeApps.prefix(3)) { app in

                        FeaturedCard(app: app)
                            .onTapGesture {
                                selectedApp = app
                            }
                    }
                }
            }
        }
    }

    private var popularSection: some View {

        VStack(alignment: .leading, spacing: 15) {

            SectionHeader(title: "Popular Apps")

            VStack(spacing: 0) {

                ForEach(
                    Array(storeApps.prefix(5).enumerated()),
                    id: \.element.id
                ) { index, app in

                    AppRow(
                        rank: index + 1,
                        app: app
                    )
                    .onTapGesture {
                        selectedApp = app
                    }

                    if index < 4 {
                        Divider()
                            .padding(.leading, 92)
                    }
                }
            }
        }
    }

    private var categoriesSection: some View {

        VStack(alignment: .leading, spacing: 15) {

            SectionHeader(title: "Explore Categories")

            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ],
                spacing: 12
            ) {

                CategoryCard(
                    title: "Productivity",
                    icon: "checkmark.circle.fill",
                    color: .blue
                )

                CategoryCard(
                    title: "Photography",
                    icon: "camera.fill",
                    color: .pink
                )

                CategoryCard(
                    title: "Music",
                    icon: "music.note",
                    color: .purple
                )

                CategoryCard(
                    title: "Finance",
                    icon: "chart.bar.fill",
                    color: .green
                )

                CategoryCard(
                    title: "Travel",
                    icon: "airplane",
                    color: .orange
                )

                CategoryCard(
                    title: "Education",
                    icon: "book.fill",
                    color: .indigo
                )
            }
        }
    }
}

// MARK: - Featured Card

struct FeaturedCard: View {

    let app: AppItem

    var body: some View {

        VStack(alignment: .leading, spacing: 0) {

            ZStack(alignment: .bottomLeading) {

                RoundedRectangle(cornerRadius: 26)
                    .fill(
                        LinearGradient(
                            colors: [
                                app.color,
                                app.color.opacity(0.55)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                VStack(alignment: .leading, spacing: 9) {

                    Image(systemName: app.icon)
                        .font(.system(size: 38, weight: .medium))
                        .foregroundStyle(.white)

                    Spacer()

                    Text(app.category.uppercased())
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.white.opacity(0.75))

                    Text(app.name)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(.white)

                    Text(app.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.9))
                }
                .padding(22)
            }
            .frame(width: 310, height: 245)

            HStack(spacing: 12) {

                AppIcon(
                    app: app,
                    size: 48
                )

                VStack(alignment: .leading, spacing: 2) {

                    Text(app.name)
                        .fontWeight(.semibold)

                    Text(app.category)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                DownloadButton()
            }
            .padding(.top, 12)
        }
        .frame(width: 310)
    }
}

// MARK: - App Row

struct AppRow: View {

    let rank: Int
    let app: AppItem

    var body: some View {

        HStack(spacing: 13) {

            Text("\(rank)")
                .font(.headline)
                .foregroundStyle(.secondary)
                .frame(width: 24)

            AppIcon(
                app: app,
                size: 64
            )

            VStack(alignment: .leading, spacing: 4) {

                Text(app.name)
                    .font(.headline)

                Text(app.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                HStack(spacing: 4) {

                    Image(systemName: "star.fill")
                        .font(.caption2)

                    Text(String(format: "%.1f", app.rating))
                        .font(.caption)

                    Text("•")
                        .foregroundStyle(.secondary)

                    Text(app.category)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            DownloadButton()
        }
        .padding(.vertical, 13)
        .contentShape(Rectangle())
    }
}

// MARK: - App Detail

struct AppDetailView: View {

    let app: AppItem

    @Environment(\.dismiss)
    private var dismiss

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(alignment: .leading, spacing: 24) {

                    HStack(alignment: .top, spacing: 16) {

                        AppIcon(
                            app: app,
                            size: 100
                        )

                        VStack(alignment: .leading, spacing: 6) {

                            Text(app.name)
                                .font(.system(size: 28, weight: .bold))

                            Text(app.subtitle)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            Text(app.developer)
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            Spacer()

                            DownloadButton()
                        }

                        Spacer()
                    }

                    Divider()

                    HStack {

                        RatingColumn(
                            title: "RATING",
                            value: String(format: "%.1f", app.rating),
                            icon: "star.fill"
                        )

                        Spacer()

                        RatingColumn(
                            title: "REVIEWS",
                            value: app.reviews,
                            icon: "text.bubble.fill"
                        )

                        Spacer()

                        RatingColumn(
                            title: "AGE",
                            value: app.age,
                            icon: "person.fill"
                        )

                        Spacer()

                        RatingColumn(
                            title: "SIZE",
                            value: app.size,
                            icon: "internaldrive.fill"
                        )
                    }

                    Divider()

                    VStack(alignment: .leading, spacing: 10) {

                        Text("About this app")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text(app.description)
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .lineSpacing(4)
                    }

                    VStack(alignment: .leading, spacing: 12) {

                        Text("What's New")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text("Version 4.2.1")
                            .fontWeight(.semibold)

                        Text("Improved performance, smoother animations and several bug fixes.")
                            .foregroundStyle(.secondary)
                    }

                    VStack(alignment: .leading, spacing: 12) {

                        Text("Information")
                            .font(.title2)
                            .fontWeight(.bold)

                        InfoRow(
                            title: "Developer",
                            value: app.developer
                        )

                        InfoRow(
                            title: "Category",
                            value: app.category
                        )

                        InfoRow(
                            title: "Size",
                            value: app.size
                        )

                        InfoRow(
                            title: "Age Rating",
                            value: app.age
                        )
                    }
                }
                .padding(20)
            }
            .navigationTitle(app.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                ToolbarItem(placement: .topBarTrailing) {

                    Button {
                        dismiss()
                    } label: {

                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}

// MARK: - Rating Column

struct RatingColumn: View {

    let title: String
    let value: String
    let icon: String

    var body: some View {

        VStack(spacing: 5) {

            Text(title)
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)

            HStack(spacing: 3) {

                Image(systemName: icon)
                    .font(.caption)

                Text(value)
                    .font(.headline)
            }
        }
    }
}

// MARK: - Info Row

struct InfoRow: View {

    let title: String
    let value: String

    var body: some View {

        HStack {

            Text(title)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .fontWeight(.medium)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Search

struct SearchView: View {

    @State private var searchText = ""
    @State private var selectedApp: AppItem?

    private var filteredApps: [AppItem] {

        if searchText.isEmpty {
            return storeApps
        }

        return storeApps.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.category.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {

        NavigationStack {

            List {

                if filteredApps.isEmpty {

                    ContentUnavailableView(
                        "No Apps Found",
                        systemImage: "magnifyingglass",
                        description: Text("Try searching for another app.")
                    )

                } else {

                    ForEach(filteredApps) { app in

                        AppSearchRow(app: app)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedApp = app
                            }
                    }
                }
            }
            .navigationTitle("Search")
            .searchable(
                text: $searchText,
                prompt: "Apps, games and more"
            )
            .sheet(item: $selectedApp) { app in
                AppDetailView(app: app)
            }
        }
    }
}

// MARK: - Search Row

struct AppSearchRow: View {

    let app: AppItem

    var body: some View {

        HStack(spacing: 14) {

            AppIcon(
                app: app,
                size: 58
            )

            VStack(alignment: .leading, spacing: 4) {

                Text(app.name)
                    .fontWeight(.semibold)

                Text(app.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(app.category)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            DownloadButton()
        }
        .padding(.vertical, 5)
    }
}

// MARK: - Games

struct GamesView: View {

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(alignment: .leading, spacing: 24) {

                    Text("Games")
                        .font(.system(size: 36, weight: .bold))

                    GameBanner(
                        title: "Discover your next game",
                        subtitle: "New adventures are waiting.",
                        icon: "gamecontroller.fill",
                        color: .purple
                    )

                    SectionHeader(title: "Top Games")

                    ForEach(storeApps.prefix(3)) { app in

                        AppRow(
                            rank: 1,
                            app: app
                        )
                    }
                }
                .padding(20)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Apps

struct AppsView: View {

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(alignment: .leading, spacing: 24) {

                    Text("Apps")
                        .font(.system(size: 36, weight: .bold))

                    GameBanner(
                        title: "Essential apps",
                        subtitle: "Tools that make everyday life easier.",
                        icon: "square.stack.3d.up.fill",
                        color: .blue
                    )

                    SectionHeader(title: "Top Apps")

                    ForEach(Array(storeApps.enumerated()), id: \.element.id) {
                        index,
                        app in

                        AppRow(
                            rank: index + 1,
                            app: app
                        )
                    }
                }
                .padding(20)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Game Banner

struct GameBanner: View {

    let title: String
    let subtitle: String
    let icon: String
    let color: Color

    var body: some View {

        ZStack {

            RoundedRectangle(cornerRadius: 26)
                .fill(
                    LinearGradient(
                        colors: [
                            color,
                            color.opacity(0.55)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            HStack {

                VStack(alignment: .leading, spacing: 8) {

                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)

                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.85))
                }

                Spacer()

                Image(systemName: icon)
                    .font(.system(size: 45))
                    .foregroundStyle(.white.opacity(0.9))
            }
            .padding(22)
        }
        .frame(height: 150)
    }
}

// MARK: - Section Header

struct SectionHeader: View {

    let title: String

    var body: some View {

        HStack {

            Text(title)
                .font(.title2)
                .fontWeight(.bold)

            Spacer()

            Button("See All") {
            }
            .font(.subheadline)
            .fontWeight(.medium)
        }
    }
}

// MARK: - App Icon

struct AppIcon: View {

    let app: AppItem
    let size: CGFloat

    var body: some View {

        ZStack {

            RoundedRectangle(
                cornerRadius: size * 0.23
            )
            .fill(
                LinearGradient(
                    colors: [
                        app.color,
                        app.color.opacity(0.6)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )

            Image(systemName: app.icon)
                .font(
                    .system(
                        size: size * 0.42,
                        weight: .medium
                    )
                )
                .foregroundStyle(.white)
        }
        .frame(
            width: size,
            height: size
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: size * 0.23
            )
        )
        .shadow(
            color: .black.opacity(0.12),
            radius: 6,
            y: 3
        )
    }
}

// MARK: - Download Button

struct DownloadButton: View {

    var body: some View {

        Button {
            // Download action
        } label: {

            Text("GET")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.blue)
                .padding(.horizontal, 18)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(
                            Color.blue.opacity(0.12)
                        )
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Category Card

struct CategoryCard: View {

    let title: String
    let icon: String
    let color: Color

    var body: some View {

        HStack(spacing: 12) {

            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)

            Text(title)
                .fontWeight(.semibold)

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(
                    Color.secondary.opacity(0.08)
                )
        )
    }
}


// MARK: - Preview

#Preview {
    ContentView()
}
