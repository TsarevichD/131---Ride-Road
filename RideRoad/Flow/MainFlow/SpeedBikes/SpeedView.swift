//
//  SpeedView.swift

import SwiftUI

struct SpeedView: View {
    @StateObject private var rideMemory = RideUserMemory.shared
    @State private var isAnimating = false
    @State private var showingAddCollection = false
    @State private var newCollectionName = ""
    @State private var newCollectionLocation = ""
    @State private var newCollectionDescription = ""
    @EnvironmentObject var appState: AppState

    private let colors = (
        almostBlack: Color(hex: "#020303"),
        darkRed: Color(hex: "#8B0000"),
        orange: Color(hex: "#FF4500"),
        yellow: Color(hex: "#FFD700"),
        silver: Color(hex: "#C0C0C0"),
        darkGray: Color(hex: "#2F2F2F"),
        lightGray: Color(hex: "#E5E6E3")
    )

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        colors.darkGray,
                        colors.almostBlack,
                        colors.darkRed.opacity(0.3),
                        colors.almostBlack
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ForEach(0..<8, id: \.self) { index in
                    MotorcycleElementView(index: index, colors: colors)
                }
                
                VStack {
                    HStack {
                        Button(action: {
                            appState.currentScreen = .home
                        }) {
                            ZStack {
                                Circle()
                                    .fill(colors.lightGray.opacity(0.2))
                                    .frame(width: AdaptiveSize.iconSize(50), height: AdaptiveSize.iconSize(50))
                                
                                Image(systemName: "arrow.left")
                                    .font(.system(size: AdaptiveSize.iconSize(20), weight: .bold))
                                    .foregroundColor(colors.lightGray)
                            }
                        }
                        .adaptivePadding(.top, 36)
                        .adaptivePadding(.leading, 12)
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
                
                VStack {
                    Text("Speed Bikes Collection")
                        .adaptiveFont(.largeTitle, size: 28)
                        .fontWeight(.bold)
                        .foregroundColor(colors.lightGray)
                        .shadow(color: colors.almostBlack.opacity(0.5), radius: 3, x: 0, y: 2)
                        .adaptivePadding(.top, 88)
                    
                    Spacer()
                }
                
                VStack(spacing: AdaptiveSize.spacing(32)) {
                    Spacer()
                    
                    if rideMemory.motorcycleCollections.isEmpty {
                        VStack(spacing: AdaptiveSize.spacing(24)) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                colors.orange.opacity(0.4),
                                                colors.darkRed.opacity(0.3)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: AdaptiveSize.iconSize(100), height: AdaptiveSize.iconSize(100))
                                    .shadow(color: colors.orange.opacity(0.5), radius: 15, x: 0, y: 8)
                                
                                Text("🏍️")
                                    .font(.system(size: AdaptiveSize.iconSize(50)))
                                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
                            }
                            
                            VStack(spacing: AdaptiveSize.spacing(15)) {
                                Text("Create Your First Bike Collection")
                                    .adaptiveFont(.title, size: 24)
                                    .fontWeight(.bold)
                                    .foregroundColor(colors.lightGray)
                                    .multilineTextAlignment(.center)
                                    .shadow(color: colors.almostBlack.opacity(0.5), radius: 3, x: 0, y: 2)
                                
                                Text("Start your motorcycle journey by creating your first collection")
                                    .adaptiveFont(.body, size: 16)
                                    .foregroundColor(colors.lightGray.opacity(0.8))
                                    .multilineTextAlignment(.center)
                                    .adaptivePadding(.horizontal, 40)
                                    .shadow(color: colors.almostBlack.opacity(0.3), radius: 1, x: 0, y: 1)
                            }
                        }
                        .adaptivePadding(.top, 80)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: AdaptiveSize.spacing(15)) {
                                ForEach(Array(rideMemory.motorcycleCollections.enumerated()), id: \.element.id) { index, collection in
                                    MotorcycleCollectionCardView(collection: collection, colors: colors)
                                        .onTapGesture {
                                            appState.selectedBikesIndex = index
                                            appState.currentScreen = .bike
                                        }
                                }
                            }
                            .adaptivePadding(.horizontal, 20)
                        }
                        .adaptivePadding(.top, 100)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            showingAddCollection = true
                        }) {
                            ZStack {
                                Circle()
                                    .stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                colors.orange.opacity(0.9),
                                                colors.darkRed.opacity(0.8)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 4
                                    )
                                    .frame(width: AdaptiveSize.iconSize(70), height: AdaptiveSize.iconSize(70))
                                
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                colors.orange.opacity(0.9),
                                                colors.darkRed.opacity(0.8)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: AdaptiveSize.iconSize(60), height: AdaptiveSize.iconSize(60))
                                    .shadow(color: colors.orange.opacity(0.8), radius: 20, x: 0, y: 10)
                                
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                colors.yellow.opacity(0.6),
                                                Color.clear
                                            ]),
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .frame(width: AdaptiveSize.iconSize(60), height: AdaptiveSize.iconSize(60))
                                
                                ZStack {
                                    Image(systemName: "plus")
                                        .font(.system(size: AdaptiveSize.iconSize(20), weight: .bold))
                                        .foregroundColor(colors.lightGray)
                                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
                                }
                            }
                        }
                        .scaleEffect(isAnimating ? 1.05 : 1.0)
                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
                        .adaptivePadding(.trailing, 30)
                        .adaptivePadding(.bottom, 30)
                    }
                }
            }
        }
        .onAppear {
            isAnimating = true
        }
        .sheet(isPresented: $showingAddCollection) {
            AddMotorcycleCollectionView(
                collectionName: $newCollectionName,
                collectionLocation: $newCollectionLocation,
                collectionDescription: $newCollectionDescription,
                colors: colors,
                onSave: {
                    let newCollection = MotorcycleCollection(
                        name: newCollectionName,
                        location: newCollectionLocation,
                        description: newCollectionDescription
                    )
                    rideMemory.addMotorcycleCollection(newCollection)
                    newCollectionName = ""
                    newCollectionLocation = ""
                    newCollectionDescription = ""
                    showingAddCollection = false
                }
            )
        }
    }
}

