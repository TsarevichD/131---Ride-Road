//
//  InfoView.swift

import SwiftUI

struct InfoView: View {
    @State private var isAnimating = false
    @State private var gradientOffset: CGFloat = 0
    @EnvironmentObject var appState: AppState
    private let colors = (
        almostBlack: Color(hex: "#020303"),
        grayBrown: Color(hex: "#706c69"),
        lightGray: Color(hex: "#e5e6e3"),
        darkGray: Color(hex: "#3d3d3d"),
        goldenYellow: Color(hex: "#deb85b"),
        greenGray: Color(hex: "#89a483"),
        graphite: Color(hex: "#555454")
    )
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            colors.darkGray,
                            colors.graphite,
                            colors.grayBrown,
                            colors.almostBlack
                        ]),
                        startPoint: UnitPoint(x: gradientOffset, y: 0),
                        endPoint: UnitPoint(x: 1 - gradientOffset, y: 1)
                    )
                    .ignoresSafeArea()
                    .onAppear {
                        withAnimation(.easeInOut(duration: 5).repeatForever(autoreverses: true)) {
                            gradientOffset = 0.3
                        }
                    }
                    
                    ForEach(0..<6, id: \.self) { index in
                        FloatingInfoIcon(
                            index: index,
                            colors: colors,
                            screenSize: geometry.size
                        )
                    }
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: AdaptiveSize.spacing(30)) {
                            VStack(spacing: AdaptiveSize.spacing(20)) {
                                Text("✨🌟")
                                    .font(.system(size: AdaptiveSize.iconSize(60)))
                                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
                                
                                Text("About Ride Road")
                                    .adaptiveFont(.largeTitle, size: 32)
                                    .fontWeight(.bold)
                                    .foregroundColor(colors.lightGray)
                                    .shadow(color: colors.almostBlack.opacity(0.5), radius: 3, x: 0, y: 2)
                                
                                Text("Your Personal Vehicle Collection Journey")
                                    .adaptiveFont(.title3, size: 18)
                                    .fontWeight(.medium)
                                    .foregroundColor(colors.lightGray.opacity(0.9))
                                    .multilineTextAlignment(.center)
                                    .shadow(color: colors.almostBlack.opacity(0.3), radius: 1, x: 0, y: 1)
                            }
                            .adaptivePadding(.top, 20)
                            
                            VStack(spacing: AdaptiveSize.spacing(25)) {
                                InfoCardView(
                                    icon: "🎯",
                                    title: "Mission",
                                    description: "RideRoad is your personal gateway to the world of vehicle collections. Every model becomes a story, every collection reflects your passion, and every step is a new achievement.",
                                    colors: colors
                                )
                                
                                InfoCardView(
                                    icon: "👤",
                                    title: "Personal Profile",
                                    description: "Create your own profile, add photos and name to make your garage truly personal. Track your experience and vehicle preferences.",
                                    colors: colors
                                )
                                
                                InfoCardView(
                                    icon: "🚗",
                                    title: "Car Collections",
                                    description: "Build unique car collections, mark their estimated value and watch your virtual road fill with legends. Each addition opens new horizons.",
                                    colors: colors
                                )
                                
                                InfoCardView(
                                    icon: "🏍️",
                                    title: "Motorcycle Collections",
                                    description: "Create motorcycle collections with detailed information about each bike. Track condition, value, and build your dream garage.",
                                    colors: colors
                                )
                                
                                InfoCardView(
                                    icon: "🏆",
                                    title: "Achievement System",
                                    description: "The achievement system turns your passion into a game where rewards await the most dedicated collectors. Unlock milestones and show your progress.",
                                    colors: colors
                                )
                                
                                InfoCardView(
                                    icon: "📊",
                                    title: "Statistics & Analytics",
                                    description: "Statistics help you see how your garage grows and how rich your collections become. Track your progress with detailed analytics.",
                                    colors: colors
                                )
                                
                                InfoCardView(
                                    icon: "💡",
                                    title: "Philosophy",
                                    description: "RideRoad is created for those who love the road, appreciate style and dream of collecting the best in one place. Your journey starts here.",
                                    colors: colors
                                )
                            }
                            .adaptivePadding(.horizontal, 20)
                            
                            VStack(spacing: AdaptiveSize.spacing(10)) {
                                
                                Text("Made with love for vehicle enthusiasts")
                                    .adaptiveFont(.caption2, size: 12)
                                    .fontWeight(.regular)
                                    .foregroundColor(colors.lightGray.opacity(0.6))
                            }
                            .adaptivePadding(.bottom, 30)
                        }
                    }
                }
            }
            .navigationTitle("About RideRoad")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        appState.currentScreen = .home
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "house.fill")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Home")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(colors.lightGray)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(colors.goldenYellow.opacity(0.2))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(colors.goldenYellow.opacity(0.6), lineWidth: 1)
                                )
                        )
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            isAnimating = true
        }
    }
}

