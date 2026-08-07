//
// iosviews.com
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: MovieTab = .home

    // MARK: - Main View

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house.fill", value: .home) {
                MovieHomeView()
            }
            Tab("Search", systemImage: "magnifyingglass", value: .search) {
                MoviePlaceholder(title: "Search", icon: "magnifyingglass")
            }
            Tab("Watchlist", systemImage: "bookmark.fill", value: .watchlist) {
                MoviePlaceholder(title: "Watchlist", icon: "bookmark.fill")
            }
            Tab("You", systemImage: "person.fill", value: .you) {
                MoviePlaceholder(title: "You", icon: "person.fill")
            }
        }
        .tint(MovieTheme.yellow)
        .preferredColorScheme(.dark)
    }
}

// MARK: - Home

private struct MovieHomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    header
                    searchBar
                    FeaturedMovie()
                    sectionHeader("Popular this week", action: "See all")
                    PosterRail(movies: [
                        Movie(title: "The Last Horizon", subtitle: "2026 · Sci-Fi", style: .horizon),
                        Movie(title: "The Green Room", subtitle: "2025 · Drama", style: .greenRoom),
                        Movie(title: "After Midnight", subtitle: "2026 · Thriller", style: .midnight),
                        Movie(title: "Before Dawn", subtitle: "2025 · Romance", style: .dawn)
                    ])
                    sectionHeader("Top picks for you", action: "")
                    TopPickRow()
                    sectionHeader("Coming soon", action: "See all")
                    PosterRail(movies: [
                        Movie(title: "Solaris", subtitle: "Aug 15", style: .solaris),
                        Movie(title: "Wild Hearts", subtitle: "Aug 22", style: .wildHearts),
                        Movie(title: "The Divide", subtitle: "Sep 6", style: .divide)
                    ])
                }
                .padding(.bottom, 28)
            }
            .background(MovieTheme.background)
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack(spacing: 11) {
            Text("CINEBASE")
                .font(.system(size: 23, weight: .black, design: .rounded))
                .tracking(-0.6)
                .foregroundStyle(.black)
                .padding(.horizontal, 8)
                .padding(.vertical, 5)
                .background(MovieTheme.yellow)
                .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
            Spacer()
            Button { } label: {
                Image(systemName: "bell")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(.white)
            }
            Button { } label: {
                Text("A")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.black)
                    .frame(width: 33, height: 33)
                    .background(MovieTheme.yellow)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 17)
        .padding(.top, 10)
        .padding(.bottom, 15)
    }

    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
            Text("Search movies, TV shows, and people")
                .font(.system(size: 15))
            Spacer()
            Image(systemName: "mic.fill")
        }
        .foregroundStyle(.white.opacity(0.70))
        .padding(.horizontal, 13)
        .frame(height: 46)
        .background(MovieTheme.search)
        .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
        .padding(.horizontal, 17)
        .padding(.bottom, 18)
    }

    private func sectionHeader(_ title: String, action: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 22, weight: .bold))
            Spacer()
            if !action.isEmpty {
                Button(action) { }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(MovieTheme.yellow)
            }
        }
        .padding(.horizontal, 17)
        .padding(.top, 27)
        .padding(.bottom, 13)
    }
}

// MARK: - Featured Movie

private struct FeaturedMovie: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [Color(red: 0.08, green: 0.12, blue: 0.18), Color(red: 0.34, green: 0.15, blue: 0.10), Color.black],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            Circle()
                .fill(Color(red: 0.94, green: 0.41, blue: 0.13).opacity(0.6))
                .frame(width: 220, height: 220)
                .blur(radius: 18)
                .offset(x: 235, y: -90)
            Image(systemName: "sparkles.tv.fill")
                .font(.system(size: 145, weight: .ultraLight))
                .foregroundStyle(.white.opacity(0.18))
                .offset(x: 225, y: -54)
            VStack(alignment: .leading, spacing: 8) {
                Text("IMAX EXPERIENCE")
                    .font(.system(size: 11, weight: .bold))
                    .tracking(1.3)
                    .foregroundStyle(MovieTheme.yellow)
                Text("THE LAST\nHORIZON")
                    .font(.system(size: 36, weight: .black, design: .serif))
                    .lineSpacing(-5)
                HStack(spacing: 7) {
                    Label("8.7", systemImage: "star.fill")
                        .foregroundStyle(MovieTheme.yellow)
                    Text("2026")
                    Text("•")
                    Text("2h 14m")
                }
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white.opacity(0.85))
                Button { } label: {
                    Label("Watch trailer", systemImage: "play.fill")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.black)
                        .padding(.horizontal, 17)
                        .frame(height: 42)
                        .background(MovieTheme.yellow)
                        .clipShape(Capsule())
                }
                .padding(.top, 4)
            }
            .foregroundStyle(.white)
            .padding(20)
        }
        .frame(height: 290)
    }
}

// MARK: - Rails

private struct PosterRail: View {
    let movies: [Movie]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 13) {
                ForEach(movies) { movie in
                    MoviePoster(movie: movie)
                }
            }
            .padding(.horizontal, 17)
        }
    }
}

