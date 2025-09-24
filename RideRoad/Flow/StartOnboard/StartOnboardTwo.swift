//
//  StartOnboardTwo.swift

import SwiftUI

struct StartOnboardTwo: View {
    @State private var isAnimating = false
    @State private var showContent = false
    @State private var gradientOffset: CGFloat = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var rotationAngle: Double = 0
    @EnvironmentObject var appState: AppState
    @StateObject private var rideMemory = RideUserMemory.shared

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
                    withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                        gradientOffset = 0.4
                    }
                }
                
                ForEach(0..<6, id: \.self) { index in
                    DecorativeElement(
                        index: index,
                        colors: colors,
                        screenSize: geometry.size
                    )
                }
                
                VStack(spacing: AdaptiveSize.spacing(40)) {
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        colors.goldenYellow.opacity(0.6),
                                        colors.greenGray.opacity(0.4),
                                        Color.clear
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 3
                            )
                            .frame(width: AdaptiveSize.iconSize(140), height: AdaptiveSize.iconSize(140))
                            .rotationEffect(.degrees(rotationAngle))
                            .animation(.linear(duration: 8).repeatForever(autoreverses: false), value: rotationAngle)
                        
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        colors.goldenYellow.opacity(0.3),
                                        colors.greenGray.opacity(0.2),
                                        Color.clear
                                    ]),
                                    center: .center,
                                    startRadius: 20,
                                    endRadius: 60
                                )
                            )
                            .frame(width: AdaptiveSize.iconSize(100), height: AdaptiveSize.iconSize(100))
                            .scaleEffect(pulseScale)
                            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: pulseScale)
                        
                        Image(systemName: "garage.fill")
                            .font(.system(size: AdaptiveSize.iconSize(45), weight: .bold))
                            .foregroundColor(colors.lightGray)
                            .scaleEffect(isAnimating ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
                    }
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : -60)
                    .animation(.easeOut(duration: 1.2).delay(0.3), value: showContent)
                    
                    VStack(spacing: AdaptiveSize.spacing(20)) {
                        Text("Build Your Dream Garage")
                            .adaptiveFont(.largeTitle, size: 24)
                            .fontWeight(.bold)
                            .foregroundColor(colors.goldenYellow)
                            .multilineTextAlignment(.center)
                            .shadow(color: colors.goldenYellow.opacity(0.4), radius: 8, x: 0, y: 0)
                        
                        Text("Create your personal profile and start collecting")
                            .adaptiveFont(.title3, size: 14)
                            .foregroundColor(colors.lightGray.opacity(0.9))
                            .multilineTextAlignment(.center)
                    }
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 40)
                    .animation(.easeOut(duration: 1).delay(0.8), value: showContent)
                    
                    VStack(spacing: AdaptiveSize.spacing(16)) {
                        FeatureRow(
                            icon: "person.circle.fill",
                            title: "Personal Profile",
                            description: "Add photos and customize your identity",
                            colors: colors
                        )
                        
                        FeatureRow(
                            icon: "car.2.fill",
                            title: "Vehicle Collections",
                            description: "Track cars and motorcycles with values",
                            colors: colors
                        )
                        
                        FeatureRow(
                            icon: "trophy.fill",
                            title: "Achievements",
                            description: "Unlock rewards for your passion",
                            colors: colors
                        )
                    }
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 50)
                    .animation(.easeOut(duration: 1).delay(1.3), value: showContent)
                    
                    Spacer()
                    
                    Button(action: {
                        rideMemory.completeOnboarding()
                        appState.currentScreen = .home
                    }) {
                        HStack(spacing: AdaptiveSize.spacing(12)) {
                            Text("Get Started")
                                .adaptiveFont(.headline, size: 18)
                                .fontWeight(.semibold)
                            
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.system(size: AdaptiveSize.iconSize(20), weight: .bold))
                        }
                        .foregroundColor(colors.almostBlack)
                        .adaptivePadding(.horizontal, 40)
                        .adaptivePadding(.vertical, 18)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    colors.goldenYellow,
                                    colors.greenGray.opacity(0.8)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .adaptiveCornerRadius(30)
                        .shadow(color: colors.goldenYellow.opacity(0.5), radius: 20, x: 0, y: 10)
                        .scaleEffect(isAnimating ? 1.05 : 1.0)
                        .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: isAnimating)
                    }
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 60)
                    .animation(.easeOut(duration: 1).delay(1.8), value: showContent)
                    
                    Spacer()
                        .frame(height: AdaptiveSize.spacing(50))
                }
                .adaptivePadding(.horizontal, 24)
            }
        }
        .onAppear {
            isAnimating = true
            rotationAngle = 360
            pulseScale = 1.2
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                showContent = true
            }
        }
    }
}

