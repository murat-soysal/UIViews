//
// iosviews.com
//

import SwiftUI

// MARK: - Models

struct SocialUser: Identifiable {
    let id = UUID()
    let username: String
    let displayName: String
    let avatar: String
    let isVerified: Bool
}

struct SocialPost: Identifiable {
    let id = UUID()
    let user: SocialUser
    let imageName: String
    let caption: String
    let likes: Int
    let comments: Int
    let location: String?
}

struct Story: Identifiable {
    let id = UUID()
    let user: SocialUser
    let isSeen: Bool
}

// MARK: - Sample Data

let currentUser = SocialUser(
    username: "alex",
    displayName: "Alex",
    avatar: "person.crop.circle.fill",
    isVerified: true
)

let users: [SocialUser] = [

    SocialUser(
        username: "sophia",
        displayName: "Sophia",
        avatar: "person.crop.circle.fill",
        isVerified: true
    ),

    SocialUser(
        username: "michael",
        displayName: "Michael",
        avatar: "person.crop.circle.fill",
        isVerified: false
    ),

    SocialUser(
        username: "emma",
        displayName: "Emma",
        avatar: "person.crop.circle.fill",
        isVerified: false
    ),

    SocialUser(
        username: "oliver",
        displayName: "Oliver",
        avatar: "person.crop.circle.fill",
        isVerified: true
    ),

    SocialUser(
        username: "ava",
        displayName: "Ava",
        avatar: "person.crop.circle.fill",
        isVerified: false
    )
]

let stories: [Story] = [
    Story(user: currentUser, isSeen: false),
    Story(user: users[0], isSeen: false),
    Story(user: users[1], isSeen: false),
    Story(user: users[2], isSeen: true),
    Story(user: users[3], isSeen: false),
    Story(user: users[4], isSeen: true)
]

let posts: [SocialPost] = [

    SocialPost(
        user: users[0],
        imageName: "photo",
        caption: "Beautiful day and good vibes ✨",
        likes: 1842,
        comments: 74,
        location: "New York, USA"
    ),

    SocialPost(
        user: users[1],
        imageName: "photo.fill",
        caption: "Exploring somewhere new today.",
        likes: 923,
        comments: 38,
        location: "London, UK"
    ),

    SocialPost(
        user: users[2],
        imageName: "mountain.2.fill",
        caption: "Weekend escape 🏔️",
        likes: 3210,
        comments: 126,
        location: "Swiss Alps"
    )
]

// MARK: - Main View

struct ContentView: View {

    var body: some View {

        TabView {

            HomeView()
                .tabItem {
                    Label(
                        "Home",
                        systemImage: "house.fill"
                    )
                }

            SearchView()
                .tabItem {
                    Label(
                        "Search",
                        systemImage: "magnifyingglass"
                    )
                }

            CreateView()
                .tabItem {
                    Label(
                        "Create",
                        systemImage: "plus.app"
                    )
                }

            ReelsView()
                .tabItem {
                    Label(
                        "Reels",
                        systemImage: "play.rectangle.fill"
                    )
                }

            ProfileView()
                .tabItem {
                    Label(
                        "Profile",
                        systemImage: "person.circle.fill"
                    )
                }
        }
        .tint(.primary)
    }
}

// MARK: - Home

struct HomeView: View {

    var body: some View {

        NavigationStack {

            ScrollView(
                .vertical,
                showsIndicators: false
            ) {

                VStack(spacing: 0) {

                    StoriesView()

                    Divider()

                    ForEach(posts) { post in

                        PostView(post: post)

                        Divider()
                    }
                }
            }
            .navigationTitle("Social")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {


                ToolbarItemGroup(
                    placement: .topBarTrailing
                ) {

                    Button {
                    } label: {

                        Image(
                            systemName: "heart"
                        )
                        .font(.title3)
                    }

                    Button {
                    } label: {

                        Image(
                            systemName: "paperplane"
                        )
                        .font(.title3)
                    }
                }
            }
        }
    }
}

// MARK: - Stories

struct StoriesView: View {

