//
// iosviews.com
//

import SwiftUI

// MARK: - Models

struct Story: Identifiable {
    let id = UUID()
    let username: String
    let avatar: String
    let isViewed: Bool
}

struct Post: Identifiable {
    let id = UUID()
    let username: String
    let avatar: String
    let location: String?
    let imageName: String
    let caption: String
    let likes: String
    let comments: String
    let time: String
}

// MARK: - Mock Data

enum MockData {
    static let stories: [Story] = [
        Story(username: "you", avatar: "person.crop.circle.fill", isViewed: false),
        Story(username: "john.carter", avatar: "person.crop.circle.fill", isViewed: true),
        Story(username: "linda.moore", avatar: "person.crop.circle.fill", isViewed: true),
        Story(username: "ryan.kelly", avatar: "person.crop.circle.fill", isViewed: true),
        Story(username: "emma.turner", avatar: "person.crop.circle.fill", isViewed: true),
        Story(username: "noah.harris", avatar: "person.crop.circle.fill", isViewed: true),
        Story(username: "mia.clark", avatar: "person.crop.circle.fill", isViewed: true)
    ]

    static let posts: [Post] = [
        Post(
            username: "james.smith",
            avatar: "person.crop.circle.fill",
            location: "New York, NY",
            imageName: "photo.fill",
            caption: "A beautiful sunset",
            likes: "124 likes",
            comments: "12 comments",
            time: "2 hours ago"
        ),
        Post(
            username: "emily.wilson",
            avatar: "person.crop.circle",
            location: nil,
            imageName: "photo",
            caption: "Weekend getaway",
            likes: "89 likes",
            comments: "5 comments",
            time: "4 hours ago"
        )
    ]
}

// MARK: - Root View

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                FeedView()
            }
            Tab("Search", systemImage: "magnifyingglass") {
                PlaceholderView(title: "Search")
            }
            Tab("Reels", systemImage: "play.rectangle.on.rectangle") {
                PlaceholderView(title: "Reels")
            }
            Tab("Profile", systemImage: "person.crop.circle") {
                PlaceholderView(title: "Profile")
            }
        }
    }
}

// MARK: - Feed

struct FeedView: View {
    var body: some View {
        VStack(spacing: 0) {
            feedHeader
            Divider()

            ScrollView {
                VStack(spacing: 8) {
                    storyRow
                        .padding(.vertical, 4)

                    Divider()

                    ForEach(MockData.posts) { post in
                        PostCardView(post: post)
                        Divider()
                    }
                }
            }
        }
    }

    private var feedHeader: some View {
        HStack {
            Text("Instagram")
                .font(.custom("HelveticaNeue-Bold", size: 23))
                .kerning(-0.8)

            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(.background)
    }

    private var storyRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(MockData.stories) { story in
                    StoryCellView(story: story)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
}

// MARK: - Placeholder

struct PlaceholderView: View {
    let title: String

    var body: some View {
        ContentUnavailableView(title, systemImage: "sparkles")
    }
}

// MARK: - Story Cell

struct StoryCellView: View {
    let story: Story

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                if story.isViewed {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                        .frame(width: 64, height: 64)
                } else {
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [.orange, .pink, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2.5
                        )
                        .frame(width: 64, height: 64)
                }

                Image(systemName: story.avatar)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 56, height: 56)
                    .clipShape(Circle())
                    .foregroundStyle(.gray)
            }

            Text(story.username)
                .font(.caption)
                .foregroundStyle(.primary)
        }
    }
}

// MARK: - Post Card

struct PostCardView: View {
    let post: Post
    @State private var isLiked = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            postHeader
            postImage
            actionBar
            likesLabel
            captionLabel
            commentsLabel
            timeLabel
        }
    }

    private var postHeader: some View {
        HStack {
            Image(systemName: post.avatar)
                .resizable()
                .scaledToFit()
                .frame(width: 36, height: 36)
                .clipShape(Circle())
                .foregroundStyle(.gray)

            VStack(alignment: .leading, spacing: 2) {
                Text(post.username)
                    .font(.subheadline).bold()

                if let location = post.location {
                    Text(location)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            Image(systemName: "ellipsis")
                .font(.system(size: 16))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }

    private var postImage: some View {
        ZStack {
            Color(.secondarySystemBackground)

            VStack(spacing: 8) {
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.system(size: 44))
                    .foregroundStyle(.tertiary)

                Text("No photo")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(height: 320)
        .frame(maxWidth: .infinity)
        .clipped()
    }

    private var actionBar: some View {
        HStack(spacing: 16) {
            Button {
                isLiked.toggle()
            } label: {
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .foregroundStyle(isLiked ? .red : .primary)
            }

            Image(systemName: "bubble.right")
            Image(systemName: "paperplane")
            Spacer()
            Image(systemName: "bookmark")
        }
        .font(.system(size: 22))
        .padding(.horizontal)
        .padding(.vertical, 8)
    }

    private var likesLabel: some View {
        Text(post.likes)
            .font(.subheadline).bold()
            .padding(.horizontal)
    }

    private var captionLabel: some View {
        HStack(spacing: 4) {
            Text(post.username).bold()
            Text(post.caption)
        }
        .font(.subheadline)
        .padding(.horizontal)
        .padding(.top, 2)
    }

    private var commentsLabel: some View {
        Text("View all \(post.comments)")
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .padding(.horizontal)
            .padding(.top, 2)
    }

    private var timeLabel: some View {
        Text(post.time)
            .font(.caption2)
            .foregroundStyle(.secondary)
            .padding(.horizontal)
            .padding(.top, 2)
            .padding(.bottom, 8)
    }
}

#Preview {
    ContentView()
}
