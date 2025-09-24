//
//  AnalizView.swift

import SwiftUI

struct AnalizView: View {
    @StateObject private var rideMemory = RideUserMemory.shared
    @State private var isAnimating = false
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
                    AnimatedGradientBackground(colors: colors)
                        .ignoresSafeArea()
                    
                    AnimatedDecorations(colors: colors, isAnimating: isAnimating)
                    
                    ScrollView {
                        VStack(spacing: 25) {
                            VStack(spacing: 10) {
                                Text("RideRoad Analytics")
                                    .adaptiveFont(.largeTitle, size: 32)
                                    .fontWeight(.bold)
                                    .foregroundColor(colors.lightGray)
                                    .shadow(color: colors.almostBlack.opacity(0.5), radius: 3, x: 0, y: 2)
                                    .scaleEffect(isAnimating ? 1.05 : 1.0)
                                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
                                
                                Text("Your Vehicle Collection Statistics & Insights")
                                    .adaptiveFont(.title3, size: 16)
                                    .fontWeight(.medium)
                                    .foregroundColor(colors.lightGray.opacity(0.9))
                                    .shadow(color: colors.almostBlack.opacity(0.3), radius: 1, x: 0, y: 1)
                            }
                            .padding(.top, 20)
                            
                            VStack(spacing: 20) {
                                Text("Overview")
                                    .adaptiveFont(.title, size: 24)
                                    .fontWeight(.bold)
                                    .foregroundColor(colors.lightGray)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                LazyVGrid(columns: [
                                    GridItem(.flexible()),
                                    GridItem(.flexible())
                                ], spacing: 15) {
                                    StatCardView(
                                        title: "Car Collections",
                                        value: "\(rideMemory.carCollections.count)",
                                        icon: "🚗",
                                        color: colors.greenGray,
                                        isAnimating: isAnimating
                                    )
                                    
                                    StatCardView(
                                        title: "Total Cars",
                                        value: "\(rideMemory.getTotalCarCount())",
                                        icon: "🚙",
                                        color: colors.grayBrown,
                                        isAnimating: isAnimating
                                    )
                                    
                                    StatCardView(
                                        title: "Motorcycle Collections",
                                        value: "\(rideMemory.motorcycleCollections.count)",
                                        icon: "🏍️",
                                        color: colors.goldenYellow,
                                        isAnimating: isAnimating
                                    )
                                    
                                    StatCardView(
                                        title: "Total Motorcycles",
                                        value: "\(rideMemory.getTotalMotorcycleCount())",
                                        icon: "🏎️",
                                        color: colors.darkGray,
                                        isAnimating: isAnimating
                                    )
                                    
                                    StatCardView(
                                        title: "Cars Value",
                                        value: formatCurrency(rideMemory.getTotalCarValue()),
                                        icon: "💰",
                                        color: colors.greenGray,
                                        isAnimating: isAnimating
                                    )
                                    
                                    StatCardView(
                                        title: "Motorcycles Value",
                                        value: formatCurrency(rideMemory.getTotalMotorcycleValue()),
                                        icon: "💎",
                                        color: colors.goldenYellow,
                                        isAnimating: isAnimating
                                    )
                                    
                                    // Автомобили в отличном состоянии
                                    StatCardView(
                                        title: "Excellent Cars",
                                        value: "\(getExcellentCarsCount())",
                                        icon: "✨",
                                        color: colors.greenGray,
                                        isAnimating: isAnimating
                                    )
                                    
                                    StatCardView(
                                        title: "Excellent Bikes",
                                        value: "\(getExcellentMotorcyclesCount())",
                                        icon: "🏆",
                                        color: colors.goldenYellow,
                                        isAnimating: isAnimating
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            if !rideMemory.carCollections.isEmpty {
                                VStack(spacing: 20) {
                                    Text("Car Collection Details")
                                        .adaptiveFont(.title, size: 24)
                                        .fontWeight(.bold)
                                        .foregroundColor(colors.lightGray)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    ForEach(rideMemory.carCollections) { collection in
                                        CarCollectionStatCardView(collection: collection, isAnimating: isAnimating, colors: colors)
                                    }
                                }
                                .adaptivePadding(.horizontal, 20)
                            }
                            
                            // Статистика по коллекциям мотоциклов
                            if !rideMemory.motorcycleCollections.isEmpty {
                                VStack(spacing: 20) {
                                    Text("Motorcycle Collection Details")
                                        .adaptiveFont(.title, size: 24)
                                        .fontWeight(.bold)
                                        .foregroundColor(colors.lightGray)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    ForEach(rideMemory.motorcycleCollections) { collection in
                                        MotorcycleCollectionStatCardView(collection: collection, isAnimating: isAnimating, colors: colors)
                                    }
                                }
                                .adaptivePadding(.horizontal, 20)
                            }
                            
                            // Статистика по типам автомобилей
                            VStack(spacing: 20) {
                                Text("Cars by Type")
                                    .adaptiveFont(.title, size: 24)
                                    .fontWeight(.bold)
                                    .foregroundColor(colors.lightGray)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                LazyVGrid(columns: [
                                    GridItem(.flexible()),
                                    GridItem(.flexible())
                                ], spacing: 15) {
                                    ForEach(CarType.allCases, id: \.self) { carType in
                                        CarTypeCardView(
                                            carType: carType,
                                            count: getCarCountByType(carType),
                                            isAnimating: isAnimating,
                                            colors: colors
                                        )
                                    }
                                }
                            }
                            .adaptivePadding(.horizontal, 20)
                            
                            // Статистика по типам мотоциклов
                            VStack(spacing: 20) {
                                Text("Motorcycles by Type")
                                    .adaptiveFont(.title, size: 24)
                                    .fontWeight(.bold)
                                    .foregroundColor(colors.lightGray)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                LazyVGrid(columns: [
                                    GridItem(.flexible()),
                                    GridItem(.flexible())
                                ], spacing: 15) {
                                    ForEach(MotorcycleType.allCases, id: \.self) { motorcycleType in
                                        MotorcycleTypeCardView(
                                            motorcycleType: motorcycleType,
                                            count: getMotorcycleCountByType(motorcycleType),
                                            isAnimating: isAnimating,
                                            colors: colors
                                        )
                                    }
                                }
                            }
                            .adaptivePadding(.horizontal, 20)
                            
                            Spacer(minLength: 50)
                        }
                    }
                }
            }
            .navigationTitle("Analytics")
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
    
    private func formatCurrency(_ value: Double) -> String {
        if value >= 1000000 {
            return String(format: "$%.1fM", value / 1000000)
        } else if value >= 1000 {
            return String(format: "$%.1fK", value / 1000)
        } else {
            return String(format: "$%.0f", value)
        }
    }
    
    private func getExcellentCarsCount() -> Int {
        return rideMemory.getCarsByCondition(.excellent).reduce(0) { $0 + $1.count }
    }
    
    private func getExcellentMotorcyclesCount() -> Int {
        return rideMemory.getMotorcyclesByCondition(.excellent).reduce(0) { $0 + $1.quantity }
    }
    
    private func getCarCountByType(_ type: CarType) -> Int {
        return rideMemory.carCollections.flatMap { $0.cars }
            .filter { $0.emoji == type.emoji }
            .reduce(0) { $0 + $1.count }
    }
    
    private func getMotorcycleCountByType(_ type: MotorcycleType) -> Int {
        return rideMemory.motorcycleCollections.flatMap { $0.motorcycles }
            .filter { $0.emoji == type.emoji }
            .reduce(0) { $0 + $1.quantity }
    }
}

struct StatCardView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let isAnimating: Bool
    