private struct MoviePoster: View {
    let movie: Movie

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            PosterArtwork(style: movie.style)
                .frame(width: 126, height: 186)
                .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                .overlay(alignment: .topTrailing) {
                    Image(systemName: "bookmark.fill")
                        .font(.system(size: 15))
                        .foregroundStyle(.white)
                        .padding(9)
                }
            Text(movie.title)
                .font(.system(size: 14, weight: .semibold))
                .lineLimit(1)
                .frame(width: 126, alignment: .leading)
            Text(movie.subtitle)
                .font(.system(size: 12))
                .foregroundStyle(.white.opacity(0.58))
        }
    }
}

private struct TopPickRow: View {
    var body: some View {
        HStack(spacing: 13) {
            PosterArtwork(style: .greenRoom)
                .frame(width: 95, height: 135)
                .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            VStack(alignment: .leading, spacing: 8) {
                Text("The Green Room")
                    .font(.system(size: 21, weight: .bold))
                HStack(spacing: 6) {
                    Image(systemName: "star.fill").foregroundStyle(MovieTheme.yellow)
                    Text("8.2")
                    Text("· 2025 · Drama")
                }
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white.opacity(0.82))
                Text("A sharp, intimate story about ambition and finding your own voice.")
                    .font(.system(size: 14))
                    .foregroundStyle(.white.opacity(0.63))
                    .lineLimit(2)
                Button { } label: {
                    Label("Add to Watchlist", systemImage: "plus")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.black)
                        .padding(.horizontal, 13)
                        .frame(height: 35)
                        .background(MovieTheme.yellow)
                        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                }
            }
        }
        .padding(14)
        .background(MovieTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
        .padding(.horizontal, 17)
    }
}

// MARK: - Artwork

private struct PosterArtwork: View {
    let style: PosterStyle

    var body: some View {
        ZStack {
            switch style {
            case .horizon:
                LinearGradient(colors: [Color(red: 0.82, green: 0.25, blue: 0.08), Color(red: 0.05, green: 0.08, blue: 0.18)], startPoint: .top, endPoint: .bottom)
                VStack(spacing: 4) {
                    Text("THE LAST")
                    Text("HORIZON").font(.system(size: 19, weight: .black, design: .serif))
                    Image(systemName: "sun.horizon.fill").font(.system(size: 36)).foregroundStyle(MovieTheme.yellow)
                }
            case .greenRoom:
                LinearGradient(colors: [Color(red: 0.1, green: 0.50, blue: 0.42), Color(red: 0.02, green: 0.11, blue: 0.10)], startPoint: .top, endPoint: .bottom)
                VStack(spacing: 5) {
                    Image(systemName: "door.left.hand.open").font(.system(size: 43, weight: .light))
                    Text("THE\nGREEN ROOM")
                }
            case .midnight:
                LinearGradient(colors: [Color(red: 0.12, green: 0.05, blue: 0.25), .black], startPoint: .topLeading, endPoint: .bottomTrailing)
                VStack(spacing: 7) {
                    Image(systemName: "moon.stars.fill").font(.system(size: 38))
                    Text("AFTER\nMIDNIGHT")
                }
            case .dawn:
                LinearGradient(colors: [Color(red: 0.94, green: 0.48, blue: 0.40), Color(red: 0.33, green: 0.13, blue: 0.23)], startPoint: .top, endPoint: .bottom)
                VStack(spacing: 6) {
                    Image(systemName: "cloud.sun.fill").font(.system(size: 35))
                    Text("BEFORE\nDAWN")
                }
            case .solaris:
                LinearGradient(colors: [.yellow.opacity(0.9), .red.opacity(0.8)], startPoint: .top, endPoint: .bottom)
                Text("SOLARIS").font(.system(size: 19, weight: .black, design: .serif))
            case .wildHearts:
                LinearGradient(colors: [.pink, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                VStack(spacing: 5) { Image(systemName: "heart.fill").font(.system(size: 38)); Text("WILD\nHEARTS") }
            case .divide:
                LinearGradient(colors: [.gray, .black], startPoint: .top, endPoint: .bottom)
                VStack(spacing: 7) { Image(systemName: "mountain.2.fill").font(.system(size: 41)); Text("THE\nDIVIDE") }
            }
        }
        .foregroundStyle(.white)
        .multilineTextAlignment(.center)
        .font(.system(size: 13, weight: .bold, design: .rounded))
    }
}

// MARK: - Models & Theme

private struct Movie: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let style: PosterStyle
}

private enum PosterStyle { case horizon, greenRoom, midnight, dawn, solaris, wildHearts, divide }
private enum MovieTab: Hashable { case home, search, watchlist, you }

private enum MovieTheme {
    static let yellow = Color(red: 0.96, green: 0.78, blue: 0.12)
    static let background = Color(red: 0.07, green: 0.07, blue: 0.08)
    static let search = Color(red: 0.18, green: 0.18, blue: 0.20)
    static let card = Color(red: 0.14, green: 0.14, blue: 0.16)
}

private struct MoviePlaceholder: View {
    let title: String
    let icon: String

    var body: some View {
        ZStack {
            MovieTheme.background.ignoresSafeArea()
            ContentUnavailableView(title, systemImage: icon)
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    ContentView()
}
