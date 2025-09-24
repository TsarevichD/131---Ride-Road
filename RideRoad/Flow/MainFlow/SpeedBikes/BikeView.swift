//
//  BikeView.swift

import SwiftUI

struct BikeView: View {
    let collectionIndex: Int
    @StateObject private var rideMemory = RideUserMemory.shared
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appState: AppState
    @State private var isAnimating = false
    @State private var showingAddBike = false
    @State private var newBikeName = ""
    @State private var selectedMotorcycleType = MotorcycleType.sport
    @State private var bikeQuantity = 1
    @State private var estimatedValue = 0.0
    @State private var brand = ""
    @State private var year = 2020
    @State private var engineSize = 0.0
    @State private var condition = MotorcycleCondition.excellent
    @State private var notes = ""

    private var collection: MotorcycleCollection? {
        guard collectionIndex < rideMemory.motorcycleCollections.count else { return nil }
        return rideMemory.motorcycleCollections[collectionIndex]
    }
    
    private let colors = (
        deepPurple: Color(hex: "#7c3aed"),
        electricBlue: Color(hex: "#3b82f6"),
        neonGreen: Color(hex: "#10b981"),
        brightOrange: Color(hex: "#f97316"),
        lightCyan: Color(hex: "#06b6d4"),
        goldenYellow: Color(hex: "#deb85b"),
        steelGray: Color(hex: "#64748b")
    )
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            colors.deepPurple,
                            colors.electricBlue,
                            colors.neonGreen.opacity(0.3),
                            colors.brightOrange.opacity(0.2)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                    
                    VStack(spacing: AdaptiveSize.spacing(20)) {
                        VStack(spacing: AdaptiveSize.spacing(10)) {
                            Text(collection?.name ?? "Motorcycle Collection")
                                .adaptiveFont(.largeTitle, size: 28)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.7), radius: 3, x: 0, y: 2)
                            
                            HStack(spacing: AdaptiveSize.spacing(8)) {
                                Image(systemName: "location.fill")
                                    .font(.system(size: AdaptiveSize.iconSize(14)))
                                    .foregroundColor(.white)
                                
                                Text(collection?.location ?? "Unknown Location")
                                    .adaptiveFont(.title3, size: 16)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)
                            }
                        }
                        .adaptivePadding(.top, 20)
                        
                        HStack(spacing: AdaptiveSize.spacing(30)) {
                            VStack(spacing: AdaptiveSize.spacing(4)) {
                                Text("\(collection?.motorcycles.count ?? 0)")
                                    .adaptiveFont(.title, size: 24)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.6), radius: 2, x: 0, y: 1)
                                
                                Text("Bikes")
                                    .adaptiveFont(.caption, size: 12)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.4), radius: 1, x: 0, y: 1)
                            }
                            
                            VStack(spacing: AdaptiveSize.spacing(4)) {
                                Text("$\(String(format: "%.0f", collectionTotalValue))")
                                    .adaptiveFont(.title, size: 24)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.6), radius: 2, x: 0, y: 1)
                                
                                Text("Total Value")
                                    .adaptiveFont(.caption, size: 12)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.4), radius: 1, x: 0, y: 1)
                            }
                        }
                        .adaptivePadding(.vertical, 20)
                        .adaptivePadding(.horizontal, 30)
                        .background(
                            RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(15))
                                .fill(colors.lightCyan.opacity(0.2))
                                .overlay(
                                    RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(15))
                                        .stroke(colors.brightOrange.opacity(0.6), lineWidth: 2)
                                )
                        )
                        
                        if collection?.motorcycles.isEmpty == true {
                            VStack(spacing: AdaptiveSize.spacing(20)) {
                                Text("🏍️")
                                    .font(.system(size: AdaptiveSize.iconSize(60)))
                                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
                                
                                Text("No Bikes Yet")
                                    .adaptiveFont(.title2, size: 20)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 1)
                                
                                Text("Add your first motorcycle to get started")
                                    .adaptiveFont(.body, size: 16)
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)
                                    .multilineTextAlignment(.center)
                            }
                            .adaptivePadding(.top, 50)
                        } else {
                            ScrollView {
                                LazyVStack(spacing: AdaptiveSize.spacing(12)) {
                                    ForEach(collection?.motorcycles ?? []) { motorcycle in
                                        MotorcycleCardView(motorcycle: motorcycle, colors: colors)
                                    }
                                }
                                .adaptivePadding(.horizontal, 20)
                            }
                        }
                        
                        Spacer()
                    }
                }
            }
            .navigationTitle("Motorcycles")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        appState.currentScreen = .speed
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.left.circle.fill")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Back")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(colors.brightOrange.opacity(0.2))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(colors.brightOrange.opacity(0.6), lineWidth: 1)
                                )
                        )
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddBike = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            isAnimating = true
        }
        .sheet(isPresented: $showingAddBike) {
            AddMotorcycleView(collectionIndex: collectionIndex, colors: colors)
        }
    }
    
    private var collectionTotalValue: Double {
        return collection?.motorcycles.reduce(0) { $0 + ($1.estimatedValue * Double($1.quantity)) } ?? 0
    }
}

