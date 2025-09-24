//
//  RideUserMemory.swift


struct CarCollection: Codable, Identifiable {
    let id: UUID
    var name: String
    var location: String
    var description: String
    var cars: [Car]
    var createdAt: Date
    var updatedAt: Date
    
    init(name: String, location: String, description: String = "") {
        self.id = UUID()
        self.name = name
        self.location = location
        self.description = description
        self.cars = []
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    mutating func addCar(_ car: Car) {
        cars.append(car)
        updatedAt = Date()
    }
    
    mutating func removeCar(_ carId: UUID) {
        cars.removeAll { $0.id == carId }
        updatedAt = Date()
    }
    
    mutating func updateCar(_ car: Car) {
        if let index = cars.firstIndex(where: { $0.id == car.id }) {
            cars[index] = car
            updatedAt = Date()
        }
    }
}

struct Car: Codable, Identifiable {
    let id: UUID
    var name: String
    var emoji: String
    var count: Int
    var estimatedValue: Double
    var brand: String
    var year: Int
    var mileage: Double 
    var condition: CarCondition
    var fuelType: FuelType
    var notes: String
    var createdAt: Date
    var updatedAt: Date
    
    init(name: String, emoji: String, count: Int = 1, estimatedValue: Double = 0.0, brand: String = "", year: Int = 2020, mileage: Double = 0.0, condition: CarCondition = .excellent, fuelType: FuelType = .gasoline, notes: String = "") {
        self.id = UUID()
        self.name = name
        self.emoji = emoji
        self.count = count
        self.estimatedValue = estimatedValue
        self.brand = brand
        self.year = year
        self.mileage = mileage
        self.condition = condition
        self.fuelType = fuelType
        self.notes = notes
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

enum CarCondition: String, Codable, CaseIterable {
    case excellent = "Excellent"
    case good = "Good"
    case fair = "Fair"
    case poor = "Poor"
    case damaged = "Damaged"
    
    var displayName: String {
        switch self {
        case .excellent:
            return "Excellent"
        case .good:
            return "Good"
        case .fair:
            return "Fair"
        case .poor:
            return "Poor"
        case .damaged:
            return "Damaged"
        }
    }
    
    var color: String {
        switch self {
        case .excellent:
            return "#10B981"
        case .good:
            return "#3B82F6"
        case .fair:
            return "#F59E0B"
        case .poor:
            return "#EF4444"
        case .damaged:
            return "#6B7280"
        }
    }
    
    var emoji: String {
        switch self {
        case .excellent:
            return "✨"
        case .good:
            return "👍"
        case .fair:
            return "⚠️"
        case .poor:
            return "🔧"
        case .damaged:
            return "💥"
        }
    }
}

enum FuelType: String, Codable, CaseIterable {
    case gasoline = "Gasoline"
    case diesel = "Diesel"
    case electric = "Electric"
    case hybrid = "Hybrid"
    case other = "Other"
    
    var displayName: String {
        switch self {
        case .gasoline:
            return "Gasoline"
        case .diesel:
            return "Diesel"
        case .electric:
            return "Electric"
        case .hybrid:
            return "Hybrid"
        case .other:
            return "Other"
        }
    }
    
    var emoji: String {
        switch self {
        case .gasoline:
            return "⛽"
        case .diesel:
            return "🛢️"
        case .electric:
            return "🔌"
        case .hybrid:
            return "🔋"
        case .other:
            return "❓"
        }
    }
}

enum CarType: String, Codable, CaseIterable {
    case sedan = "Sedan"
    case suv = "SUV"
    case coupe = "Coupe"
    case convertible = "Convertible"
    case hatchback = "Hatchback"
    case truck = "Truck"
    case sports = "Sports"
    case luxury = "Luxury"
    case other = "Other"
    
    var displayName: String {
        return self.rawValue
    }
    
    var emoji: String {
        switch self {
        case .sedan:
            return "🚗"
        case .suv:
            return "🚙"
        case .coupe:
            return "🏎️"
        case .convertible:
            return "🚗"
        case .hatchback:
            return "🚗"
        case .truck:
            return "🚛"
        case .sports:
            return "🏎️"
        case .luxury:
            return "🚗"
        case .other:
            return "🚗"
        }
    }
    
    var defaultBrand: String {
        switch self {
        case .sedan:
            return "Toyota"
        case .suv:
            return "Honda"
        case .coupe:
            return "BMW"
        case .convertible:
            return "Mazda"
        case .hatchback:
            return "Volkswagen"
        case .truck:
            return "Ford"
        case .sports:
            return "Ferrari"
        case .luxury:
            return "Mercedes-Benz"
        case .other:
            return "Unknown"
        }
    }
}

// MARK: - Motorcycle Collection Models

struct MotorcycleCollection: Codable, Identifiable {
    let id: UUID
    var name: String
    var location: String
    var description: String
    var motorcycles: [Motorcycle]
    var createdAt: Date
    var updatedAt: Date
    
    init(name: String, location: String, description: String = "") {
        self.id = UUID()
        self.name = name
        self.location = location
        self.description = description
        self.motorcycles = []
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    mutating func addMotorcycle(_ motorcycle: Motorcycle) {
        motorcycles.append(motorcycle)
        updatedAt = Date()
    }
    
    mutating func removeMotorcycle(_ motorcycleId: UUID) {
        motorcycles.removeAll { $0.id == motorcycleId }
        updatedAt = Date()
    }
    
    mutating func updateMotorcycle(_ motorcycle: Motorcycle) {
        if let index = motorcycles.firstIndex(where: { $0.id == motorcycle.id }) {
            motorcycles[index] = motorcycle
            updatedAt = Date()
        }
    }
}

struct Motorcycle: Codable, Identifiable {
    let id: UUID
    var name: String
    var emoji: String
    var quantity: Int
    var estimatedValue: Double
    var brand: String
    var year: Int
    var engineSize: Double
    var condition: MotorcycleCondition
    var notes: String
    var createdAt: Date
    var updatedAt: Date
    
    init(name: String, emoji: String, quantity: Int = 1, estimatedValue: Double = 0.0, brand: String = "", year: Int = 2020, engineSize: Double = 0.0, condition: MotorcycleCondition = .excellent, notes: String = "") {
        self.id = UUID()
        self.name = name
        self.emoji = emoji
        self.quantity = quantity
        self.estimatedValue = estimatedValue
        self.brand = brand
        self.year = year
        self.engineSize = engineSize
        self.condition = condition
        self.notes = notes
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

enum MotorcycleCondition: String, Codable, CaseIterable {
    case excellent = "Excellent"
    case good = "Good"
    case fair = "Fair"
    case poor = "Poor"
    case damaged = "Damaged"
    
    var displayName: String {
        switch self {
        case .excellent:
            return "Excellent"
        case .good:
            return "Good"
        case .fair:
            return "Fair"
        case .poor:
            return "Poor"
        case .damaged:
            return "Damaged"
        }
    }
    
    var color: String {
        switch self {
        case .excellent:
            return "#10B981"
        case .good:
            return "#3B82F6"
        case .fair:
            return "#F59E0B"
        case .poor:
            return "#EF4444"
        case .damaged:
            return "#6B7280"
        }
    }
    
    var emoji: String {
        switch self {
        case .excellent:
            return "✨"
        case .good:
            return "👍"
        case .fair:
            return "⚠️"
        case .poor:
            return "🔧"
        case .damaged:
            return "💥"
        }
    }
}

enum MotorcycleType: String, Codable, CaseIterable {
    case sport = "Sport"
    case cruiser = "Cruiser"
    case touring = "Touring"
    case dirt = "Dirt"
    case street = "Street"
    case chopper = "Chopper"
    case scooter = "Scooter"
    case adventure = "Adventure"
    case other = "Other"
    
    var displayName: String {
        return self.rawValue
    }
    
    var emoji: String {
        switch self {
        case .sport:
            return "🏎️"
        case .cruiser:
            return "🏍️"
        case .touring:
            return "🛣️"
        case .dirt:
            return "🏔️"
        case .street:
            return "🏙️"
        case .chopper:
            return "🔥"
        case .scooter:
            return "🛵"
        case .adventure:
            return "🌍"
        case .other:
            return "🏍️"
        }
    }
    
    var defaultBrand: String {
        switch self {
        case .sport:
            return "Yamaha"
        case .cruiser:
            return "Harley-Davidson"
        case .touring:
            return "Honda"
        case .dirt:
            return "KTM"
        case .street:
            return "Kawasaki"
        case .chopper:
            return "Custom"
        case .scooter:
            return "Vespa"
        case .adventure:
            return "BMW"
        case .other:
            return "Unknown"
        }
    }
}

import Foundation
import SwiftUI

class RideUserMemory: ObservableObject {
    
    static let shared = RideUserMemory()
    
    private let defaults = UserDefaults.standard
    private let carCollectionsKey = "carCollections"
    private let motorcycleCollectionsKey = "motorcycleCollections"
    private let onboardingCompletedKey = "onboardingCompleted"

    private init() {
        self.hasCompletedOnboarding = defaults.bool(forKey: onboardingCompletedKey)
        self.loadCarCollections()
        self.loadMotorcycleCollections()
    }
    
    
    @Published private(set) var carCollections: [CarCollection] = [] {
        didSet {
            saveCarCollections()
        }
    }
    
    @Published private(set) var motorcycleCollections: [MotorcycleCollection] = [] {
        didSet {
            saveMotorcycleCollections()
        }
    }
   
    @Published var hasCompletedOnboarding: Bool = false {
        didSet {
            defaults.set(hasCompletedOnboarding, forKey: onboardingCompletedKey)
        }
    }
    
    private func loadCarCollections() {
        if let data = defaults.data(forKey: carCollectionsKey) {
            let decoder = JSONDecoder()
            if let loadedCollections = try? decoder.decode([CarCollection].self, from: data) {
                self.carCollections = loadedCollections
            }
        } else {
            self.carCollections = []
        }
    }
    
    private func saveCarCollections() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(carCollections) {
            defaults.set(encoded, forKey: carCollectionsKey)
        }
    }
    
    private func loadMotorcycleCollections() {
        if let data = defaults.data(forKey: motorcycleCollectionsKey) {
            let decoder = JSONDecoder()
            if let loadedCollections = try? decoder.decode([MotorcycleCollection].self, from: data) {
                self.motorcycleCollections = loadedCollections
            }
        } else {
            self.motorcycleCollections = []
        }
    }
    
    private func saveMotorcycleCollections() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(motorcycleCollections) {
            defaults.set(encoded, forKey: motorcycleCollectionsKey)
        }
    }
    
    func addCarCollection(_ collection: CarCollection) {
        carCollections.append(collection)
    }
    
    func updateCarCollection(_ collection: CarCollection) {
        if let index = carCollections.firstIndex(where: { $0.id == collection.id }) {
            carCollections[index] = collection
        }
    }
    
    func deleteCarCollection(_ collectionId: UUID) {
        carCollections.removeAll { $0.id == collectionId }
    }
    
    func getCarCollection(by id: UUID) -> CarCollection? {
        return carCollections.first { $0.id == id }
    }
    
    
    func addMotorcycleCollection(_ collection: MotorcycleCollection) {
        motorcycleCollections.append(collection)
    }
    
    func updateMotorcycleCollection(_ collection: MotorcycleCollection) {
        if let index = motorcycleCollections.firstIndex(where: { $0.id == collection.id }) {
            motorcycleCollections[index] = collection
        }
    }
    
    func deleteMotorcycleCollection(_ collectionId: UUID) {
        motorcycleCollections.removeAll { $0.id == collectionId }
    }
    
    func getMotorcycleCollection(by id: UUID) -> MotorcycleCollection? {
        return motorcycleCollections.first { $0.id == id }
    }
    
    
    func addCarToCollection(collectionId: UUID, car: Car) {
        if let index = carCollections.firstIndex(where: { $0.id == collectionId }) {
            carCollections[index].addCar(car)
        }
    }
    
    func updateCarInCollection(collectionId: UUID, car: Car) {
        if let index = carCollections.firstIndex(where: { $0.id == collectionId }) {
            carCollections[index].updateCar(car)
        }
    }
    
    func removeCarFromCollection(collectionId: UUID, carId: UUID) {
        if let index = carCollections.firstIndex(where: { $0.id == collectionId }) {
            carCollections[index].removeCar(carId)
        }
    }
    
    func getCarsFromCollection(collectionId: UUID) -> [Car] {
        return carCollections.first { $0.id == collectionId }?.cars ?? []
    }
    
    
    func addMotorcycleToCollection(collectionId: UUID, motorcycle: Motorcycle) {
        if let index = motorcycleCollections.firstIndex(where: { $0.id == collectionId }) {
            motorcycleCollections[index].addMotorcycle(motorcycle)
        }
    }
    
    func updateMotorcycleInCollection(collectionId: UUID, motorcycle: Motorcycle) {
        if let index = motorcycleCollections.firstIndex(where: { $0.id == collectionId }) {
            motorcycleCollections[index].updateMotorcycle(motorcycle)
        }
    }
    
    func removeMotorcycleFromCollection(collectionId: UUID, motorcycleId: UUID) {
        if let index = motorcycleCollections.firstIndex(where: { $0.id == collectionId }) {
            motorcycleCollections[index].removeMotorcycle(motorcycleId)
        }
    }
    
    func getMotorcyclesFromCollection(collectionId: UUID) -> [Motorcycle] {
        return motorcycleCollections.first { $0.id == collectionId }?.motorcycles ?? []
    }
    
    func getMotorcyclesByType(_ type: MotorcycleType) -> [Motorcycle] {
        return motorcycleCollections.flatMap { $0.motorcycles }.filter { motorcycle in
            MotorcycleType.allCases.contains { $0.emoji == motorcycle.emoji }
        }
    }
    
    func getMotorcyclesByCondition(_ condition: MotorcycleCondition) -> [Motorcycle] {
        return motorcycleCollections.flatMap { $0.motorcycles }.filter { $0.condition == condition }
    }
    
    func getCarsByType(_ type: CarType) -> [Car] {
        return carCollections.flatMap { $0.cars }.filter { car in
            CarType.allCases.contains { $0.emoji == car.emoji }
        }
    }
    
    func getCarsByCondition(_ condition: CarCondition) -> [Car] {
        return carCollections.flatMap { $0.cars }.filter { $0.condition == condition }
    }
    
    func getTotalCarCount() -> Int {
        return carCollections.flatMap { $0.cars }.reduce(0) { $0 + $1.count }
    }
    
    func getTotalCarValue() -> Double {
        return carCollections.flatMap { $0.cars }.reduce(0) { $0 + ($1.estimatedValue * Double($1.count)) }
    }
    
    func getCarCollectionStatistics(collectionId: UUID) -> [String: Any] {
        guard let collection = getCarCollection(by: collectionId) else { return [:] }
        
        let totalCars = collection.cars.reduce(0) { $0 + $1.count }
        let totalValue = collection.cars.reduce(0) { $0 + ($1.estimatedValue * Double($1.count)) }
        let excellentCars = collection.cars.filter { $0.condition == .excellent }.reduce(0) { $0 + $1.count }
        let goodCars = collection.cars.filter { $0.condition == .good }.reduce(0) { $0 + $1.count }
        
        return [
            "totalCars": totalCars,
            "totalValue": totalValue,
            "excellentCars": excellentCars,
            "goodCars": goodCars,
            "carTypes": Set(collection.cars.map { $0.emoji }).count
        ]
    }
    
    func getGlobalCarStatistics() -> [String: Any] {
        let allCars = carCollections.flatMap { $0.cars }
        let totalCars = allCars.reduce(0) { $0 + $1.count }
        let totalValue = allCars.reduce(0) { $0 + ($1.estimatedValue * Double($1.count)) }
        let excellentCars = allCars.filter { $0.condition == .excellent }.reduce(0) { $0 + $1.count }
        
        return [
            "totalCollections": carCollections.count,
            "totalCars": totalCars,
            "totalValue": totalValue,
            "excellentCars": excellentCars,
            "averageCarsPerCollection": carCollections.isEmpty ? 0 : totalCars / carCollections.count
        ]
    }
    
    
    func getTotalMotorcycleCount() -> Int {
        return motorcycleCollections.flatMap { $0.motorcycles }.reduce(0) { $0 + $1.quantity }
    }
    
    func getTotalMotorcycleValue() -> Double {
        return motorcycleCollections.flatMap { $0.motorcycles }.reduce(0) { $0 + ($1.estimatedValue * Double($1.quantity)) }
    }
    
    func getMotorcycleCollectionStatistics(collectionId: UUID) -> [String: Any] {
        guard let collection = getMotorcycleCollection(by: collectionId) else { return [:] }
        
        let totalMotorcycles = collection.motorcycles.reduce(0) { $0 + $1.quantity }
        let totalValue = collection.motorcycles.reduce(0) { $0 + ($1.estimatedValue * Double($1.quantity)) }
        let excellentMotorcycles = collection.motorcycles.filter { $0.condition == .excellent }.reduce(0) { $0 + $1.quantity }
        let goodMotorcycles = collection.motorcycles.filter { $0.condition == .good }.reduce(0) { $0 + $1.quantity }
        
        return [
            "totalMotorcycles": totalMotorcycles,
            "totalValue": totalValue,
            "excellentMotorcycles": excellentMotorcycles,
            "goodMotorcycles": goodMotorcycles,
            "motorcycleTypes": Set(collection.motorcycles.map { $0.emoji }).count
        ]
    }
    
    func getGlobalMotorcycleStatistics() -> [String: Any] {
        let allMotorcycles = motorcycleCollections.flatMap { $0.motorcycles }
        let totalMotorcycles = allMotorcycles.reduce(0) { $0 + $1.quantity }
        let totalValue = allMotorcycles.reduce(0) { $0 + ($1.estimatedValue * Double($1.quantity)) }
        let excellentMotorcycles = allMotorcycles.filter { $0.condition == .excellent }.reduce(0) { $0 + $1.quantity }
        
        return [
            "totalCollections": motorcycleCollections.count,
            "totalMotorcycles": totalMotorcycles,
            "totalValue": totalValue,
            "excellentMotorcycles": excellentMotorcycles,
            "averageMotorcyclesPerCollection": motorcycleCollections.isEmpty ? 0 : totalMotorcycles / motorcycleCollections.count
        ]
    }
    
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
    }
    
    func resetOnboarding() {
        hasCompletedOnboarding = false
    }

}