// MARK: - Motorcycle Element View
struct MotorcycleElementView: View {
    let index: Int
    let colors: (almostBlack: Color, darkRed: Color, orange: Color, yellow: Color, silver: Color, darkGray: Color, lightGray: Color)
    
    @State private var offset: CGSize = .zero
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 0.6
    
    private let motorcycleIcons = ["🏍️", "⚡", "🔥", "💥", "🚀", "⭐", "💀", "⚔️"]
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            colors.orange.opacity(0.4),
                            colors.darkRed.opacity(0.3),
                            Color.clear
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: 50
                    )
                )
                .frame(width: AdaptiveSize.iconSize(70), height: AdaptiveSize.iconSize(70))
                .scaleEffect(scale)
            
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            colors.orange.opacity(0.9),
                            colors.darkRed.opacity(0.8)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: AdaptiveSize.iconSize(45), height: AdaptiveSize.iconSize(45))
                .overlay(
                    Circle()
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    colors.yellow.opacity(0.9),
                                    colors.silver.opacity(0.6)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 2
                        )
                )
            
            Text(motorcycleIcons[index % motorcycleIcons.count])
                .font(.system(size: AdaptiveSize.iconSize(22)))
                .foregroundColor(colors.lightGray)
        }
        .offset(offset)
        .rotationEffect(.degrees(rotation))
        .opacity(opacity)
        .onAppear {
            let randomX = CGFloat.random(in: -200...200)
            let randomY = CGFloat.random(in: -300...300)
            offset = CGSize(width: randomX, height: randomY)
            
            withAnimation(
                .easeInOut(duration: Double.random(in: 4...8))
                .repeatForever(autoreverses: true)
            ) {
                offset = CGSize(
                    width: randomX + CGFloat.random(in: -120...120),
                    height: randomY + CGFloat.random(in: -180...180)
                )
                rotation = Double.random(in: 0...360)
                scale = CGFloat.random(in: 0.7...1.4)
                opacity = Double.random(in: 0.5...0.9)
            }
        }
    }
}

