//
// iosviews.com
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: BookTab = .home

    // MARK: - Main View

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house.fill", value: .home) {
                BookHomeView()
            }
            Tab("My Books", systemImage: "books.vertical", value: .books) {
                EmptyBookView(title: "My Books", icon: "books.vertical")
            }
            Tab("Discover", systemImage: "safari", value: .discover) {
                EmptyBookView(title: "Discover", icon: "safari")
            }
            Tab("Search", systemImage: "magnifyingglass", value: .search) {
                EmptyBookView(title: "Search books", icon: "magnifyingglass")
            }
            Tab("More", systemImage: "line.3.horizontal", value: .more) {
                EmptyBookView(title: "More", icon: "line.3.horizontal")
            }
        }
        .tint(BookTheme.green)
    }
}

// MARK: - Home

private struct BookHomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    appHeader
                    searchSection
                    promotions
                    VStack(spacing: 17) {
                        BookRecommendation(
                            category: "Business",
                            title: "Blue Ocean Strategy: How to Create Uncontested Market Space",
                            author: "W. Chan Kim",
                            cover: .blueOcean
                        )
                        BookRecommendation(
                            category: "Fiction",
                            title: "The Curious Incident of the Dog in the Night-Time",
                            author: "Mark Haddon",
                            cover: .curiousIncident
                        )
                        BookRecommendation(
                            category: "Fantasy",
                            title: "The Wind and the Willows",
                            author: "Marion Blackwood",
                            cover: .wind
                        )
                    }
                    .padding(.horizontal, 17)
                    .padding(.top, 21)
                    .padding(.bottom, 28)
                }
            }
            .background(BookTheme.page)
        }
    }

    // MARK: - Search & Promotions

    private var appHeader: some View {
        HStack {
            Text("Bookish")
                .font(.system(size: 28, weight: .bold, design: .serif))
                .foregroundStyle(BookTheme.ink)
            Spacer()
            Button { } label: {
                Image(systemName: "bell")
                    .font(.system(size: 19, weight: .medium))
                    .foregroundStyle(BookTheme.ink)
                    .frame(width: 38, height: 38)
            }
        }
        .padding(.horizontal, 18)
        .padding(.top, 8)
        .padding(.bottom, 5)
    }

    private var searchSection: some View {
        HStack(spacing: 11) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 22, weight: .medium))
            Text("Title, author or ISBN")
                .font(.system(size: 18))
                .foregroundStyle(.secondary)
            Spacer()
            Image(systemName: "camera")
                .font(.system(size: 22, weight: .medium))
        }
        .foregroundStyle(BookTheme.ink)
        .padding(.horizontal, 18)
        .frame(height: 59)
        .background(.white.opacity(0.88))
        .clipShape(Capsule())
        .overlay(Capsule().stroke(.white, lineWidth: 1))
        .shadow(color: .black.opacity(0.08), radius: 14, y: 6)
        .padding(.horizontal, 18)
        .padding(.top, 13)
        .padding(.bottom, 27)
    }

    private var promotions: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 13) {
                PromotionCard(
                    color: Color(red: 0.68, green: 0.70, blue: 0.94),
                    icon: "book.closed.fill",
                    title: "Join the Challenge",
                    subtitle: "New year, new reading goals! Set an annual goal today.",
                    badge: "2026"
                )
                PromotionCard(
                    color: Color(red: 0.55, green: 0.82, blue: 0.84),
                    icon: "books.vertical.fill",
                    title: "Build your shelf",
                    subtitle: "Discover books made for your next chapter.",
                    badge: nil
                )
            }
            .padding(.horizontal, 17)
        }
        .padding(.vertical, 13)
        .background(BookTheme.banner)
    }
}

// MARK: - Book Recommendation

private struct BookRecommendation: View {
    let category: String
    let title: String
    let author: String
    let cover: BookCoverStyle

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            (Text(category == "Fantasy" ? "Trending This Week in " : "Popular on Bookish in ") + Text(category).foregroundStyle(BookTheme.green))
                .font(.system(size: 19, weight: .medium))
                .padding(.horizontal, 18)
                .padding(.top, 20)
                .padding(.bottom, 18)

