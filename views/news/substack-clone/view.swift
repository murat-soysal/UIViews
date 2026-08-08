//
// iosviews.com
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: AppTab = .home

    // MARK: - Main View

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house.fill", value: .home) {
                homeFeed
            }
            Tab("Explore", systemImage: "safari", value: .explore) {
                EmptyTabView(title: "Explore", icon: "safari")
            }
            Tab("Inbox", systemImage: "tray", value: .inbox) {
                EmptyTabView(title: "Inbox", icon: "tray")
            }
            Tab("Profile", systemImage: "person", value: .profile) {
                EmptyTabView(title: "Profile", icon: "person")
            }
        }
    }

    // MARK: - Home Feed

    private var homeFeed: some View {
        ZStack {
            Color(uiColor: .systemBackground).ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    appHeader
                    featuredStory
                    sectionHeader
                    publicationRow
                    latestHeader
                    StoryCard(
                        publication: "The Reading Room",
                        author: "Maya Chen",
                        title: "The quiet joy of making something slowly",
                        excerpt: "A weekly note on attention, creative practice, and choosing the work that lasts.",
                        tint: Color(red: 0.30, green: 0.24, blue: 0.18),
                        initials: "TR"
                    )
                    StoryCard(
                        publication: "Future Notes",
                        author: "Jon Bell",
                        title: "What we lose when every idea becomes content",
                        excerpt: "The internet rewards velocity. A case for taking the long way around.",
                        tint: Color(red: 0.13, green: 0.32, blue: 0.39),
                        initials: "FN"
                    )
                }
            }
        }
    }

    // MARK: - Header

    private var appHeader: some View {
        HStack(spacing: 12) {
            Image(systemName: "text.book.closed.fill")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 43, height: 43)
                .background(Color(red: 1.0, green: 0.36, blue: 0.09))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            Text("Substack")
                .font(.system(size: 26, weight: .bold, design: .rounded))

            Spacer()

            Button { } label: {
                Image(systemName: "bell")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.primary)
                    .frame(width: 39, height: 39)
                    .background(Color.primary.opacity(0.06))
                    .clipShape(Circle())
            }
            Button { } label: {
                Text("M")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 39, height: 39)
                    .background(Color(red: 0.23, green: 0.35, blue: 0.58))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 27)
    }

    // MARK: - Featured Story

    private var featuredStory: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(LinearGradient(colors: [Color(red: 0.13, green: 0.16, blue: 0.29), Color(red: 0.35, green: 0.19, blue: 0.24)], startPoint: .topLeading, endPoint: .bottomTrailing))

            VStack(alignment: .leading, spacing: 12) {
                Label("FEATURED", systemImage: "sparkles")
                    .font(.system(size: 11, weight: .bold))
                    .tracking(1.2)
                    .foregroundStyle(.white.opacity(0.72))
                Text("The ideas that\nchange us")
                    .font(.system(size: 31, weight: .bold, design: .serif))
                    .foregroundStyle(.white)
                Text("Essays worth keeping around")
                    .font(.system(size: 15))
                    .foregroundStyle(.white.opacity(0.78))
                HStack(spacing: 8) {
                    Circle().fill(.white.opacity(0.75)).frame(width: 20, height: 20)
                    Text("The Sunday Edit")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.white)
                }
            }
            .padding(24)
        }
        .frame(height: 245)
        .padding(.horizontal, 20)
    }

    // MARK: - Discovery

    private var sectionHeader: some View {
        HStack {
            Text("Find your next read")
                .font(.system(size: 22, weight: .bold, design: .rounded))
            Spacer()
            Button("Explore") { }
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color(red: 0.93, green: 0.29, blue: 0.08))
        }
        .padding(.horizontal, 20)
        .padding(.top, 30)
        .padding(.bottom, 16)
    }

    private var publicationRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 13) {
                PublicationPill(icon: "cup.and.saucer.fill", title: "Culture", color: Color(red: 0.93, green: 0.36, blue: 0.16))
                PublicationPill(icon: "pencil.line", title: "Writing", color: Color(red: 0.25, green: 0.45, blue: 0.69))
                PublicationPill(icon: "globe.americas.fill", title: "World", color: Color(red: 0.16, green: 0.52, blue: 0.43))
                PublicationPill(icon: "brain.head.profile", title: "Ideas", color: Color(red: 0.49, green: 0.35, blue: 0.65))
            }
            .padding(.horizontal, 20)
        }
    }

    private var latestHeader: some View {
        Text("Latest from your feed")
            .font(.system(size: 22, weight: .bold, design: .rounded))
            .padding(.horizontal, 20)
            .padding(.top, 34)
            .padding(.bottom, 8)
    }

}

private struct StoryCard: View {
    let publication: String
    let author: String
    let title: String
    let excerpt: String
    let tint: Color
    let initials: String

    // MARK: - Layout

    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            VStack(alignment: .leading, spacing: 7) {
                HStack(spacing: 6) {
                    Circle().fill(tint).frame(width: 17, height: 17)
                        .overlay(Text(initials.prefix(1)).font(.system(size: 8, weight: .bold)).foregroundStyle(.white))
                    Text(publication).font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
                Text(title)
                    .font(.system(size: 21, weight: .bold, design: .serif))
                    .lineLimit(2)
                Text(excerpt)
                    .font(.system(size: 14.5))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .lineSpacing(2)
                Text("By \(author)  ·  Today")
                    .font(.system(size: 12.5))
                    .foregroundStyle(.secondary)
                    .padding(.top, 2)
            }
            Spacer(minLength: 0)
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous).fill(tint)
                Text(initials)
                    .font(.system(size: 25, weight: .bold, design: .serif))
                    .foregroundStyle(.white.opacity(0.9))
            }
            .frame(width: 92, height: 112)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .overlay(alignment: .bottom) { Divider().padding(.leading, 20) }
    }
}

private struct PublicationPill: View {
    let icon: String
    let title: String
    let color: Color

    // MARK: - Layout

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(color)
            Text(title).font(.system(size: 15, weight: .semibold))
        }
        .foregroundStyle(.primary)
        .padding(.horizontal, 14)
        .frame(height: 42)
        .background(color.opacity(0.10))
        .clipShape(Capsule())
    }
}

// MARK: - Supporting Views

private struct EmptyTabView: View {
    let title: String
    let icon: String

    var body: some View {
        ContentUnavailableView(title, systemImage: icon)
    }
}

// MARK: - Tab Selection

private enum AppTab: Hashable { case home, explore, inbox, profile }

#Preview {
    ContentView()
}
