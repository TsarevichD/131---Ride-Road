//
//  CarsView.swift

import SwiftUI

struct CarsView: View {
    let collectionIndex: Int
    @StateObject private var rideMemory = RideUserMemory.shared
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appState: AppState
    @State private var isAnimating = false
    @State private var showingAddCar = false
    @State private var newCarName = ""
    @State private var selectedCarType = CarType.sedan
    @State private var carCount = 1
    @State private var estimatedValue = 0.0
    @State private var brand = ""
    @State private var year = 2020
    @State private var mileage = 0.0
    @State private var condition = CarCondition.excellent
    @State private var fuelType = FuelType.gasoline
    @State private var notes = ""

    private var collection: CarCollection? {
        guard collectionIndex < rideMemory.carCollections.count else { return nil }
        return rideMemory.carCollections[collectionIndex]
    }
    
    private let colors = (
        deepBlue: Color(hex: "#1e3a8a"),
        steelBlue: Color(hex: "#475569"),
        lightBlue: Color(hex: "#e0f2fe"),
        darkBlue: Color(hex: "#1e40af"),
        goldenYellow: Color(hex: "#deb85b"),
        emeraldGreen: Color(hex: "#10b981"),
        slateGray: Color(hex: "#64748b")
    )
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            colors.deepBlue,
                            colors.darkBlue,
                            colors.steelBlue,
                            colors.slateGray
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                    
                    VStack(spacing: AdaptiveSize.spacing(20)) {
                        VStack(spacing: AdaptiveSize.spacing(10)) {
                            Text(collection?.name ?? "Car Collection")
                                .adaptiveFont(.largeTitle, size: 28)
                                .fontWeight(.bold)
                                .foregroundColor(colors.lightBlue)
                                .shadow(color: colors.deepBlue.opacity(0.3), radius: 2, x: 0, y: 1)
                            
                            HStack(spacing: AdaptiveSize.spacing(8)) {
                                Image(systemName: "location.fill")
                                    .font(.system(size: AdaptiveSize.iconSize(14)))
                                    .foregroundColor(colors.lightBlue.opacity(0.8))
                                
                                Text(collection?.location ?? "Unknown Location")
                                    .adaptiveFont(.title3, size: 16)
                                    .fontWeight(.medium)
                                    .foregroundColor(colors.lightBlue.opacity(0.9))
                            }
                        }
                        .adaptivePadding(.top, 20)
                        
                        HStack(spacing: AdaptiveSize.spacing(30)) {
                            VStack(spacing: AdaptiveSize.spacing(4)) {
                                Text("\(collection?.cars.count ?? 0)")
                                    .adaptiveFont(.title, size: 24)
                                    .fontWeight(.bold)
                                    .foregroundColor(colors.lightBlue)
                                
                                Text("Cars")
                                    .adaptiveFont(.caption, size: 12)
                                    .fontWeight(.medium)
                                    .foregroundColor(colors.lightBlue.opacity(0.8))
                            }
                            
                            VStack(spacing: AdaptiveSize.spacing(4)) {
                                Text("$\(String(format: "%.0f", collectionTotalValue))")
                                    .adaptiveFont(.title, size: 24)
                                    .fontWeight(.bold)
                                    .foregroundColor(colors.lightBlue)
                                
                                Text("Total Value")
                                    .adaptiveFont(.caption, size: 12)
                                    .fontWeight(.medium)
                                    .foregroundColor(colors.lightBlue.opacity(0.8))
                            }
                        }
                        .adaptivePadding(.vertical, 20)
                        .adaptivePadding(.horizontal, 30)
                        .background(
                            RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(15))
                                .fill(colors.lightBlue.opacity(0.2))
                                .overlay(
                                    RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(15))
                                        .stroke(colors.emeraldGreen.opacity(0.5), lineWidth: 2)
                                )
                        )
                        
                        if collection?.cars.isEmpty == true {
                            VStack(spacing: AdaptiveSize.spacing(20)) {
                                Text("🚗")
                                    .font(.system(size: AdaptiveSize.iconSize(60)))
                                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
                                
                                Text("No Cars Yet")
                                    .adaptiveFont(.title2, size: 20)
                                    .fontWeight(.bold)
                                    .foregroundColor(colors.lightBlue)
                                
                                Text("Add your first car to get started")
                                    .adaptiveFont(.body, size: 16)
                                    .foregroundColor(colors.lightBlue.opacity(0.8))
                                    .multilineTextAlignment(.center)
                            }
                            .adaptivePadding(.top, 50)
                        } else {
                            ScrollView {
                                LazyVStack(spacing: AdaptiveSize.spacing(12)) {
                                    ForEach(collection?.cars ?? []) { car in
                                        CarCardView(car: car, colors: colors)
                                    }
                                }
                                .adaptivePadding(.horizontal, 20)
                            }
                        }
                        
                        Spacer()
                    }
                }
            }
            .navigationTitle("Cars")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        appState.currentScreen = .dream
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.left.circle.fill")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Back")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(colors.lightBlue)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(colors.steelBlue.opacity(0.2))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(colors.steelBlue.opacity(0.6), lineWidth: 1)
                                )
                        )
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddCar = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(colors.lightBlue)
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            isAnimating = true
        }
        .sheet(isPresented: $showingAddCar) {
            AddCarView(collectionIndex: collectionIndex, colors: colors)
        }
    }
    
    private var collectionTotalValue: Double {
        return collection?.cars.reduce(0) { $0 + ($1.estimatedValue * Double($1.count)) } ?? 0
    }
}