    var body: some View {
        VStack(spacing: AdaptiveSize.spacing(12)) {
            Text(icon)
                .font(.system(size: AdaptiveSize.iconSize(30)))
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
            
            Text(value)
                .adaptiveFont(.title2, size: 20)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
                .shadow(color: Color.black.opacity(0.3), radius: 1, x: 0, y: 1)
            
            Text(title)
                .adaptiveFont(.caption, size: 12)
                .fontWeight(.medium)
                .foregroundColor(Color.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .adaptivePadding(.all, 20)
        .background(
            RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(15))
                .fill(color.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(15))
                        .stroke(color.opacity(0.6), lineWidth: 2)
                )
        )
        .shadow(color: color.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}

// Карточка статистики коллекции автомобилей
struct CarCollectionStatCardView: View {
    let collection: CarCollection
    let isAnimating: Bool
    let colors: (almostBlack: Color, grayBrown: Color, lightGray: Color, darkGray: Color, goldenYellow: Color, greenGray: Color, graphite: Color)
    
    private var totalCars: Int {
        return collection.cars.reduce(0) { $0 + $1.count }
    }
    
    private var totalValue: Double {
        return collection.cars.reduce(0) { $0 + ($1.estimatedValue * Double($1.count)) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AdaptiveSize.spacing(15)) {
            HStack {
                VStack(alignment: .leading, spacing: AdaptiveSize.spacing(4)) {
                    Text(collection.name)
                        .adaptiveFont(.title3, size: 18)
                        .fontWeight(.bold)
                        .foregroundColor(colors.lightGray)
                    
                    Text(collection.location)
                        .adaptiveFont(.body, size: 14)
                        .foregroundColor(colors.lightGray.opacity(0.8))
                }
                
                Spacer()
                
                Text("🚗")
                    .font(.system(size: AdaptiveSize.iconSize(24)))
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
            }
            
            HStack(spacing: AdaptiveSize.spacing(20)) {
                VStack(alignment: .leading, spacing: AdaptiveSize.spacing(4)) {
                    Text("\(totalCars)")
                        .adaptiveFont(.headline, size: 16)
                        .fontWeight(.bold)
                        .foregroundColor(colors.lightGray)
                    
                    Text("Cars")
                        .adaptiveFont(.caption, size: 12)
                        .foregroundColor(colors.lightGray.opacity(0.8))
                }
                
                VStack(alignment: .leading, spacing: AdaptiveSize.spacing(4)) {
                    Text(formatCurrency(totalValue))
                        .adaptiveFont(.headline, size: 16)
                        .fontWeight(.bold)
                        .foregroundColor(colors.lightGray)
                    
                    Text("Value")
                        .adaptiveFont(.caption, size: 12)
                        .foregroundColor(colors.lightGray.opacity(0.8))
                }
                
                Spacer()
            }
        }
        .adaptivePadding(.all, 20)
        .background(
            RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(15))
                .fill(colors.lightGray.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(15))
                        .stroke(colors.greenGray.opacity(0.4), lineWidth: 1)
                )
        )
        .shadow(color: colors.almostBlack.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    private func formatCurrency(_ value: Double) -> String {
        if value >= 1000000 {
            return String(format: "$%.1fM", value / 1000000)
        } else if value >= 1000 {
            return String(format: "$%.1fK", value / 1000)
        } else {
            return String(format: "$%.0f", value)
        }
    }
}

struct CarTypeCardView: View {
    let carType: CarType
    let count: Int
    let isAnimating: Bool
    let colors: (almostBlack: Color, grayBrown: Color, lightGray: Color, darkGray: Color, goldenYellow: Color, greenGray: Color, graphite: Color)
    
    var body: some View {
        VStack(spacing: AdaptiveSize.spacing(8)) {
            Text(carType.emoji)
                .font(.system(size: AdaptiveSize.iconSize(24)))
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
            
            Text("\(count)")
                .adaptiveFont(.title3, size: 18)
                .fontWeight(.bold)
                .foregroundColor(colors.lightGray)
            
            Text(carType.displayName)
                .adaptiveFont(.caption2, size: 10)
                .fontWeight(.medium)
                .foregroundColor(colors.lightGray.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .adaptivePadding(.all, 15)
        .background(
            RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(12))
                .fill(colors.lightGray.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(12))
                        .stroke(colors.greenGray.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct MotorcycleCollectionStatCardView: View {
    let collection: MotorcycleCollection
    let isAnimating: Bool
    let colors: (almostBlack: Color, grayBrown: Color, lightGray: Color, darkGray: Color, goldenYellow: Color, greenGray: Color, graphite: Color)
    
    private var totalMotorcycles: Int {
        return collection.motorcycles.reduce(0) { $0 + $1.quantity }
    }
    
    private var totalValue: Double {
        return collection.motorcycles.reduce(0) { $0 + ($1.estimatedValue * Double($1.quantity)) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AdaptiveSize.spacing(15)) {
            HStack {
                VStack(alignment: .leading, spacing: AdaptiveSize.spacing(4)) {
                    Text(collection.name)
                        .adaptiveFont(.title3, size: 18)
                        .fontWeight(.bold)
                        .foregroundColor(colors.lightGray)
                    
                    Text(collection.location)
                        .adaptiveFont(.body, size: 14)
                        .foregroundColor(colors.lightGray.opacity(0.8))
                }
                
                Spacer()
                
                Text("🏍️")
                    .font(.system(size: AdaptiveSize.iconSize(24)))
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
            }
            
            HStack(spacing: AdaptiveSize.spacing(20)) {
                VStack(alignment: .leading, spacing: AdaptiveSize.spacing(4)) {
                    Text("\(totalMotorcycles)")
                        .adaptiveFont(.headline, size: 16)
                        .fontWeight(.bold)
                        .foregroundColor(colors.lightGray)
                    
                    Text("Motorcycles")
                        .adaptiveFont(.caption, size: 12)
                        .foregroundColor(colors.lightGray.opacity(0.8))
                }
                
                VStack(alignment: .leading, spacing: AdaptiveSize.spacing(4)) {
                    Text(formatCurrency(totalValue))
                        .adaptiveFont(.headline, size: 16)
                        .fontWeight(.bold)
                        .foregroundColor(colors.lightGray)
                    
                    Text("Value")
                        .adaptiveFont(.caption, size: 12)
                        .foregroundColor(colors.lightGray.opacity(0.8))
                }
                
                Spacer()
            }
        }
        .adaptivePadding(.all, 20)
        .background(
            RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(15))
                .fill(colors.lightGray.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(15))
                        .stroke(colors.goldenYellow.opacity(0.4), lineWidth: 1)
                )
        )
        .shadow(color: colors.almostBlack.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    private func formatCurrency(_ value: Double) -> String {
        if value >= 1000000 {
            return String(format: "$%.1fM", value / 1000000)
        } else if value >= 1000 {
            return String(format: "$%.1fK", value / 1000)
        } else {
            return String(format: "$%.0f", value)
        }
    }
}

struct MotorcycleTypeCardView: View {
    let motorcycleType: MotorcycleType
    let count: Int
    let isAnimating: Bool
    let colors: (almostBlack: Color, grayBrown: Color, lightGray: Color, darkGray: Color, goldenYellow: Color, greenGray: Color, graphite: Color)
    
    var body: some View {
        VStack(spacing: AdaptiveSize.spacing(8)) {
            Text(motorcycleType.emoji)
                .font(.system(size: AdaptiveSize.iconSize(24)))
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
            
            Text("\(count)")
                .adaptiveFont(.title3, size: 18)
                .fontWeight(.bold)
                .foregroundColor(colors.lightGray)
            
            Text(motorcycleType.displayName)
                .adaptiveFont(.caption2, size: 10)
                .fontWeight(.medium)
                .foregroundColor(colors.lightGray.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .adaptivePadding(.all, 15)
        .background(
            RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(12))
                .fill(colors.lightGray.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(12))
                        .stroke(colors.goldenYellow.opacity(0.3), lineWidth: 1)
                )
        )
    }
}


struct AnimatedGradientBackground: View {
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

struct AnimatedDecorations: View {
    let colors: (almostBlack: Color, grayBrown: Color, lightGray: Color, darkGray: Color, goldenYellow: Color, greenGray: Color, graphite: Color)
    let isAnimating: Bool
    @State private var rotationAngle: Double = 0
    @State private var opacity: Double = 0.1
    
    var body: some View {
        ZStack {
            // Тонкие декоративные линии
            ForEach(0..<4, id: \.self) { index in
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                colors.goldenYellow.opacity(0.05),
                                colors.greenGray.opacity(0.03),
                                Color.clear
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 120, height: 1)
                    .rotationEffect(.degrees(Double(index * 45) + rotationAngle))
                    .offset(
                        x: CGFloat(cos(Double(index) * 0.6 + rotationAngle) * 80),
                        y: CGFloat(sin(Double(index) * 0.4 + rotationAngle) * 60)
                    )
                    .opacity(opacity)
                    .animation(
                        .linear(duration: Double(8 + index * 2))
                        .repeatForever(autoreverses: false),
                        value: isAnimating
                    )
            }
            
            // Мягкие круги
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                colors.goldenYellow.opacity(0.03),
                                colors.greenGray.opacity(0.02),
                                Color.clear
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 40
                        )
                    )
                    .frame(width: 80, height: 80)
                    .offset(
                        x: CGFloat(cos(Double(index) * 0.8 + rotationAngle * 0.5) * 100),
                        y: CGFloat(sin(Double(index) * 0.6 + rotationAngle * 0.5) * 70)
                    )
                    .opacity(opacity * 0.6)
                    .animation(
                        .easeInOut(duration: Double(6 + index))
                        .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
            }
            
            // Тонкие геометрические формы
            ForEach(0..<2, id: \.self) { index in
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                colors.greenGray.opacity(0.04),
                                colors.goldenYellow.opacity(0.02),
                                Color.clear
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 40)
                    .rotationEffect(.degrees(Double(index * 60) + rotationAngle * 0.3))
                    .offset(
                        x: CGFloat(sin(Double(index) * 1.2 + rotationAngle * 0.7) * 90),
                        y: CGFloat(cos(Double(index) * 0.9 + rotationAngle * 0.7) * 50)
                    )
                    .opacity(opacity * 0.4)
                    .animation(
                        .easeInOut(duration: Double(10 + index * 3))
                        .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                rotationAngle = 360
            }
            withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                opacity = 0.3
            }
        }
    }
}

#Preview {
    AnalizView()
}