// MARK: - Feature Row
struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    let colors: (almostBlack: Color, grayBrown: Color, lightGray: Color, darkGray: Color, goldenYellow: Color, greenGray: Color, graphite: Color)
    
    var body: some View {
        HStack(spacing: AdaptiveSize.spacing(16)) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                colors.goldenYellow.opacity(0.3),
                                colors.greenGray.opacity(0.2),
                                Color.clear
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 25
                        )
                    )
                    .frame(width: AdaptiveSize.iconSize(50), height: AdaptiveSize.iconSize(50))
                
                Image(systemName: icon)
                    .font(.system(size: AdaptiveSize.iconSize(22), weight: .semibold))
                    .foregroundColor(colors.lightGray)
            }
            
            VStack(alignment: .leading, spacing: AdaptiveSize.spacing(4)) {
                Text(title)
                    .adaptiveFont(.headline, size: 16)
                    .fontWeight(.semibold)
                    .foregroundColor(colors.lightGray)
                
                Text(description)
                    .adaptiveFont(.body, size: 12)
                    .foregroundColor(colors.lightGray.opacity(0.7))
            }
            
            Spacer()
        }
        .adaptivePadding(.horizontal, 12)
        .adaptivePadding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(16))
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            colors.darkGray.opacity(0.6),
                            colors.graphite.opacity(0.4)
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
                                    colors.goldenYellow.opacity(0.3),
                                    colors.greenGray.opacity(0.2)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
    }
}

struct DecorativeElement: View {
    let index: Int
    let colors: (almostBlack: Color, grayBrown: Color, lightGray: Color, darkGray: Color, goldenYellow: Color, greenGray: Color, graphite: Color)
    let screenSize: CGSize
    
    @State private var offset: CGSize = .zero
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 0.6
    
    private var elementColor: Color {
        let colors = [colors.greenGray, colors.goldenYellow, colors.lightGray, colors.graphite, colors.grayBrown]
        return colors[index % colors.count]
    }
    
    private var elementSize: CGFloat {
        let sizes: [CGFloat] = [25, 35, 20, 40, 30, 28]
        return AdaptiveSize.iconSize(sizes[index % sizes.count])
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(8))
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        elementColor.opacity(0.6),
                        elementColor.opacity(0.3),
                        Color.clear
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: elementSize, height: elementSize)
            .offset(offset)
            .rotationEffect(.degrees(rotation))
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                let randomX = CGFloat.random(in: -screenSize.width/2...screenSize.width/2)
                let randomY = CGFloat.random(in: -screenSize.height/2...screenSize.height/2)
                offset = CGSize(width: randomX, height: randomY)
                
                withAnimation(
                    .easeInOut(duration: Double.random(in: 4...8))
                    .repeatForever(autoreverses: true)
                ) {
                    offset = CGSize(
                        width: randomX + CGFloat.random(in: -80...80),
                        height: randomY + CGFloat.random(in: -80...80)
                    )
                    rotation = Double.random(in: 0...360)
                    scale = CGFloat.random(in: 0.7...1.3)
                    opacity = Double.random(in: 0.3...0.8)
                }
            }
    }
}

#Preview {
    StartOnboardTwo()
}