struct CarCardView: View {
    let car: Car
    let colors: (deepBlue: Color, steelBlue: Color, lightBlue: Color, darkBlue: Color, goldenYellow: Color, emeraldGreen: Color, slateGray: Color)
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: AdaptiveSize.spacing(15)) {
            Text(car.emoji)
                .font(.system(size: AdaptiveSize.iconSize(30)))
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
            
            VStack(alignment: .leading, spacing: AdaptiveSize.spacing(4)) {
                Text(car.name)
                    .adaptiveFont(.title3, size: 18)
                    .fontWeight(.bold)
                                        .foregroundColor(colors.lightBlue)
                
                HStack(spacing: AdaptiveSize.spacing(8)) {
                    Text("Count: \(car.count)")
                        .adaptiveFont(.body, size: 14)
                        .foregroundColor(colors.lightBlue.opacity(0.8))
                    
                    Text("•")
                        .foregroundColor(colors.lightBlue.opacity(0.6))
                    
                    Text("$\(String(format: "%.0f", car.estimatedValue))")
                        .adaptiveFont(.body, size: 14)
                        .fontWeight(.semibold)
                        .foregroundColor(colors.lightBlue.opacity(0.9))
                }
                
                HStack(spacing: AdaptiveSize.spacing(8)) {
                    Text("\(car.year)")
                        .adaptiveFont(.caption, size: 12)
                        .foregroundColor(colors.lightBlue.opacity(0.7))
                    
                    Text("•")
                        .foregroundColor(colors.lightBlue.opacity(0.6))
                    
                    Text(car.brand)
                        .adaptiveFont(.caption, size: 12)
                        .foregroundColor(colors.lightBlue.opacity(0.7))
                    
                    Text("•")
                        .foregroundColor(colors.lightBlue.opacity(0.6))
                    
                    Text("\(String(format: "%.0f", car.mileage)) km")
                        .adaptiveFont(.caption, size: 12)
                        .foregroundColor(colors.lightBlue.opacity(0.7))
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: AdaptiveSize.spacing(4)) {
                Text(car.condition.emoji)
                    .font(.system(size: AdaptiveSize.iconSize(16)))
                
                Text(car.condition.displayName)
                    .adaptiveFont(.caption2, size: 10)
                    .fontWeight(.medium)
                    .foregroundColor(colors.lightBlue.opacity(0.8))
            }
        }
        .adaptivePadding(.all,16)
                        .background(
                            RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(12))
                                .fill(colors.lightBlue.opacity(0.15))
                                .overlay(
                                    RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(12))
                                        .stroke(colors.emeraldGreen.opacity(0.4), lineWidth: 1)
                                )
                        )
        .onAppear {
            isAnimating = true
        }
    }
}

struct AddCarView: View {
    let collectionIndex: Int
    let colors: (deepBlue: Color, steelBlue: Color, lightBlue: Color, darkBlue: Color, goldenYellow: Color, emeraldGreen: Color, slateGray: Color)
    @StateObject private var rideMemory = RideUserMemory.shared
    @Environment(\.presentationMode) var presentationMode
    