            HStack(alignment: .top, spacing: 16) {
                BookCover(style: cover)
                    .frame(width: 122, height: 185)
                    .shadow(color: .black.opacity(0.18), radius: 3, y: 2)

                VStack(alignment: .leading, spacing: 10) {
                    Text(title)
                        .font(.system(size: 20, weight: .medium, design: .serif))
                        .foregroundStyle(BookTheme.ink)
                        .lineLimit(4)
                    Text("by \(author)")
                        .font(.system(size: 16))
                        .foregroundStyle(.secondary)
                    Button { } label: {
                        HStack(spacing: 12) {
                            Text("Want to Read")
                            Spacer()
                            Image(systemName: "chevron.down.fill")
                                .font(.system(size: 12, weight: .bold))
                        }
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 14)
                        .frame(height: 46)
                        .background(BookTheme.button)
                        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                    }
                    HStack(spacing: 3) {
                        Text("Rate this book:")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                        ForEach(0..<5, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(.gray.opacity(0.18))
                        }
                    }
                    .padding(.top, 2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 21)
        }
        .background(.white.opacity(0.88))
        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 5, style: .continuous).stroke(.black.opacity(0.08), lineWidth: 1))
    }
}

// MARK: - Components

private struct PromotionCard: View {
    let color: Color
    let icon: String
    let title: String
    let subtitle: String
    let badge: String?

    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                RoundedRectangle(cornerRadius: 5).fill(BookTheme.green.opacity(0.78))
                if let badge {
                    VStack(spacing: 5) {
                        Text(badge).font(.system(size: 14, weight: .bold))
                        Image(systemName: "book.closed.fill").font(.system(size: 20))
                    }
                    .foregroundStyle(.white)
                } else {
                    Image(systemName: icon).font(.system(size: 31, weight: .medium)).foregroundStyle(BookTheme.ink)
                }
            }
            .frame(width: 58, height: 70)
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.system(size: 17, weight: .bold))
                Text(subtitle).font(.system(size: 14)).lineLimit(3)
            }
            .foregroundStyle(BookTheme.ink)
        }
        .padding(17)
        .frame(width: 335, height: 145, alignment: .leading)
        .background(color)
    }
}

private struct BookCover: View {
    let style: BookCoverStyle

    var body: some View {
        ZStack {
            switch style {
            case .blueOcean:
                LinearGradient(colors: [Color(red: 0.57, green: 0.82, blue: 0.92), Color(red: 0.03, green: 0.29, blue: 0.43)], startPoint: .top, endPoint: .bottom)
                VStack(spacing: 8) {
                    Text("BLUE\nOCEAN")
                    Text("STRATEGY").foregroundStyle(.yellow.opacity(0.85))
                    Spacer()
                    Text("W. CHAN KIM").font(.system(size: 7))
                }
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
                .padding(.vertical, 20)
            case .curiousIncident:
                Color(red: 0.80, green: 0.22, blue: 0.12)
                VStack(spacing: 17) {
                    Text("the curious incident\nof the dog\nin the night-time")
                        .font(.system(size: 10, weight: .medium))
                    Image(systemName: "hare.fill").font(.system(size: 24))
                    Text("MARK HADDON").font(.system(size: 7, weight: .bold))
                }
                .multilineTextAlignment(.center)
                .foregroundStyle(.white.opacity(0.84))
            case .wind:
                LinearGradient(colors: [.green.opacity(0.65), .teal.opacity(0.9)], startPoint: .top, endPoint: .bottom)
                VStack(spacing: 8) {
                    Text("THE WIND\nAND THE\nWILLOWS")
                    Image(systemName: "leaf.fill")
                }
                .font(.system(size: 14, weight: .bold, design: .serif))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
            }
        }
    }
}

// MARK: - Theme & Supporting Types

private enum BookCoverStyle { case blueOcean, curiousIncident, wind }
private enum BookTab: Hashable { case home, books, discover, search, more }

private enum BookTheme {
    static let page = Color(red: 0.97, green: 0.96, blue: 0.93)
    static let banner = Color(red: 0.91, green: 0.90, blue: 0.84)
    static let green = Color(red: 0.15, green: 0.40, blue: 0.36)
    static let button = Color(red: 0.28, green: 0.62, blue: 0.41)
    static let ink = Color(red: 0.12, green: 0.12, blue: 0.10)
}

private struct EmptyBookView: View {
    let title: String
    let icon: String

    var body: some View {
        ContentUnavailableView(title, systemImage: icon)
    }
}

#Preview {
    ContentView()
}
