//
// iosviews.com
//

import SwiftUI

struct ContentView: View {
    @State private var selection: NewsTab = .today

    // MARK: - Main View

    var body: some View {
        TabView(selection: $selection) {
            Tab("Today", systemImage: "newspaper.fill", value: .today) {
                TodayView()
            }
            Tab("News+", systemImage: "plus.rectangle.on.rectangle", value: .newsPlus) {
                PlaceholderView(title: "News+", subtitle: "Stories selected for you.", icon: "plus.rectangle.on.rectangle")
            }
            Tab("Following", systemImage: "heart", value: .following) {
                PlaceholderView(title: "Following", subtitle: "Publications you follow will appear here.", icon: "heart")
            }
            Tab("Saved", systemImage: "bookmark", value: .saved) {
                PlaceholderView(title: "Saved", subtitle: "Your saved stories will appear here.", icon: "bookmark")
            }
        }
    }
}

// MARK: - Today

private struct TodayView: View {
    @State private var selectedTopic = "Top Stories"
    private let topics = ["Top Stories", "World", "Business", "Science", "Culture"]

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("FRIDAY, AUGUST 1")
                        .font(.system(size: 12, weight: .bold))
                        .tracking(0.8)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 20)
                        .padding(.top, 5)

                    Text("Today")
                        .font(.system(size: 38, weight: .bold, design: .rounded))
                        .padding(.horizontal, 20)
                        .padding(.top, 2)

                    topicPicker
                    FeaturedArticle()
                    Divider().padding(.horizontal, 20).padding(.top, 25)
                    sectionTitle("TOP STORIES")
                    CompactArticle(
                        source: "THE DAILY EDIT",
                        title: "The new rules of a rapidly changing world",
                        summary: "What this week’s biggest stories mean for the months ahead.",
                        imageStyle: .amber
                    )
                    Divider().padding(.leading, 20)
                    CompactArticle(
                        source: "THE OBSERVER",
                        title: "Why cities are being redesigned around people",
                        summary: "A quiet shift is transforming the streets we call home.",
                        imageStyle: .blue
                    )
                    Divider().padding(.leading, 20)
                    sectionTitle("MORE TO EXPLORE")
                    ExploreGrid()
                }
                .padding(.bottom, 28)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { } label: {
                        Image(systemName: "person.crop.circle")
                            .font(.system(size: 25))
                            .foregroundStyle(.primary)
                    }
                }
            }
        }
    }

    // MARK: - Topic Picker

    private var topicPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 9) {
                ForEach(topics, id: \.self) { topic in
                    Button { selectedTopic = topic } label: {
                        Text(topic)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(selectedTopic == topic ? .white : .primary)
                            .padding(.horizontal, 15)
                            .frame(height: 34)
                            .background(selectedTopic == topic ? Color.black : Color.primary.opacity(0.08))
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 17)
        .padding(.bottom, 22)
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 12, weight: .bold))
            .tracking(0.9)
            .foregroundStyle(.secondary)
            .padding(.horizontal, 20)
            .padding(.top, 22)
            .padding(.bottom, 8)
    }
}

// MARK: - Article Cards

private struct FeaturedArticle: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                LinearGradient(
                    colors: [Color(red: 0.09, green: 0.20, blue: 0.32), Color(red: 0.33, green: 0.50, blue: 0.60)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(height: 240)

                Circle()
                    .stroke(.white.opacity(0.22), lineWidth: 34)
                    .frame(width: 190, height: 190)
                    .offset(x: 205, y: -83)
                Circle()
                    .fill(.white.opacity(0.12))
                    .frame(width: 82, height: 82)
                    .offset(x: 190, y: 42)

                VStack(alignment: .leading, spacing: 8) {
                    Text("THE ATLAS REVIEW")
                        .font(.system(size: 11, weight: .bold))
                        .tracking(0.8)
                        .foregroundStyle(.white.opacity(0.8))
                    Text("A new map for the\nworld we share")
                        .font(.system(size: 30, weight: .bold, design: .serif))
                        .foregroundStyle(.white)
                        .lineSpacing(-2)
                }
                .padding(22)
            }
            Text("The ideas and decisions shaping the next decade.")
                .font(.system(size: 17, weight: .semibold, design: .serif))
                .padding(.horizontal, 17)
                .padding(.top, 15)
                .padding(.bottom, 4)
            Text("The Atlas Review  ·  8 min read")
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 17)
                .padding(.bottom, 17)
        }
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .padding(.horizontal, 20)
    }
}

private struct CompactArticle: View {
    let source: String
    let title: String
    let summary: String
    let imageStyle: ArticleImageStyle

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            VStack(alignment: .leading, spacing: 6) {
                Text(source)
                    .font(.system(size: 11, weight: .bold))
                    .tracking(0.6)
                    .foregroundStyle(.secondary)
                Text(title)
                    .font(.system(size: 21, weight: .bold, design: .serif))
                    .lineLimit(2)
                    .lineSpacing(-1)
                Text(summary)
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                Text("Today  ·  5 min read")
                    .font(.system(size: 12))
                    .foregroundStyle(.tertiary)
                    .padding(.top, 1)
            }
            Spacer(minLength: 0)
            ArticleArtwork(style: imageStyle)
                .frame(width: 112, height: 112)
                .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 17)
    }
}

private struct ExploreGrid: View {
    var body: some View {
        HStack(spacing: 12) {
            ExploreCard(title: "A better way\nto work", color: Color(red: 0.70, green: 0.22, blue: 0.18), symbol: "briefcase.fill")
            ExploreCard(title: "The science\nof wonder", color: Color(red: 0.19, green: 0.42, blue: 0.35), symbol: "leaf.fill")
        }
        .padding(.horizontal, 20)
    }
}

private struct ExploreCard: View {
    let title: String
    let color: Color
    let symbol: String

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            color
            Image(systemName: symbol)
                .font(.system(size: 62, weight: .light))
                .foregroundStyle(.white.opacity(0.23))
                .offset(x: 76, y: -34)
            Text(title)
                .font(.system(size: 21, weight: .bold, design: .serif))
                .foregroundStyle(.white)
                .padding(16)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 145)
        .clipShape(RoundedRectangle(cornerRadius: 17, style: .continuous))
    }
}

private struct ArticleArtwork: View {
    let style: ArticleImageStyle

    var body: some View {
        ZStack {
            switch style {
            case .amber:
                LinearGradient(colors: [Color(red: 0.94, green: 0.68, blue: 0.27), Color(red: 0.75, green: 0.29, blue: 0.16)], startPoint: .top, endPoint: .bottom)
                Image(systemName: "sun.max.fill").font(.system(size: 48)).foregroundStyle(.white.opacity(0.75))
            case .blue:
                LinearGradient(colors: [Color(red: 0.45, green: 0.70, blue: 0.83), Color(red: 0.08, green: 0.24, blue: 0.47)], startPoint: .topLeading, endPoint: .bottomTrailing)
                Image(systemName: "building.2.fill").font(.system(size: 46)).foregroundStyle(.white.opacity(0.7))
            }
        }
    }
}

// MARK: - Supporting Types

private enum ArticleImageStyle { case amber, blue }
private enum NewsTab: Hashable { case today, newsPlus, following, saved }

private struct PlaceholderView: View {
    let title: String
    let subtitle: String
    let icon: String

    var body: some View {
        ContentUnavailableView(title, systemImage: icon, description: Text(subtitle))
    }
}

#Preview {
    ContentView()
}
