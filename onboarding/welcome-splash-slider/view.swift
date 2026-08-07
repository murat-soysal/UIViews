//
// iosviews.com
//

import SwiftUI

struct Slide {
    let icon: String
    let title: String
    let description: String
    let gradient: LinearGradient
    let shadowColor: Color
    let background: Color
}

struct ContentView: View {
    @State private var page = 0

    private let slides = [
        Slide(
            icon: "sparkles",
            title: "Welcome to My App",
            description: "The simplest way to get started with something great.",
            gradient: LinearGradient(colors: [.blue, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing),
            shadowColor: .blue,
            background: Color(red: 0.93, green: 0.96, blue: 1.0)
        ),
        Slide(
            icon: "bolt.fill",
            title: "Fast and Easy",
            description: "Everything you need, right at your fingertips.",
            gradient: LinearGradient(colors: [.orange, .pink], startPoint: .topLeading, endPoint: .bottomTrailing),
            shadowColor: .pink,
            background: Color(red: 1.0, green: 0.95, blue: 0.95)
        ),
        Slide(
            icon: "hand.thumbsup.fill",
            title: "Let's Go!",
            description: "You're all set. Enjoy the experience.",
            gradient: LinearGradient(colors: [.purple, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing),
            shadowColor: .indigo,
            background: Color(red: 0.95, green: 0.93, blue: 1.0)
        ),
    ]

    var body: some View {
        ZStack {
            slides[page].background.ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    if page < slides.count - 1 {
                        Button("Skip") {
                            withAnimation {
                                page = slides.count - 1
                            }
                        }
                        .foregroundColor(.secondary)
                        .font(.system(size: 16, weight: .medium))
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                Spacer()

                TabView(selection: $page) {
                    ForEach(Array(slides.enumerated()), id: \.offset) { index, slide in
                        slideView(slide)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))

                Button {
                    if page < slides.count - 1 {
                        withAnimation {
                            page += 1
                        }
                    }
                } label: {
                    Text(page < slides.count - 1 ? "Next" : "Get Started")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing),
                            in: Capsule()
                        )
                        .shadow(color: .purple.opacity(0.4), radius: 8, y: 4)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 28)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: page)
    }

    private func slideView(_ slide: Slide) -> some View {
        VStack(spacing: 24) {
            ZStack {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(slide.gradient)
                    .frame(width: 140, height: 140)
                    .shadow(color: slide.shadowColor.opacity(0.4), radius: 16, y: 8)

                Image(systemName: slide.icon)
                    .font(.system(size: 56))
                    .foregroundColor(.white)
            }

            VStack(spacing: 10) {
                Text(slide.title)
                    .font(.system(size: 30, weight: .bold))
                    .multilineTextAlignment(.center)

                Text(slide.description)
                    .font(.system(size: 17))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 36)
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    ContentView()
}
