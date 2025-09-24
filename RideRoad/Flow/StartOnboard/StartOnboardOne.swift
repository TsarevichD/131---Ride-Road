//
//  StartOnboardOne.swift


import SwiftUI

struct StartOnboardOne: View {
    @State private var isAnimating = false
    @State private var showContent = false
    @State private var gradientOffset: CGFloat = 0
    @State private var floatingOffset: CGFloat = 0
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
                        colors.almostBlack,
                        colors.darkGray,
                        colors.graphite,
                        colors.grayBrown
                    ]),
                    startPoint: UnitPoint(x: gradientOffset, y: 0),
                    endPoint: UnitPoint(x: 1 - gradientOffset, y: 1)
                )
                .ignoresSafeArea()
                .onAppear {
                    withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                        gradientOffset = 0.3
                    }
                }
                
                ForEach(0..<8, id: \.self) { index in
                    FloatingElement(
                        index: index,
                        colors: colors,
                        screenSize: geometry.size
                    )
                }
                
                VStack(spacing: AdaptiveSize.spacing(30)) {
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        colors.goldenYellow.opacity(0.8),
                                        colors.goldenYellow.opacity(0.3),
                                        Color.clear
                                    ]),
                                    center: .center,
                                    startRadius: 20,
                                    endRadius: 80
                                )
                            )
                            .frame(width: AdaptiveSize.iconSize(120), height: AdaptiveSize.iconSize(120))
                            .scaleEffect(isAnimating ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isAnimating)
                        
                        Image(systemName: "car.2.fill")
                            .font(.system(size: AdaptiveSize.iconSize(50), weight: .bold))
                            .foregroundColor(colors.lightGray)
                            .rotationEffect(.degrees(isAnimating ? 360 : 0))
                            .animation(.linear(duration: 4).repeatForever(autoreverses: false), value: isAnimating)
                    }
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : -50)
                    .animation(.easeOut(duration: 1).delay(0.5), value: showContent)
                    
                    VStack(spacing: AdaptiveSize.spacing(16)) {
                        Text("Welcome to")
                            .adaptiveFont(.title2, size: 24)
                            .foregroundColor(colors.lightGray.opacity(0.9))
                            .multilineTextAlignment(.center)
                        
                        Text("RideRoad")
                            .adaptiveFont(.largeTitle, size: 36)
                            .fontWeight(.bold)
                            .foregroundColor(colors.goldenYellow)
                            .multilineTextAlignment(.center)
                            .shadow(color: colors.goldenYellow.opacity(0.3), radius: 10, x: 0, y: 0)
                    }
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 30)
                    .animation(.easeOut(duration: 1).delay(1.0), value: showContent)
                    
                    VStack(spacing: AdaptiveSize.spacing(12)) {
                        Text("Your personal journey into the world of car and motorcycle collections")
                            .adaptiveFont(.body, size: 18)
                            .foregroundColor(colors.lightGray.opacity(0.8))
                            .multilineTextAlignment(.center)
                        
                        Text("Build your garage, track values, and turn passion into achievement")
                            .adaptiveFont(.body, size: 16)
                            .foregroundColor(colors.lightGray.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    .adaptivePadding(.horizontal, 40)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 30)
                    .animation(.easeOut(duration: 1).delay(1.5), value: showContent)
                    
                    Spacer()
                    
                    Button(action: {
                        appState.currentScreen = .onboarding2
                    }) {
                        HStack(spacing: AdaptiveSize.spacing(12)) {
                            Text("Start Your Journey")
                                .adaptiveFont(.headline, size: 18)
                                .fontWeight(.semibold)
                            
                            Image(systemName: "arrow.right")
                                .font(.system(size: AdaptiveSize.iconSize(16), weight: .bold))
                        }
                        .foregroundColor(colors.almostBlack)
                        .adaptivePadding(.horizontal, 32)
                        .adaptivePadding(.vertical, 16)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    colors.goldenYellow,
                                    colors.goldenYellow.opacity(0.8)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .adaptiveCornerRadius(25)
                        .shadow(color: colors.goldenYellow.opacity(0.4), radius: 15, x: 0, y: 8)
                        .scaleEffect(isAnimating ? 1.05 : 1.0)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
                    }
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 50)
                    .animation(.easeOut(duration: 1).delay(2.0), value: showContent)
                    
                    Spacer()
                        .frame(height: AdaptiveSize.spacing(50))
                }
                .adaptivePadding(.horizontal, 24)
            }
        }
        .onAppear {
            isAnimating = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showContent = true
            }
        }
    }
}

struct FloatingElement: View {
    let index: Int
    let colors: (almostBlack: Color, grayBrown: Color, lightGray: Color, darkGray: Color, goldenYellow: Color, greenGray: Color, graphite: Color)
    let screenSize: CGSize
    
    @State private var offset: CGSize = .zero
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1.0
    
    private var elementColor: Color {
        let colors = [colors.greenGray, colors.goldenYellow, colors.lightGray, colors.graphite]
        return colors[index % colors.count]
    }
    
    private var elementSize: CGFloat {
        let sizes: [CGFloat] = [20, 30, 25, 35, 15, 40, 28, 22]
        return AdaptiveSize.iconSize(sizes[index % sizes.count])
    }
    
    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    gradient: Gradient(colors: [
                        elementColor.opacity(0.8),
                        elementColor.opacity(0.3),
                        Color.clear
                    ]),
                    center: .center,
                    startRadius: 0,
                    endRadius: elementSize / 2
                )
            )
            .frame(width: elementSize, height: elementSize)
            .offset(offset)
            .rotationEffect(.degrees(rotation))
            .scaleEffect(scale)
            .onAppear {
                let randomX = CGFloat.random(in: -screenSize.width/2...screenSize.width/2)
                let randomY = CGFloat.random(in: -screenSize.height/2...screenSize.height/2)
                offset = CGSize(width: randomX, height: randomY)
                
                withAnimation(
                    .easeInOut(duration: Double.random(in: 3...6))
                    .repeatForever(autoreverses: true)
                ) {
                    offset = CGSize(
                        width: randomX + CGFloat.random(in: -50...50),
                        height: randomY + CGFloat.random(in: -50...50)
                    )
                    rotation = Double.random(in: 0...360)
                    scale = CGFloat.random(in: 0.8...1.2)
                }
            }
    }
}




#Preview {
    StartOnboardOne()
}