    @State private var carName = ""
    @State private var selectedCarType = CarType.sedan
    @State private var carCount = 1
    @State private var estimatedValue = 0.0
    @State private var brand = ""
    @State private var year = 2020
    @State private var mileage = 0.0
    @State private var condition = CarCondition.excellent
    @State private var fuelType = FuelType.gasoline
    @State private var notes = ""
    @State private var isAnimating = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            colors.deepBlue,
                            colors.darkBlue,
                            colors.steelBlue,
                            colors.slateGray
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    
                    ScrollView {
                        VStack(spacing: AdaptiveSize.spacing(20)) {
                            Text(selectedCarType.emoji)
                                .font(.system(size: AdaptiveSize.iconSize(60)))
                                .scaleEffect(isAnimating ? 1.1 : 1.0)
                                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
                                .adaptivePadding(.vertical, 20)
                            
                            VStack(spacing: AdaptiveSize.spacing(16)) {
                                VStack(alignment: .leading, spacing: AdaptiveSize.spacing(8)) {
                                    Text("Car Name")
                                        .adaptiveFont(.headline, size: 16)
                                        .fontWeight(.medium)
                                        .foregroundColor(colors.lightBlue)
                                    
                                    TextField("Enter car name", text: $carName)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .background(Color.white.opacity(0.9))
                                }
                                
                                VStack(alignment: .leading, spacing: AdaptiveSize.spacing(8)) {
                                    Text("Car Type")
                                        .adaptiveFont(.headline, size: 16)
                                        .fontWeight(.medium)
                                        .foregroundColor(colors.lightBlue)
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: AdaptiveSize.spacing(12)) {
                                            ForEach(CarType.allCases, id: \.self) { carType in
                                                Button(action: {
                                                    selectedCarType = carType
                                                    brand = carType.defaultBrand
                                                }) {
                                                    VStack(spacing: AdaptiveSize.spacing(6)) {
                                                        Text(carType.emoji)
                                                            .font(.system(size: AdaptiveSize.iconSize(30)))
                                                        
                                                        Text(carType.displayName)
                                                            .adaptiveFont(.caption, size: 12)
                                                            .fontWeight(.medium)
                                                            .foregroundColor(selectedCarType == carType ? .white : .primary)
                                                    }
                                                    .frame(width: AdaptiveSize.iconSize(80), height: AdaptiveSize.iconSize(70))
                                                    .background(
                                                        RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(12))
                                                            .fill(selectedCarType == carType ?
                                                                  LinearGradient(
                                                                    gradient: Gradient(colors: [colors.goldenYellow, colors.emeraldGreen.opacity(0.8)]),
                                                                    startPoint: .topLeading,
                                                                    endPoint: .bottomTrailing
                                                                  ) :
                                                                  LinearGradient(
                                                                    gradient: Gradient(colors: [colors.lightBlue.opacity(0.2), colors.lightBlue.opacity(0.1)]),
                                                                    startPoint: .topLeading,
                                                                    endPoint: .bottomTrailing
                                                                  )
                                                            )
                                                    )
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(12))
                                                            .stroke(selectedCarType == carType ? colors.goldenYellow : colors.lightBlue.opacity(0.5), lineWidth: 2)
                                                    )
                                                }
                                            }
                                        }
                                        .adaptivePadding(.horizontal, 20)
                                    }
                                }
                                
                                HStack {
                                    VStack(alignment: .leading, spacing: AdaptiveSize.spacing(8)) {
                                        Text("Count")
                                            .adaptiveFont(.headline, size: 16)
                                            .fontWeight(.medium)
                                            .foregroundColor(colors.lightBlue)
                                        
                                        Stepper("\(carCount)", value: $carCount, in: 1...1000)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: AdaptiveSize.spacing(8)) {
                                        Text("Value ($)")
                                            .adaptiveFont(.headline, size: 16)
                                            .fontWeight(.medium)
                                            .foregroundColor(colors.lightBlue)
                                        
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
                                        .foregroundColor(colors.lightBlue)
                                    
                                    TextField("Enter brand", text: $brand)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .background(Color.white.opacity(0.9))
                                        .onAppear {
                                            brand = selectedCarType.defaultBrand
                                        }
                                }
                                
                                HStack {
                                    VStack(alignment: .leading, spacing: AdaptiveSize.spacing(8)) {
                                        Text("Year")
                                            .adaptiveFont(.headline, size: 16)
                                            .fontWeight(.medium)
                                            .foregroundColor(colors.lightBlue)
                                        
                                        Stepper("\(year)", value: $year, in: 1900...2025)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: AdaptiveSize.spacing(8)) {
                                        Text("Mileage (km)")
                                            .adaptiveFont(.headline, size: 16)
                                            .fontWeight(.medium)
                                            .foregroundColor(colors.lightBlue)
                                        
                                        TextField("0", value: $mileage, format: .number)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .keyboardType(.decimalPad)
                                            .background(Color.white.opacity(0.9))
                                    }
                                }
                            }
                            .adaptivePadding(.horizontal, 20)
                            
                            Spacer()
                            
                            Button(action: {
                                let newCar = Car(
                                    name: carName,
                                    emoji: selectedCarType.emoji,
                                    count: carCount,
                                    estimatedValue: estimatedValue,
                                    brand: brand,
                                    year: year,
                                    mileage: mileage,
                                    condition: condition,
                                    fuelType: fuelType,
                                    notes: notes
                                )
                                
                                if let collection = rideMemory.carCollections.first(where: { $0.id == rideMemory.carCollections[collectionIndex].id }) {
                                    rideMemory.addCarToCollection(collectionId: collection.id, car: newCar)
                                }
                                
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                HStack {
                                    Text("Add Car")
                                        .adaptiveFont(.headline, size: 18)
                                        .fontWeight(.semibold)
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: AdaptiveSize.iconSize(18)))
                                }
                                .foregroundColor(colors.lightBlue)
                                .frame(maxWidth: .infinity)
                                .frame(height: AdaptiveSize.buttonHeight(50))
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            colors.goldenYellow,
                                            colors.emeraldGreen.opacity(0.8)
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .adaptiveCornerRadius(25)
                            }
                            .disabled(carName.isEmpty)
                            .opacity(carName.isEmpty ? 0.6 : 1.0)
                            .adaptivePadding(.horizontal, 20)
                            .adaptivePadding(.bottom, 20)
                        }
                    }
                }
            }
            .navigationTitle("Add Car")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                                        .foregroundColor(colors.lightBlue)
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
    CarsView(collectionIndex: 0)
}
