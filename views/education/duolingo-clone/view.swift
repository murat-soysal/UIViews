//
// iosviews.com
//

import SwiftUI

// MARK: - Model

struct Lesson: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let state: LessonState
}

enum LessonState {
    case completed
    case active
    case locked
}

// MARK: - Root

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Learn", systemImage: "house.fill") }
            HomeView()
                .tabItem { Label("Tasks", systemImage: "star.fill") }
            HomeView()
                .tabItem { Label("Profile", systemImage: "person.fill") }
        }
        .tint(.green)
    }
}

// MARK: - Home

struct HomeView: View {
    @State private var lessons = [
        Lesson(icon: "star.fill", title: "Greetings", state: .completed),
        Lesson(icon: "speaker.wave.2.fill", title: "Introductions", state: .completed),
        Lesson(icon: "star.fill", title: "Review", state: .completed),
        Lesson(icon: "book.fill", title: "Fruits", state: .active),
        Lesson(icon: "speaker.wave.2.fill", title: "Colors", state: .locked),
        Lesson(icon: "book.fill", title: "Numbers", state: .locked),
        Lesson(icon: "sparkles", title: "Daily Quest", state: .locked),
    ]

    private let nodeSize: CGFloat = 72
    private let rowHeight: CGFloat = 130
    private let zigzags: [CGFloat] = [0, -90, 0, 90, 0, -90, 0]

    var body: some View {
        ZStack {
            Color(red: 1.0, green: 0.985, blue: 0.90).ignoresSafeArea()

            VStack(spacing: 0) {
                header
                path
            }
        }
    }

    // MARK: Header

    private var header: some View {
        HStack {
            Text("DUO")
                .font(.system(size: 20, weight: .black, design: .rounded))
                .foregroundColor(.green)
            Spacer()
            Label("5", systemImage: "flame.fill")
                .foregroundColor(.orange)
            Label("120", systemImage: "diamond.fill")
                .foregroundColor(.blue)
            Image(systemName: "heart.fill")
                .foregroundColor(.red)
        }
        .font(.system(size: 16, weight: .bold))
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color.white)
        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
    }

    // MARK: Learning path

    private var path: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(Array(lessons.enumerated()), id: \.element.id) { index, lesson in
                    // keep every node centered, then shift it left/right
                    HStack {
                        Spacer()
                        node(lesson)
                            .offset(x: zigzags[index])
                        Spacer()
                    }
                    .frame(height: rowHeight)
                }
            }
            .background(GeometryReader { geo in
                pathLine(width: geo.size.width)
            })
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .scrollIndicators(.hidden)
    }

    // line connecting the node centers
    private func pathLine(width: CGFloat) -> some View {
        let centers = lessons.indices.map { index in
            CGPoint(
                x: width / 2 + zigzags[index],
                y: rowHeight / 2 + CGFloat(index) * rowHeight
            )
        }

        return Path { path in
            path.move(to: centers[0])
            for center in centers.dropFirst() {
                path.addLine(to: center)
            }
        }
        .stroke(
            Color.green.opacity(0.2),
            style: StrokeStyle(lineWidth: 6, lineCap: .round)
        )
    }

    // MARK: Node

    private func node(_ lesson: Lesson) -> some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(lesson.state == .locked ? Color.white : Color.green)
                    .frame(width: nodeSize, height: nodeSize)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 5)
                            .shadow(color: .black.opacity(0.1), radius: 2, y: 2)
                    )

                switch lesson.state {
                case .completed:
                    Image(systemName: "checkmark")
                        .font(.system(size: 28, weight: .heavy))
                        .foregroundColor(.white)
                case .active:
                    Image(systemName: lesson.icon)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.white)
                case .locked:
                    Image(systemName: "lock.fill")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color(red: 0.75, green: 0.75, blue: 0.72))
                }
            }

            Text(lesson.title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(lesson.state == .locked ? .gray : .black.opacity(0.7))
        }
    }
}

#Preview {
    ContentView()
}
