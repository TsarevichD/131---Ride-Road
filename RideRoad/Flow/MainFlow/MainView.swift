//
//  MainView.swift

import SwiftUI

struct MainView: View {
    @State private var isAnimating = false
    @State private var showContent = false
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
                
                ForEach(0..<8, id: \.self) { index in
                    FloatingIcon(
                        index: index,
                        colors: colors,
                        screenSize: geometry.size
                    )
                }
                VStack(spacing: AdaptiveSize.spacing(30)) {
                    HStack {
                        Button(action: {
                            appState.currentScreen = .profile
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(12))
                                    .fill(colors.greenGray)
                                    .frame(width: AdaptiveSize.iconSize(44), height: AdaptiveSize.iconSize(44))
                                
                                Image(systemName: "person.fill")
                                    .font(.system(size: AdaptiveSize.iconSize(20), weight: .semibold))
                                    .foregroundColor(colors.lightGray)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            appState.currentScreen = .info
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(12))
                                    .fill(colors.goldenYellow)
                                    .frame(width: AdaptiveSize.iconSize(44), height: AdaptiveSize.iconSize(44))
                                
                                Image(systemName: "info")
                                    .font(.system(size: AdaptiveSize.iconSize(20), weight: .semibold))
                                    .foregroundColor(colors.almostBlack)
                            }
                        }
                    }
                    .adaptivePadding(.horizontal, 20)
                    .adaptivePadding(.top, 48)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 100)
                    .animation(.easeOut(duration: 0.8).delay(0.2), value: showContent)
                    
                    Spacer()
                    
                    VStack(spacing: AdaptiveSize.spacing(16)) {
                        HStack(spacing: AdaptiveSize.spacing(8)) {
                            Image(systemName: "car.2.fill")
                                .font(.system(size: AdaptiveSize.iconSize(24), weight: .bold))
                                .foregroundColor(colors.goldenYellow)
                            
                            Text("Start Your Collection Journey")
                                .adaptiveFont(.largeTitle, size: 22)
                                .fontWeight(.bold)
                                .foregroundColor(colors.lightGray)
                                .multilineTextAlignment(.center)
                        }
                        
                    }
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 40)
                    .animation(.easeOut(duration: 1).delay(0.5), value: showContent)
                    
                    HStack(spacing: AdaptiveSize.spacing(40)) {
                        FeatureIcon(icon: "iphone", title: "Easy", colors: colors)
                        FeatureIcon(icon: "bolt.fill", title: "Fast", colors: colors)
                        FeatureIcon(icon: "target", title: "Smart", colors: colors)
                    }
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 30)
                    .animation(.easeOut(duration: 1).delay(0.8), value: showContent)
                    
                    Spacer()
                    
                    VStack(spacing: AdaptiveSize.spacing(16)) {
                        NavigationButton(
                            title: "Dream Cars",
                            subtitle: "Luxury & Sports Collection",
                            icon: "car.2.fill",
                            color: colors.greenGray,
                            colors: colors
                        ) {
                            appState.currentScreen = .dream
                        }
                        
                        NavigationButton(
                            title: "Speed Bikes",
                            subtitle: "Motorcycle Collection",
                            icon: "motorcycle",
                            color: colors.goldenYellow,
                            colors: colors
                        ) {
                            appState.currentScreen = .speed

                        }
                        
                        NavigationButton(
                            title: "Collection Stats",
                            subtitle: "Track Your Progress",
                            icon: "chart.line.uptrend.xyaxis",
                            color: colors.graphite,
                            colors: colors
                        ) {
                            appState.currentScreen = .analiz
                        }
                        
                        NavigationButton(
                            title: "Trophy Hall",
                            subtitle: "Unlock Achievements",
                            icon: "trophy.fill",
                            color: colors.grayBrown,
                            colors: colors
                        ) {
                            appState.currentScreen = .achiv
                        }
                    }
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 50)
                    .animation(.easeOut(duration: 1).delay(1.1), value: showContent)
                    
                    Spacer()
                        .frame(height: AdaptiveSize.spacing(30))
                }
                .adaptivePadding(.horizontal, 20)
            }
        }
        .onAppear {
            isAnimating = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                showContent = true
            }
        }
    }
}

