//
//  AchivView.swift

import SwiftUI

struct AchivView: View {
    @StateObject private var rideMemory = RideUserMemory.shared
    @State private var isAnimating = false
    @State private var showingShareSheet = false
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
    
    private var achievements: [Achievement] {
        [
            Achievement(
                id: "first_car",
                title: "First Ride",
                description: "Add your first car to any collection",
                icon: "🚗",
                isUnlocked: rideMemory.getTotalCarCount() > 0,
                progress: min(rideMemory.getTotalCarCount(), 1),
                maxProgress: 1,
                rarity: .common
            ),
            Achievement(
                id: "first_bike",
                title: "Speed Demon",
                description: "Add your first motorcycle to any collection",
                icon: "🏍️",
                isUnlocked: rideMemory.getTotalMotorcycleCount() > 0,
                progress: min(rideMemory.getTotalMotorcycleCount(), 1),
                maxProgress: 1,
                rarity: .common
            ),
            Achievement(
                id: "car_collector",
                title: "Car Collector",
                description: "Create 3 car collections",
                icon: "🏆",
                isUnlocked: rideMemory.carCollections.count >= 3,
                progress: min(rideMemory.carCollections.count, 3),
                maxProgress: 3,
                rarity: .rare
            ),
            Achievement(
                id: "bike_collector",
                title: "Bike Enthusiast",
                description: "Create 3 motorcycle collections",
                icon: "⚡",
                isUnlocked: rideMemory.motorcycleCollections.count >= 3,
                progress: min(rideMemory.motorcycleCollections.count, 3),
                maxProgress: 3,
                rarity: .rare
            ),
            Achievement(
                id: "valuable_collection",
                title: "Millionaire",
                description: "Reach $1M total collection value",
                icon: "💰",
                isUnlocked: (rideMemory.getTotalCarValue() + rideMemory.getTotalMotorcycleValue()) >= 1_000_000,
                progress: min(Int((rideMemory.getTotalCarValue() + rideMemory.getTotalMotorcycleValue()) / 1_000_000), 1),
                maxProgress: 1,
                rarity: .epic
            ),
            Achievement(
                id: "excellent_condition",
                title: "Perfectionist",
                description: "Have 10 vehicles in excellent condition",
                icon: "✨",
                isUnlocked: (rideMemory.getCarsByCondition(.excellent).reduce(0) { $0 + $1.count } + 
                           rideMemory.getMotorcyclesByCondition(.excellent).reduce(0) { $0 + $1.quantity }) >= 10,
                progress: min((rideMemory.getCarsByCondition(.excellent).reduce(0) { $0 + $1.count } + 
                             rideMemory.getMotorcyclesByCondition(.excellent).reduce(0) { $0 + $1.quantity }), 10),
                maxProgress: 10,
                rarity: .rare
            ),
            Achievement(
                id: "diverse_collection",
                title: "Diversity Master",
                description: "Own vehicles of 5 different types",
                icon: "🌈",
                isUnlocked: getUniqueVehicleTypes() >= 5,
                progress: min(getUniqueVehicleTypes(), 5),
                maxProgress: 5,
                rarity: .epic
            ),
            Achievement(
                id: "veteran_collector",
                title: "Veteran Collector",
                description: "Own 50 total vehicles",
                icon: "🎖️",
                isUnlocked: (rideMemory.getTotalCarCount() + rideMemory.getTotalMotorcycleCount()) >= 50,
                progress: min((rideMemory.getTotalCarCount() + rideMemory.getTotalMotorcycleCount()), 50),
                maxProgress: 50,
                rarity: .legendary
            ),
            Achievement(
                id: "luxury_owner",
                title: "Luxury Owner",
                description: "Own 5 luxury cars",
                icon: "👑",
                isUnlocked: getLuxuryCarsCount() >= 5,
                progress: min(getLuxuryCarsCount(), 5),
                maxProgress: 5,
                rarity: .epic
            ),
            Achievement(
                id: "speed_king",
                title: "Speed King",
                description: "Own 5 sport motorcycles",
                icon: "🏎️",
                isUnlocked: getSportBikesCount() >= 5,
                progress: min(getSportBikesCount(), 5),
                maxProgress: 5,
                rarity: .epic
            )
        ]
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    AnimatedAchivGradientBackground(colors: colors)
                        .ignoresSafeArea()
                    AnimatedAchivDecorations(colors: colors, isAnimating: isAnimating)
                    
                    ScrollView {
                        VStack(spacing: AdaptiveSize.spacing(25)) {
                            VStack(spacing: AdaptiveSize.spacing(10)) {
                                Text("🏆")
                                    .font(.system(size: AdaptiveSize.iconSize(50)))
                                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
                                
                                Text("Achievements")
                                    .adaptiveFont(.largeTitle, size: 32)
                                    .fontWeight(.bold)
                                    .foregroundColor(colors.lightGray)
                                    .shadow(color: colors.almostBlack.opacity(0.5), radius: 3, x: 0, y: 2)
                                
                                Text("Unlock your RideRoad milestones")
                                    .adaptiveFont(.title3, size: 16)
                                    .fontWeight(.medium)
                                    .foregroundColor(colors.lightGray.opacity(0.9))
                                    .shadow(color: colors.almostBlack.opacity(0.3), radius: 1, x: 0, y: 1)
                            }
                            .adaptivePadding(.top, 20)
                            
                            AchievementStatsView(achievements: achievements, colors: colors)
                                .adaptivePadding(.horizontal, 20)
                            
                            LazyVStack(spacing: AdaptiveSize.spacing(15)) {
                                ForEach(achievements) { achievement in
                                    AchievementCardView(achievement: achievement, colors: colors)
                                }
                            }
                            .adaptivePadding(.horizontal, 20)
                            
                            ShareButtonView(colors: colors, showingShareSheet: $showingShareSheet)
                                .adaptivePadding(.horizontal, 20)
                                .adaptivePadding(.bottom, 30)
                        }
                    }
                }
                .navigationTitle("Achievements")
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
            .onAppear {
                isAnimating = true
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func getUniqueVehicleTypes() -> Int {
        let carTypes = Set(rideMemory.carCollections.flatMap { $0.cars }.map { $0.emoji })
        let bikeTypes = Set(rideMemory.motorcycleCollections.flatMap { $0.motorcycles }.map { $0.emoji })
        return carTypes.union(bikeTypes).count
    }
    
    private func getLuxuryCarsCount() -> Int {
        let allCars = rideMemory.carCollections.flatMap { $0.cars }
        let luxuryCars = allCars.filter { $0.emoji == "🚗" && $0.estimatedValue >= 100_000 }
        return luxuryCars.reduce(0) { $0 + $1.count }
    }
    
    private func getSportBikesCount() -> Int {
        let allMotorcycles = rideMemory.motorcycleCollections.flatMap { $0.motorcycles }
        let sportBikes = allMotorcycles.filter { $0.emoji == "🏎️" }
        return sportBikes.reduce(0) { $0 + $1.quantity }
    }
}

struct Achievement: Identifiable {
    let id: String
    let title: String
    let description: String
    let icon: String
    let isUnlocked: Bool
    let progress: Int
    let maxProgress: Int
    let rarity: AchievementRarity
}

enum AchievementRarity: String, CaseIterable {
    case common = "Common"
    case rare = "Rare"
    case epic = "Epic"
    case legendary = "Legendary"
    