// MARK: - Motorcycle Collection Card View
struct MotorcycleCollectionCardView: View {
    let collection: MotorcycleCollection
    let colors: (almostBlack: Color, darkRed: Color, orange: Color, yellow: Color, silver: Color, darkGray: Color, lightGray: Color)
    @State private var isAnimating = false
    
    private var collectionTotalValue: Double {
        return collection.motorcycles.reduce(0) { $0 + ($1.estimatedValue * Double($1.quantity)) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AdaptiveSize.spacing(16)) {
            HStack {
                VStack(alignment: .leading, spacing: AdaptiveSize.spacing(6)) {
                    Text(collection.name)
                        .adaptiveFont(.title2, size: 20)
                        .fontWeight(.bold)
                        .foregroundColor(colors.lightGray)
                        .shadow(color: colors.almostBlack.opacity(0.3), radius: 1, x: 0, y: 1)
                    
                    HStack(spacing: AdaptiveSize.spacing(4)) {
                        Image(systemName: "location.fill")
                            .font(.system(size: AdaptiveSize.iconSize(12)))
                            .foregroundColor(colors.lightGray.opacity(0.8))
                        
                        Text(collection.location)
                            .adaptiveFont(.body, size: 14)
                            .fontWeight(.medium)
                            .foregroundColor(colors.lightGray.opacity(0.9))
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: AdaptiveSize.spacing(8)) {
                    HStack(spacing: AdaptiveSize.spacing(4)) {
                        Text("🏍️")
                            .font(.system(size: AdaptiveSize.iconSize(16)))
                            .scaleEffect(isAnimating ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true).delay(0.2), value: isAnimating)
                        
                        Text("\(collection.motorcycles.count)")
                            .adaptiveFont(.title3, size: 18)
                            .fontWeight(.bold)
                            .foregroundColor(colors.lightGray)
                            .shadow(color: colors.almostBlack.opacity(0.3), radius: 1, x: 0, y: 1)
                    }
                    
                    Text("Bikes")
                        .adaptiveFont(.caption, size: 12)
                        .fontWeight(.medium)
                        .foregroundColor(colors.lightGray.opacity(0.8))
                    
                    HStack(spacing: AdaptiveSize.spacing(4)) {
                        Text("💰")
                            .font(.system(size: AdaptiveSize.iconSize(14)))
                            .scaleEffect(isAnimating ? 1.05 : 1.0)
                            .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true).delay(0.5), value: isAnimating)
                        
                        Text(formatCurrency(collectionTotalValue))
                            .adaptiveFont(.body, size: 14)
                            .fontWeight(.bold)
                            .foregroundColor(colors.lightGray)
                            .shadow(color: colors.almostBlack.opacity(0.3), radius: 1, x: 0, y: 1)
                    }
                    
                    Text("Total Value")
                        .adaptiveFont(.caption2, size: 10)
                        .fontWeight(.medium)
                        .foregroundColor(colors.lightGray.opacity(0.7))
                }
            }
            
            if !collection.description.isEmpty {
                Text(collection.description)
                    .adaptiveFont(.body, size: 14)
                    .fontWeight(.medium)
                    .foregroundColor(colors.lightGray.opacity(0.8))
                    .lineLimit(2)
                    .adaptivePadding(.vertical, 4)
            }
            