// MARK: - Navigation Button
struct NavigationButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let colors: (almostBlack: Color, grayBrown: Color, lightGray: Color, darkGray: Color, goldenYellow: Color, greenGray: Color, graphite: Color)
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AdaptiveSize.spacing(16)) {
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [
                                    color.opacity(0.8),
                                    color.opacity(0.4),
                                    Color.clear
                                ]),
                                center: .center,
                                startRadius: 0,
                                endRadius: 25
                            )
                        )
                        .frame(width: AdaptiveSize.iconSize(50), height: AdaptiveSize.iconSize(50))
                    
                    Image(systemName: icon)
                        .font(.system(size: AdaptiveSize.iconSize(24), weight: .bold))
                        .foregroundColor(colors.lightGray)
                }
                
                VStack(alignment: .leading, spacing: AdaptiveSize.spacing(4)) {
                    Text(title)
                        .adaptiveFont(.headline, size: 18)
                        .fontWeight(.bold)
                        .foregroundColor(colors.lightGray)
                    
                    Text(subtitle)
                        .adaptiveFont(.body, size: 14)
                        .foregroundColor(colors.lightGray.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: AdaptiveSize.iconSize(16), weight: .semibold))
                    .foregroundColor(colors.lightGray.opacity(0.6))
            }
            .adaptivePadding(.horizontal, 20)
            .adaptivePadding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(16))
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                colors.darkGray.opacity(0.8),
                                colors.graphite.opacity(0.6)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(16))
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        color.opacity(0.4),
                                        color.opacity(0.2)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

// MARK: - Feature Icon
struct FeatureIcon: View {
    let icon: String
    let title: String
    let colors: (almostBlack: Color, grayBrown: Color, lightGray: Color, darkGray: Color, goldenYellow: Color, greenGray: Color, graphite: Color)
    
    var body: some View {
        VStack(spacing: AdaptiveSize.spacing(8)) {
            Image(systemName: icon)
                .font(.system(size: AdaptiveSize.iconSize(20), weight: .semibold))
                .foregroundColor(colors.lightGray.opacity(0.8))
            
            Text(title)
                .adaptiveFont(.caption, size: 12)
                .foregroundColor(colors.lightGray.opacity(0.6))
        }
    }
}

// MARK: - Floating Icon
struct FloatingIcon: View {
    let index: Int
    let colors: (almostBlack: Color, grayBrown: Color, lightGray: Color, darkGray: Color, goldenYellow: Color, greenGray: Color, graphite: Color)
    let screenSize: CGSize
    
    @State private var offset: CGSize = .zero
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 0.4
    
    private let icons = ["car.fill", "motorcycle", "trophy.fill", "chart.bar.fill", "star.fill", "heart.fill", "gear.fill", "bolt.fill"]
    
    private var elementColor: Color {
        let colors = [colors.greenGray, colors.goldenYellow, colors.lightGray, colors.graphite, colors.grayBrown]
        return colors[index % colors.count]
    }
    
    private var elementSize: CGFloat {
        let sizes: [CGFloat] = [30, 25, 35, 28, 32, 26, 29, 27]
        return AdaptiveSize.iconSize(sizes[index % sizes.count])
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            elementColor.opacity(0.6),
                            elementColor.opacity(0.3),
                            Color.clear
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: elementSize / 2
                    )
                )
                .frame(width: elementSize, height: elementSize)
            
            Image(systemName: icons[index % icons.count])
                .font(.system(size: AdaptiveSize.iconSize(16), weight: .semibold))
                .foregroundColor(colors.lightGray.opacity(0.8))
        }
        .offset(offset)
        .rotationEffect(.degrees(rotation))
        .scaleEffect(scale)
        .opacity(opacity)
        .onAppear {
            let randomX = CGFloat.random(in: -screenSize.width/2...screenSize.width/2)
            let randomY = CGFloat.random(in: -screenSize.height/2...screenSize.height/2)
            offset = CGSize(width: randomX, height: randomY)
            
            withAnimation(
                .easeInOut(duration: Double.random(in: 6...12))
                .repeatForever(autoreverses: true)
            ) {
                offset = CGSize(
                    width: randomX + CGFloat.random(in: -100...100),
                    height: randomY + CGFloat.random(in: -100...100)
                )
                rotation = Double.random(in: 0...360)
                scale = CGFloat.random(in: 0.8...1.2)
                opacity = Double.random(in: 0.2...0.6)
            }
        }
    }
}

#Preview {
    MainView()
}
