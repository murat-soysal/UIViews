//
// iosviews.com
//

import SwiftUI

struct ContentView: View {

    @State private var showOnboarding = true

    var body: some View {
        if showOnboarding {
            OnboardingView(showOnboarding: $showOnboarding)
        } else {
            HomeView()
        }
    }
}

// MARK: - Home

struct HomeView: View {
    var body: some View {
        NavigationStack {
            Text("Home Screen")
                .font(.largeTitle.bold())
                .navigationTitle("Home")
        }
    }
}

// MARK: - Onboarding

struct OnboardingView: View {

    @Binding var showOnboarding: Bool
    @State private var page = 0

    let pages: [(icon: String,
                 title: String,
                 subtitle: String,
                 colors: [Color])] = [

        (
            "person.2.fill",
            "Welcome",
            "Connect with friends around the world.",
            [.blue, .purple]
        ),

        (
            "camera.fill",
            "Share Moments",
            "Post photos and videos instantly.",
            [.pink, .orange]
        ),

        (
            "heart.fill",
            "Discover",
            "Find creators and content you'll love.",
            [.green, .mint]
        )
    ]

    var body: some View {

        ZStack {

            LinearGradient(
                colors: pages[page].colors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack {

                HStack {

                    Spacer()

                    if page != pages.count - 1 {

                        Button("Skip") {
                            showOnboarding = false
                        }
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                    }
                }
                .padding()

                Spacer()

                TabView(selection: $page) {

                    ForEach(0..<pages.count, id: \.self) { index in

                        VStack(spacing: 30) {

                            ZStack {

                                Circle()
                                    .fill(.white.opacity(0.15))
                                    .frame(width: 220, height: 220)

                                Circle()
                                    .fill(.white.opacity(0.08))
                                    .frame(width: 270, height: 270)

                                Image(systemName: pages[index].icon)
                                    .font(.system(size: 90))
                                    .foregroundStyle(.white)
                            }

                            VStack(spacing: 12) {

                                Text(pages[index].title)
                                    .font(.system(size: 36, weight: .bold))
                                    .foregroundStyle(.white)

                                Text(pages[index].subtitle)
                                    .font(.title3)
                                    .foregroundStyle(.white.opacity(0.85))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                            }
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))

                Spacer()

                Button {

                    if page == pages.count - 1 {
                        showOnboarding = false
                    } else {
                        withAnimation(.easeInOut) {
                            page += 1
                        }
                    }

                } label: {

                    Text(page == pages.count - 1 ? "Get Started" : "Next")

                        .font(.headline)

                        .foregroundStyle(.black)

                        .frame(maxWidth: .infinity)

                        .padding()

                        .background(.white)

                        .clipShape(RoundedRectangle(cornerRadius: 18))
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
    }
}
#Preview {
    ContentView()
}