struct MotorcycleCardView: View {
    let motorcycle: Motorcycle
    let colors: (deepPurple: Color, electricBlue: Color, neonGreen: Color, brightOrange: Color, lightCyan: Color, goldenYellow: Color, steelGray: Color)
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: AdaptiveSize.spacing(15)) {
            // Эмодзи мотоцикла
            Text(motorcycle.emoji)
                .font(.system(size: AdaptiveSize.iconSize(30)))
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
            
            VStack(alignment: .leading, spacing: AdaptiveSize.spacing(4)) {
                Text(motorcycle.name)
                    .adaptiveFont(.title3, size: 18)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.6), radius: 1, x: 0, y: 1)
                
                HStack(spacing: AdaptiveSize.spacing(8)) {
                    Text("Qty: \(motorcycle.quantity)")
                        .adaptiveFont(.body, size: 14)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.4), radius: 1, x: 0, y: 1)
                    
                    Text("•")
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("$\(String(format: "%.0f", motorcycle.estimatedValue))")
                        .adaptiveFont(.body, size: 14)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.4), radius: 1, x: 0, y: 1)
                }
                
                HStack(spacing: AdaptiveSize.spacing(8)) {
                    Text("\(motorcycle.year)")
                        .adaptiveFont(.caption, size: 12)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                    
                    Text("•")
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text(motorcycle.brand)
                        .adaptiveFont(.caption, size: 12)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                    
                    Text("•")
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text("\(String(format: "%.0f", motorcycle.engineSize))cc")
                        .adaptiveFont(.caption, size: 12)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: AdaptiveSize.spacing(4)) {
                Text(motorcycle.condition.emoji)
                    .font(.system(size: AdaptiveSize.iconSize(16)))
                
                Text(motorcycle.condition.displayName)
                    .adaptiveFont(.caption2, size: 10)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.4), radius: 1, x: 0, y: 1)
            }
        }
        .adaptivePadding(.all, 16)
                        .background(
                            RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(12))
                                .fill(colors.lightCyan.opacity(0.15))
                                .overlay(
                                    RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(12))
                                        .stroke(colors.brightOrange.opacity(0.5), lineWidth: 1)
                                )
                        )
        .onAppear {
            isAnimating = true
        }
    }
}

struct AddMotorcycleView: View {
    let collectionIndex: Int
    let colors: (deepPurple: Color, electricBlue: Color, neonGreen: Color, brightOrange: Color, lightCyan: Color, goldenYellow: Color, steelGray: Color)
    @StateObject private var rideMemory = RideUserMemory.shared
    @Environment(\.presentationMode) var presentationMode
    