struct InfoCardView: View {
    let icon: String
    let title: String
    let description: String
    let colors: (almostBlack: Color, grayBrown: Color, lightGray: Color, darkGray: Color, goldenYellow: Color, greenGray: Color, graphite: Color)
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: AdaptiveSize.spacing(15)) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                colors.goldenYellow.opacity(0.8),
                                colors.greenGray.opacity(0.6)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: AdaptiveSize.iconSize(60), height: AdaptiveSize.iconSize(60))
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        colors.goldenYellow,
                                        colors.greenGray
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                ),
                                lineWidth: 2
                            )
                    )
                
                Text(icon)
                    .font(.system(size: AdaptiveSize.iconSize(30)))
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
            }
            
            VStack(alignment: .leading, spacing: AdaptiveSize.spacing(8)) {
                Text(title)
                    .adaptiveFont(.title3, size: 20)
                    .fontWeight(.bold)
                    .foregroundColor(colors.lightGray)
                
                Text(description)
                    .adaptiveFont(.body, size: 16)
                    .foregroundColor(colors.lightGray.opacity(0.9))
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
        .adaptivePadding(.all, 20)
        .background(
            RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(15))
                .fill(colors.lightGray.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(15))
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    colors.goldenYellow.opacity(0.4),
                                    colors.greenGray.opacity(0.3)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .shadow(color: colors.almostBlack.opacity(0.1), radius: 8, x: 0, y: 4)
        .scaleEffect(isAnimating ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: isAnimating)
        .onAppear {
            isAnimating = true
        }
    }
}

struct FloatingInfoIcon: View {
    let index: Int
    let colors: (almostBlack: Color, grayBrown: Color, lightGray: Color, darkGray: Color, goldenYellow: Color, greenGray: Color, graphite: Color)
    let screenSize: CGSize
    @State private var offset: CGSize = .zero
    @State private var rotation: Double = 0
    @State private var opacity: Double = 0.3
    
    private let icons = ["✨", "🌟", "💫", "⭐", "🔮", "💎"]
    
    var body: some View {
        Text(icons[index % icons.count])
            .font(.system(size: AdaptiveSize.iconSize(30)))
            .opacity(opacity)
            .offset(offset)
            .rotationEffect(.degrees(rotation))
            .onAppear {
                withAnimation(
                    .easeInOut(duration: Double.random(in: 3...6))
                    .repeatForever(autoreverses: true)
                ) {
                    offset = CGSize(
                        width: CGFloat.random(in: -screenSize.width/2...screenSize.width/2),
                        height: CGFloat.random(in: -screenSize.height/2...screenSize.height/2)
                    )
                }
                
                withAnimation(
                    .linear(duration: Double.random(in: 8...12))
                    .repeatForever(autoreverses: false)
                ) {
                    rotation = 360
                }
                
                withAnimation(
                    .easeInOut(duration: Double.random(in: 2...4))
                    .repeatForever(autoreverses: true)
                ) {
                    opacity = Double.random(in: 0.2...0.5)
                }
            }
    }
}

#Preview {
    InfoView()
}