    var color: Color {
        switch self {
        case .common:
            return Color.gray
        case .rare:
            return Color.blue
        case .epic:
            return Color.purple
        case .legendary:
            return Color.orange
        }
    }
    
    var emoji: String {
        switch self {
        case .common:
            return "🥉"
        case .rare:
            return "🥈"
        case .epic:
            return "🥇"
        case .legendary:
            return "💎"
        }
    }
}

struct AchievementStatsView: View {
    let achievements: [Achievement]
    let colors: (almostBlack: Color, grayBrown: Color, lightGray: Color, darkGray: Color, goldenYellow: Color, greenGray: Color, graphite: Color)
    
    private var unlockedCount: Int {
        achievements.filter { $0.isUnlocked }.count
    }
    
    private var totalCount: Int {
        achievements.count
    }
    
    var body: some View {
        HStack(spacing: AdaptiveSize.spacing(20)) {
            VStack(spacing: AdaptiveSize.spacing(8)) {
                Text("\(unlockedCount)")
                    .adaptiveFont(.title, size: 24)
                    .fontWeight(.bold)
                    .foregroundColor(colors.lightGray)
                
                Text("Unlocked")
                    .adaptiveFont(.caption, size: 12)
                    .fontWeight(.medium)
                    .foregroundColor(colors.lightGray.opacity(0.8))
            }
            
            VStack(spacing: AdaptiveSize.spacing(8)) {
                Text("\(totalCount)")
                    .adaptiveFont(.title, size: 24)
                    .fontWeight(.bold)
                    .foregroundColor(colors.lightGray)
                
                Text("Total")
                    .adaptiveFont(.caption, size: 12)
                    .fontWeight(.medium)
                    .foregroundColor(colors.lightGray.opacity(0.8))
            }
            
            VStack(spacing: AdaptiveSize.spacing(8)) {
                Text("\(Int((Double(unlockedCount) / Double(totalCount)) * 100))%")
                    .adaptiveFont(.title, size: 24)
                    .fontWeight(.bold)
                    .foregroundColor(colors.goldenYellow)
                
                Text("Complete")
                    .adaptiveFont(.caption, size: 12)
                    .fontWeight(.medium)
                    .foregroundColor(colors.goldenYellow.opacity(0.8))
            }
        }
        .adaptivePadding(.vertical, 20)
        .adaptivePadding(.horizontal, 30)
        .background(
            RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(15))
                .fill(colors.lightGray.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(15))
                        .stroke(colors.goldenYellow.opacity(0.4), lineWidth: 2)
                )
        )
        .shadow(color: colors.almostBlack.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

struct AchievementCardView: View {
    let achievement: Achievement
    let colors: (almostBlack: Color, grayBrown: Color, lightGray: Color, darkGray: Color, goldenYellow: Color, greenGray: Color, graphite: Color)
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: AdaptiveSize.spacing(15)) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: achievement.isUnlocked ? 
                                [colors.goldenYellow.opacity(0.8), colors.greenGray.opacity(0.6)] :
                                [colors.darkGray.opacity(0.6), colors.graphite.opacity(0.4)]
                            ),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: AdaptiveSize.iconSize(60), height: AdaptiveSize.iconSize(60))
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: achievement.isUnlocked ? 
                                        [colors.goldenYellow, colors.greenGray] :
                                        [colors.grayBrown.opacity(0.5), colors.darkGray.opacity(0.3)]
                                    ),
                                    startPoint: .top,
                                    endPoint: .bottom
                                ),
                                lineWidth: 2
                            )
                    )
                
                Text(achievement.icon)
                    .font(.system(size: AdaptiveSize.iconSize(30)))
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
            }
            
            VStack(alignment: .leading, spacing: AdaptiveSize.spacing(6)) {
                HStack {
                    Text(achievement.title)
                        .adaptiveFont(.title3, size: 18)
                        .fontWeight(.bold)
                        .foregroundColor(achievement.isUnlocked ? colors.lightGray : colors.lightGray.opacity(0.6))
                    
                    Spacer()
                    
                    HStack(spacing: AdaptiveSize.spacing(4)) {
                        Text(achievement.rarity.emoji)
                            .font(.system(size: AdaptiveSize.iconSize(16)))
                        
                        Text(achievement.rarity.rawValue)
                            .adaptiveFont(.caption2, size: 10)
                            .fontWeight(.semibold)
                            .foregroundColor(achievement.rarity.color)
                    }
                }
                
                Text(achievement.description)
                    .adaptiveFont(.body, size: 14)
                    .foregroundColor(achievement.isUnlocked ? colors.lightGray.opacity(0.9) : colors.lightGray.opacity(0.5))
                    .lineLimit(2)
                
                VStack(spacing: AdaptiveSize.spacing(4)) {
                    HStack {
                        Text("Progress")
                            .adaptiveFont(.caption, size: 12)
                            .fontWeight(.medium)
                            .foregroundColor(colors.lightGray.opacity(0.7))
                        
                        Spacer()
                        
                        Text("\(achievement.progress)/\(achievement.maxProgress)")
                            .adaptiveFont(.caption, size: 12)
                            .fontWeight(.bold)
                            .foregroundColor(achievement.isUnlocked ? colors.goldenYellow : colors.lightGray.opacity(0.6))
                    }
                    
                    ProgressView(value: Double(achievement.progress), total: Double(achievement.maxProgress))
                        .progressViewStyle(LinearProgressViewStyle(tint: achievement.isUnlocked ? colors.goldenYellow : colors.grayBrown))
                        .scaleEffect(y: 2)
                }
            }
            
            if achievement.isUnlocked {
                VStack {
                    Text("✓")
                        .font(.system(size: AdaptiveSize.iconSize(20), weight: .bold))
                        .foregroundColor(colors.greenGray)
                        .scaleEffect(isAnimating ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isAnimating)
                }
            }
        }
        .adaptivePadding(.all, 16)
        .background(
            RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(15))
                .fill(achievement.isUnlocked ? 
                    colors.lightGray.opacity(0.15) : 
                    colors.darkGray.opacity(0.1)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(15))
                        .stroke(
                            achievement.isUnlocked ? 
                                colors.goldenYellow.opacity(0.4) : 
                                colors.grayBrown.opacity(0.2), 
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

struct ShareButtonView: View {
    let colors: (almostBlack: Color, grayBrown: Color, lightGray: Color, darkGray: Color, goldenYellow: Color, greenGray: Color, graphite: Color)
    @Binding var showingShareSheet: Bool
    @State private var isAnimating = false
    
    private var shareText: String {
        """
        🚗🏍️ RideRoad - Ultimate Vehicle Collection App! 🏆
        
        Start your dream collection journey today! 
        
        ✨ Collect luxury cars & motorcycles
        🏆 Unlock amazing achievements  
        📊 Track your collection stats
        💎 Build your perfect garage
        
        Download RideRoad now and become a master collector! 
        
        #RideRoad #VehicleCollection #Cars #Motorcycles #Collection
        """
    }
    
    var body: some View {
        Button(action: {
            shareApp()
        }) {
            HStack(spacing: AdaptiveSize.spacing(12)) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: AdaptiveSize.iconSize(20), weight: .bold))
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
                
                Text("Share RideRoad with Friends")
                    .adaptiveFont(.headline, size: 18)
                    .fontWeight(.semibold)
            }
            .foregroundColor(colors.almostBlack)
            .frame(maxWidth: .infinity)
            .frame(height: AdaptiveSize.buttonHeight(50))
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
            .adaptiveCornerRadius(25)
            .shadow(color: colors.goldenYellow.opacity(0.4), radius: 8, x: 0, y: 4)
        }
        .scaleEffect(isAnimating ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
        .onAppear {
            isAnimating = true
        }
    }
    
    private func shareApp() {
        let activityViewController = UIActivityViewController(
            activityItems: [shareText],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityViewController, animated: true)
        }
    }
}