    var body: some View {

        ScrollView(
            .horizontal,
            showsIndicators: false
        ) {

            HStack(
                spacing: 17
            ) {

                ForEach(stories) { story in

                    StoryView(
                        story: story
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
}

// MARK: - Story

struct StoryView: View {

    let story: Story

    var body: some View {

        VStack(spacing: 6) {

            ZStack {

                Circle()
                    .stroke(
                        story.isSeen
                        ? Color.gray.opacity(0.3)
                        : Color.blue,
                        lineWidth: 3
                    )
                    .frame(
                        width: 68,
                        height: 68
                    )

                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                .blue,
                                .purple,
                                .pink
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(
                        width: 62,
                        height: 62
                    )

                Image(
                    systemName: story.user.avatar
                )
                .font(.system(size: 35))
                .foregroundStyle(.white)

                if story.user.username == currentUser.username {

                    Circle()
                        .fill(.blue)
                        .frame(
                            width: 22,
                            height: 22
                        )
                        .overlay {

                            Image(
                                systemName: "plus"
                            )
                            .font(
                                .system(
                                    size: 11,
                                    weight: .bold
                                )
                            )
                            .foregroundStyle(.white)
                        }
                        .overlay {

                            Circle()
                                .stroke(
                                    .white,
                                    lineWidth: 2
                                )
                        }
                        .offset(
                            x: 24,
                            y: 24
                        )
                }
            }

            Text(
                story.user.username
            )
            .font(.caption)
            .lineLimit(1)
        }
        .frame(width: 72)
    }
}

// MARK: - Post

struct PostView: View {

    let post: SocialPost

    @State private var isLiked = false
    @State private var isSaved = false
    @State private var showComments = false

    var body: some View {

        VStack(
            alignment: .leading,
            spacing: 0
        ) {

            postHeader

            postImage

            actionBar

            postInformation
        }
    }

    // MARK: Header

    private var postHeader: some View {

        HStack(spacing: 11) {

            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            .blue,
                            .purple,
                            .pink
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(
                    width: 40,
                    height: 40
                )
                .overlay {

                    Image(
                        systemName: post.user.avatar
                    )
                    .font(.title3)
                    .foregroundStyle(.white)
                }

            VStack(
                alignment: .leading,
                spacing: 2
            ) {

                HStack(spacing: 3) {

                    Text(post.user.username)
                        .fontWeight(.semibold)

                    if post.user.isVerified {

                        Image(
                            systemName: "checkmark.seal.fill"
                        )
                        .font(.caption)
                        .foregroundStyle(.blue)
                    }
                }

                if let location = post.location {

                    Text(location)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            Button {
            } label: {

                Image(
                    systemName: "ellipsis"
                )
                .foregroundStyle(.primary)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
    }

    // MARK: Image

    private var postImage: some View {

        ZStack {

            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            post.user.username == "sophia"
                            ? .orange
                            : post.user.username == "michael"
                            ? .blue
                            : .green,

                            .black.opacity(0.7)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            VStack(spacing: 15) {

                Image(
                    systemName: post.imageName
                )
                .font(
                    .system(
                        size: 90,
                        weight: .medium
                    )
                )
                .foregroundStyle(.white.opacity(0.9))

                Text(
                    post.user.username.capitalized
                )
                .font(
                    .system(
                        size: 28,
                        weight: .bold
                    )
                )
                .foregroundStyle(.white)
            }
        }
        .aspectRatio(
            1,
            contentMode: .fit
        )
        .clipped()
    }

    // MARK: Actions

    private var actionBar: some View {

        HStack(spacing: 18) {

            Button {

                withAnimation(
                    .spring(
                        response: 0.25,
                        dampingFraction: 0.6
                    )
                ) {
                    isLiked.toggle()
                }

            } label: {

                Image(
                    systemName: isLiked
                    ? "heart.fill"
                    : "heart"
                )
                .font(.system(size: 25))
                .foregroundStyle(
                    isLiked
                    ? .red
                    : .primary
                )
            }

            Button {

                showComments = true

            } label: {

                Image(
                    systemName: "message"
                )
                .font(.system(size: 24))
            }

            Button {
            } label: {

                Image(
                    systemName: "paperplane"
                )
                .font(.system(size: 24))
            }

            Spacer()

            Button {

                isSaved.toggle()

            } label: {

                Image(
                    systemName: isSaved
                    ? "bookmark.fill"
                    : "bookmark"
                )
                .font(.system(size: 24))
            }
        }
        .foregroundStyle(.primary)
        .padding(
            .horizontal,
            14
        )
        .padding(
            .top,
            12
        )
    }

    // MARK: Information

    private var postInformation: some View {

        VStack(
            alignment: .leading,
            spacing: 7
        ) {

            Text(
                "\(post.likes + (isLiked ? 1 : 0)) likes"
            )
            .fontWeight(.semibold)

            HStack(
                alignment: .top,
                spacing: 5
            ) {

                Text(post.user.username)
                    .fontWeight(.semibold)

                Text(post.caption)
            }

            Button {

                showComments = true

            } label: {

                Text(
                    "View all \(post.comments) comments"
                )
                .foregroundStyle(.secondary)
            }

            Text("2 hours ago")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .font(.subheadline)
        .padding(
            .horizontal,
            14
        )
        .padding(
            .vertical,
            8
        )
        .sheet(
            isPresented: $showComments
        ) {

            CommentsView(
                post: post
            )
        }
    }
}

// MARK: - Comments

struct CommentsView: View {

    let post: SocialPost

    @Environment(
        \.dismiss
    )
    private var dismiss

    @State private var comment = ""

    var body: some View {

        NavigationStack {

            VStack {

                ScrollView {

                    VStack(
                        alignment: .leading,
                        spacing: 20
                    ) {

                        CommentRow(
                            username: post.user.username,
                            text: "Amazing photo!"
                        )

                        CommentRow(
                            username: "alex",
                            text: "Love this!"
                        )

                        CommentRow(
                            username: "james",
                            text: "This looks incredible."
                        )
                    }
                    .padding()
                }

                HStack {

                    TextField(
                        "Add a comment...",
                        text: $comment
                    )
                    .textFieldStyle(.roundedBorder)

                    Button("Post") {
                        comment = ""
                    }
                    .fontWeight(.semibold)
                }
                .padding()
            }
            .navigationTitle("Comments")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                ToolbarItem(
                    placement: .topBarTrailing
                ) {

                    Button {
                        dismiss()
                    } label: {

                        Image(
                            systemName: "xmark"
                        )
                    }
                }
            }
        }
    }
}

// MARK: - Comment Row

struct CommentRow: View {

    let username: String
    let text: String

    var body: some View {

        HStack(
            alignment: .top,
            spacing: 10
        ) {

            Circle()
                .fill(.gray.opacity(0.2))
                .frame(
                    width: 38,
                    height: 38
                )
                .overlay {

                    Image(
                        systemName: "person.fill"
                    )
                    .foregroundStyle(.secondary)
                }

            VStack(
                alignment: .leading,
                spacing: 3
            ) {

                Text(username)
                    .fontWeight(.semibold)

                Text(text)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
    }
}

// MARK: - Search

struct SearchView: View {

    @State private var searchText = ""

    var filteredUsers: [SocialUser] {

        if searchText.isEmpty {
            return users
        }

        return users.filter {

            $0.username
                .localizedCaseInsensitiveContains(
                    searchText
                )
        }
    }

    var body: some View {

        NavigationStack {

            List {

                ForEach(
                    filteredUsers
                ) { user in

                    HStack(spacing: 12) {

                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        .blue,
                                        .purple
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(
                                width: 50,
                                height: 50
                            )
                            .overlay {

                                Image(
                                    systemName: user.avatar
                                )
                                .foregroundStyle(.white)
                            }

                        VStack(
                            alignment: .leading
                        ) {

                            HStack(spacing: 3) {

                                Text(
                                    user.username
                                )
                                .fontWeight(.semibold)

                                if user.isVerified {

                                    Image(
                                        systemName:
                                            "checkmark.seal.fill"
                                    )
                                    .font(.caption)
                                    .foregroundStyle(.blue)
                                }
                            }

                            Text(
                                user.displayName
                            )
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Search")
            .searchable(
                text: $searchText,
                prompt: "Search people"
            )
        }
    }
}

// MARK: - Create

struct CreateView: View {

    var body: some View {

        NavigationStack {

            VStack(spacing: 25) {

                Image(
                    systemName: "plus.square.dashed"
                )
                .font(.system(size: 70))
                .foregroundStyle(.secondary)

                Text("Create a Post")
                    .font(.title2)
                    .fontWeight(.bold)

                Text(
                    "Share photos, videos and moments with your followers."
                )
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

                Button("Choose from Library") {
                }
                .buttonStyle(
                    .borderedProminent
                )
            }
            .padding(30)
            .navigationTitle("Create")
        }
    }
}

// MARK: - Reels

struct ReelsView: View {

    var body: some View {

        ZStack {

            Color.black
                .ignoresSafeArea()

            VStack {

                Spacer()

                Image(
                    systemName: "play.rectangle.fill"
                )
                .font(
                    .system(
                        size: 70
                    )
                )
                .foregroundStyle(.white)

                Text("Reels")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                Text(
                    "Short videos will appear here."
                )
                .foregroundStyle(
                    .white.opacity(0.7)
                )

                Spacer()
            }
        }
    }
}

// MARK: - Profile

struct ProfileView: View {

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(
                    alignment: .leading,
                    spacing: 20
                ) {

                    HStack {

                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        .blue,
                                        .purple,
                                        .pink
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(
                                width: 90,
                                height: 90
                            )
                            .overlay {

                                Image(
                                    systemName:
                                        currentUser.avatar
                                )
                                .font(
                                    .system(
                                        size: 48
                                    )
                                )
                                .foregroundStyle(.white)
                            }

                        Spacer()

                        ProfileStat(
                            number: "24",
                            label: "Posts"
                        )

                        Spacer()

                        ProfileStat(
                            number: "1.8K",
                            label: "Followers"
                        )

                        Spacer()

                        ProfileStat(
                            number: "421",
                            label: "Following"
                        )
                    }

                    VStack(
                        alignment: .leading,
                        spacing: 4
                    ) {

                        HStack {

                            Text(
                                currentUser.displayName
                            )
                            .fontWeight(.bold)

                            if currentUser.isVerified {

                                Image(
                                    systemName:
                                        "checkmark.seal.fill"
                                )
                                .foregroundStyle(.blue)
                            }
                        }

                        Text(
                            "Creator • Photographer"
                        )
                        .foregroundStyle(.secondary)
                    }

                    Button("Edit Profile") {
                    }
                    .buttonStyle(
                        .bordered
                    )
                    .frame(
                        maxWidth: .infinity
                    )

                    Divider()

                    LazyVGrid(
                        columns: [
                            GridItem(
                                .flexible(),
                                spacing: 2
                            ),
                            GridItem(
                                .flexible(),
                                spacing: 2
                            ),
                            GridItem(
                                .flexible(),
                                spacing: 2
                            )
                        ],
                        spacing: 2
                    ) {

                        ForEach(
                            0..<12,
                            id: \.self
                        ) { index in

                            Rectangle()
                                .fill(
                                    [
                                        Color.blue,
                                        Color.purple,
                                        Color.orange,
                                        Color.green,
                                        Color.pink,
                                        Color.indigo
                                    ][
                                        index % 6
                                    ]
                                )
                                .aspectRatio(
                                    1,
                                    contentMode: .fill
                                )
                                .overlay {

                                    Image(
                                        systemName:
                                            "photo.fill"
                                    )
                                    .font(.title)
                                    .foregroundStyle(
                                        .white.opacity(0.7)
                                    )
                                }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(
                "@\(currentUser.username)"
            )
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Profile Stat

struct ProfileStat: View {

    let number: String
    let label: String

    var body: some View {

        VStack(spacing: 3) {

            Text(number)
                .font(
                    .system(
                        size: 20,
                        weight: .bold
                    )
                )

            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