    @State private var motorcycleName = ""
    @State private var selectedMotorcycleType = MotorcycleType.sport
    @State private var motorcycleQuantity = 1
    @State private var estimatedValue = 0.0
    @State private var brand = ""
    @State private var year = 2020
    @State private var engineSize = 0.0
    @State private var condition = MotorcycleCondition.excellent
    @State private var notes = ""
    @State private var isAnimating = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            colors.deepPurple,
                            colors.electricBlue,
                            colors.neonGreen.opacity(0.3),
                            colors.brightOrange.opacity(0.2)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    
                    ScrollView {
                        VStack(spacing: AdaptiveSize.spacing(20)) {
                            Text(selectedMotorcycleType.emoji)
                                .font(.system(size: AdaptiveSize.iconSize(60)))
                                .scaleEffect(isAnimating ? 1.1 : 1.0)
                                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
                                .adaptivePadding(.vertical, 20)
                            
                            VStack(spacing: AdaptiveSize.spacing(16)) {
                                VStack(alignment: .leading, spacing: AdaptiveSize.spacing(8)) {
                                    Text("Motorcycle Name")
                                        .adaptiveFont(.headline, size: 16)
                                        .fontWeight(.medium)
                                        .foregroundColor(.white)
                                        .shadow(color: .black.opacity(0.6), radius: 1, x: 0, y: 1)
                                    
                                    TextField("Enter motorcycle name", text: $motorcycleName)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .background(Color.white.opacity(0.9))
                                }
                                
                                VStack(alignment: .leading, spacing: AdaptiveSize.spacing(8)) {
                                    Text("Motorcycle Type")
                                        .adaptiveFont(.headline, size: 16)
                                        .fontWeight(.medium)
                                        .foregroundColor(.white)
                                        .shadow(color: .black.opacity(0.6), radius: 1, x: 0, y: 1)
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: AdaptiveSize.spacing(12)) {
                                            ForEach(MotorcycleType.allCases, id: \.self) { motorcycleType in
                                                Button(action: {
                                                    selectedMotorcycleType = motorcycleType
                                                    brand = motorcycleType.defaultBrand
                                                }) {
                                                    VStack(spacing: AdaptiveSize.spacing(6)) {
                                                        Text(motorcycleType.emoji)
                                                            .font(.system(size: AdaptiveSize.iconSize(30)))
                                                        
                                                        Text(motorcycleType.displayName)
                                                            .adaptiveFont(.caption, size: 12)
                                                            .fontWeight(.medium)
                                                            .foregroundColor(selectedMotorcycleType == motorcycleType ? .white : .primary)
                                                    }
                                                    .frame(width: AdaptiveSize.iconSize(80), height: AdaptiveSize.iconSize(70))
                                                    .background(
                                                        RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(12))
                                                            .fill(selectedMotorcycleType == motorcycleType ?
                                                                  LinearGradient(
                                                                    gradient: Gradient(colors: [colors.brightOrange, colors.neonGreen.opacity(0.8)]),
                                                                    startPoint: .topLeading,
                                                                    endPoint: .bottomTrailing
                                                                  ) :
                                                                  LinearGradient(
                                                                    gradient: Gradient(colors: [colors.lightCyan.opacity(0.2), colors.lightCyan.opacity(0.1)]),
                                                                    startPoint: .topLeading,
                                                                    endPoint: .bottomTrailing
                                                                  )
                                                            )
                                                    )
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(12))
                                                            .stroke(selectedMotorcycleType == motorcycleType ? colors.brightOrange : colors.lightCyan.opacity(0.5), lineWidth: 2)
                                                    )
                                                }
                                            }
                                        }
                                        .adaptivePadding(.horizontal, 20)
                                    }
                                }
                                
                                HStack {
                                    VStack(alignment: .leading, spacing: AdaptiveSize.spacing(8)) {
                                        Text("Quantity")
                                            .adaptiveFont(.headline, size: 16)
                                            .fontWeight(.medium)
                                            .foregroundColor(.white)
                                            .shadow(color: .black.opacity(0.6), radius: 1, x: 0, y: 1)
                                        
                                        Stepper("\(motorcycleQuantity)", value: $motorcycleQuantity, in: 1...1000)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: AdaptiveSize.spacing(8)) {
                                        Text("Value ($)")
                                            .adaptiveFont(.headline, size: 16)
                                            .fontWeight(.medium)
                                            .foregroundColor(.white)
                                            .shadow(color: .black.opacity(0.6), radius: 1, x: 0, y: 1)
                                        
                                        TextField("0", value: $estimatedValue, format: .number)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .keyboardType(.decimalPad)
                                            .background(Color.white.opacity(0.9))
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: AdaptiveSize.spacing(8)) {
                                    Text("Brand")
                                        .adaptiveFont(.headline, size: 16)
                                        .fontWeight(.medium)
                                        .foregroundColor(.white)
                                        .shadow(color: .black.opacity(0.6), radius: 1, x: 0, y: 1)
                                    
                                    TextField("Enter brand", text: $brand)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .background(Color.white.opacity(0.9))
                                        .onAppear {
                                            brand = selectedMotorcycleType.defaultBrand
                                        }
                                }
                                
                                HStack {
                                    VStack(alignment: .leading, spacing: AdaptiveSize.spacing(8)) {
                                        Text("Year")
                                            .adaptiveFont(.headline, size: 16)
                                            .fontWeight(.medium)
                                            .foregroundColor(.white)
                                            .shadow(color: .black.opacity(0.6), radius: 1, x: 0, y: 1)
                                        
                                        Stepper("\(year)", value: $year, in: 1900...2025)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: AdaptiveSize.spacing(8)) {
                                        Text("Engine (cc)")
                                            .adaptiveFont(.headline, size: 16)
                                            .fontWeight(.medium)
                                            .foregroundColor(.white)
                                            .shadow(color: .black.opacity(0.6), radius: 1, x: 0, y: 1)
                                        
                                        TextField("0", value: $engineSize, format: .number)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .keyboardType(.decimalPad)
                                            .background(Color.white.opacity(0.9))
                                    }
                                }
                            }
                            .adaptivePadding(.horizontal, 20)
                            
                            Spacer()
                            
                            Button(action: {
                                let newMotorcycle = Motorcycle(
                                    name: motorcycleName,
                                    emoji: selectedMotorcycleType.emoji,
                                    quantity: motorcycleQuantity,
                                    estimatedValue: estimatedValue,
                                    brand: brand,
                                    year: year,
                                    engineSize: engineSize,
                                    condition: condition,
                                    notes: notes
                                )
                                
                                if let collection = rideMemory.motorcycleCollections.first(where: { $0.id == rideMemory.motorcycleCollections[collectionIndex].id }) {
                                    rideMemory.addMotorcycleToCollection(collectionId: collection.id, motorcycle: newMotorcycle)
                                }
                                
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                HStack {
                                    Text("Add Motorcycle")
                                        .adaptiveFont(.headline, size: 18)
                                        .fontWeight(.semibold)
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: AdaptiveSize.iconSize(18)))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: AdaptiveSize.buttonHeight(50))
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            colors.brightOrange,
                                            colors.neonGreen.opacity(0.8)
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .adaptiveCornerRadius(25)
                            }
                            .disabled(motorcycleName.isEmpty)
                            .opacity(motorcycleName.isEmpty ? 0.6 : 1.0)
                            .adaptivePadding(.horizontal, 20)
                            .adaptivePadding(.bottom, 20)
                        }
                    }
                }
            }
            .navigationTitle("Add Motorcycle")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                                        .foregroundColor(.white)
            )
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        hideKeyboard()
                    }
                }
            }
            .onAppear {
                isAnimating = true
            }
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    BikeView(collectionIndex: 0)
}