struct AnimatedAchivGradientBackground: View {
    let colors: (almostBlack: Color, grayBrown: Color, lightGray: Color, darkGray: Color, goldenYellow: Color, greenGray: Color, graphite: Color)
    @State private var animateGradient = false
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                colors.almostBlack,
                colors.darkGray,
                colors.graphite,
                colors.grayBrown,
                colors.almostBlack
            ]),
            startPoint: animateGradient ? .topLeading : .bottomTrailing,
            endPoint: animateGradient ? .bottomTrailing : .topLeading
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                animateGradient.toggle()
            }
        }
    }
}

struct AnimatedAchivDecorations: View {
    let colors: (almostBlack: Color, grayBrown: Color, lightGray: Color, darkGray: Color, goldenYellow: Color, greenGray: Color, graphite: Color)
    let isAnimating: Bool
    @State private var rotationAngle: Double = 0
    @State private var opacity: Double = 0.3
    
    var body: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { index in
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                colors.goldenYellow.opacity(0.1),
                                colors.greenGray.opacity(0.1),
                                Color.clear
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 200, height: 2)
                    .rotationEffect(.degrees(Double(index * 30) + rotationAngle))
                    .offset(
                        x: CGFloat(cos(Double(index) * 0.8 + rotationAngle) * 100),
                        y: CGFloat(sin(Double(index) * 0.6 + rotationAngle) * 50)
                    )
                    .opacity(opacity * 0.5)
                    .animation(
                        .linear(duration: Double(4 + index))
                        .repeatForever(autoreverses: false),
                        value: isAnimating
                    )
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
                rotationAngle = 360
            }
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                opacity = 0.6
            }
        }
    }
}

#Preview {
    AchivView()
}