            HStack {
                HStack(spacing: AdaptiveSize.spacing(4)) {
                    Image(systemName: "calendar")
                        .font(.system(size: AdaptiveSize.iconSize(10)))
                        .foregroundColor(colors.lightGray.opacity(0.6))
                    
                    Text("Created: \(collection.createdAt, formatter: dateFormatter)")
                        .adaptiveFont(.caption, size: 12)
                        .fontWeight(.medium)
                        .foregroundColor(colors.lightGray.opacity(0.7))
                }
                
                Spacer()
                
                HStack(spacing: AdaptiveSize.spacing(4)) {
                    Circle()
                        .fill(collection.motorcycles.isEmpty ? colors.darkGray.opacity(0.8) : colors.orange.opacity(0.8))
                        .frame(width: AdaptiveSize.iconSize(8), height: AdaptiveSize.iconSize(8))
                        .scaleEffect(isAnimating ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isAnimating)
                    
                    Text(collection.motorcycles.isEmpty ? "Empty" : "Active")
                        .adaptiveFont(.caption2, size: 10)
                        .fontWeight(.semibold)
                        .foregroundColor(colors.lightGray.opacity(0.8))
                }
            }
        }
        .adaptivePadding(.horizontal, 20)
        .adaptivePadding(.vertical, 16)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(20))
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                colors.darkGray.opacity(0.9),
                                colors.almostBlack.opacity(0.8)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(20))
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                colors.orange.opacity(0.8),
                                colors.darkRed.opacity(0.6)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 2
                    )
                
                RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(20))
                    .stroke(colors.orange.opacity(0.5), lineWidth: 1)
            }
        )
        .shadow(color: colors.almostBlack.opacity(0.4), radius: 10, x: 0, y: 5)
        .scaleEffect(isAnimating ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: isAnimating)
        .onAppear {
            isAnimating = true
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
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

// MARK: - Add Motorcycle Collection View
struct AddMotorcycleCollectionView: View {
    @Binding var collectionName: String
    @Binding var collectionLocation: String
    @Binding var collectionDescription: String
    let colors: (almostBlack: Color, darkRed: Color, orange: Color, yellow: Color, silver: Color, darkGray: Color, lightGray: Color)
    let onSave: () -> Void
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: AdaptiveSize.spacing(20)) {
                VStack(alignment: .leading, spacing: AdaptiveSize.spacing(8)) {
                    Text("Collection Name")
                        .adaptiveFont(.headline, size: 16)
                        .fontWeight(.medium)
                        .foregroundColor(colors.lightGray)
                    
                    TextField("Enter collection name", text: $collectionName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .foregroundColor(colors.almostBlack)
                }
                
                VStack(alignment: .leading, spacing: AdaptiveSize.spacing(8)) {
                    Text("Location")
                        .adaptiveFont(.headline, size: 16)
                        .fontWeight(.medium)
                        .foregroundColor(colors.lightGray)
                    
                    TextField("Enter location", text: $collectionLocation)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .foregroundColor(colors.almostBlack)
                }
                
                VStack(alignment: .leading, spacing: AdaptiveSize.spacing(8)) {
                    Text("Description (Optional)")
                        .adaptiveFont(.headline, size: 16)
                        .fontWeight(.medium)
                        .foregroundColor(colors.lightGray)
                    
                    TextField("Enter description", text: $collectionDescription, axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(3...6)
                        .foregroundColor(colors.almostBlack)
                }
                
                Spacer()
                
                Button(action: onSave) {
                    HStack {
                        Text("Create Collection")
                            .adaptiveFont(.headline, size: 18)
                            .fontWeight(.semibold)
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: AdaptiveSize.iconSize(18)))
                    }
                    .foregroundColor(colors.lightGray)
                    .frame(maxWidth: .infinity)
                    .frame(height: AdaptiveSize.buttonHeight(50))
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                colors.orange,
                                colors.darkRed.opacity(0.8)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .adaptiveCornerRadius(25)
                }
                .disabled(collectionName.isEmpty || collectionLocation.isEmpty)
                .opacity(collectionName.isEmpty || collectionLocation.isEmpty ? 0.6 : 1.0)
            }
            .adaptivePadding(.all, 20)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        colors.darkGray,
                        colors.almostBlack
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .navigationTitle("New Bike Collection")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(colors.lightGray)
            )
        }
    }
}

#Preview {
    SpeedView()
}


