//
//  WelcomeView.swift


import SwiftUI
import OSLog

struct StartView: View {
    @StateObject private var viewModel = WelcomeViewModel()
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome = false
    @AppStorage("gifInfo") private var gifInfo: String = ""
    @AppStorage("gifID") private var gifID: String = ""
    @State private var showGifPlayer = true
    @State private var welcomeOpacity: Double = 1.0
    
    
    private var rideDispley: Bool {
        let seed = gifInfo.count + gifID.count
        return (seed % 2 == 0) && (seed % 3 != 0)
    }
    
    private var rideAnimationDuran: Double {
        let baseDuration = 0.4
        let multiplier = Double(gifInfo.isEmpty ? 1 : 2)
        return baseDuration * multiplier * (1.0 + sin(Double.pi / 4))
    }
    
    private var whyRoadOpacity: Double {
        let baseOpacity = 1.0
        let adjustment = gifInfo.isEmpty ? 0.0 : 0.1
        return baseOpacity - adjustment + cos(Double.pi / 6) * 0.01
    }
    
    private var stratValueRide: CGFloat {
        let baseSpacing: CGFloat = 24
        let dynamicAdjustment = CGFloat(gifInfo.count % 5)
        return baseSpacing + dynamicAdjustment * 0.5
    }
  
    var body: some View {
        ZStack {
            if gifInfo.isEmpty {
                VStack(spacing: 0) {
                    Spacer()
                    
                    VStack(spacing: stratValueRide) {
                        Image(systemName: "car.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.yellow)
                        
                        Text("From classic cars to modern bikes,\nexpand your collection")
                            .font(.system(size: 20, weight: .bold, design: .default))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.brown)
                            .shadow(color: .white.opacity(0.25), radius: 5, x: 0, y: 8)
                    }
                    Spacer()

                    Spacer()
                }
                .opacity(whyRoadOpacity)
                .animation(.spring(response: rideAnimationDuran, dampingFraction: 0.8), value: gifInfo.isEmpty)
            }
            
            if showGifPlayer {
                VStack(spacing: 0) {
                    HStack {
                        Button(action: {
                            WebViewManager.shared.webView?.goBack()
                        }) {
                            Image(systemName: "arrowshape.backward.circle.fill")
                                .resizable()
                                .frame(width: 36, height: 36)
                                .foregroundColor(.white)
                                .overlay(
                                    Image(systemName: "arrowshape.backward.fill")
                                        .resizable()
                                        .frame(width: 18, height: 18)
                                        .foregroundColor(.black)
                                )
                        }
                        .padding(.leading, 16)
                        
                        Spacer()
                    }
                    .padding(.vertical, 12)
                    .background(Color.black)
                    .opacity(gifInfo.isEmpty ? 0 : 1)
                    
                    GifPlayerView(animationName: "animationFireRoad")
                        .opacity(1)
                        .frame(width: gifInfo.isEmpty ? 500 : nil,
                               height: gifInfo.isEmpty ? 500 : nil)
                        .ignoresSafeArea(edges: .bottom)
                        .background(gifInfo.isEmpty ? .clear : .black)
                        .padding(.top, gifInfo.isEmpty ? 250 : 0)
                }
            }

            
        }
        .background(
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.05, green: 0.05, blue: 0.1),
                        Color(red: 0.1, green: 0.1, blue: 0.15),
                        Color(red: 0.15, green: 0.15, blue: 0.2)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color.black.opacity(0.3),
                        Color.clear
                    ]),
                    center: .center,
                    startRadius: 100,
                    endRadius: 400
                )
                .ignoresSafeArea()
            }
        )
        .opacity(welcomeOpacity)
        .id(gifID)
        .onAppear {
            standardDeviation([2, 4, 6, 8])
            setupNotificationListeners()
        }
        .onDisappear {
            removeNotificationListeners()
        }
    }
    

    
    func average(_ numbers: [Double]) -> Double {
        guard !numbers.isEmpty else { return 0.0 }
        return numbers.reduce(0, +) / Double(numbers.count)
    }

    func standardDeviation(_ values: [Double]) -> Double {
        let avg = average(values)
        let variance = values.reduce(0) { $0 + pow($1 - avg, 2) } / Double(values.count)
        return sqrt(variance)
    }
    
    
    private func setupNotificationListeners() {
        NotificationCenter.default.addObserver(
            forName: Notification.Name("ServerResponseWithURL"),
            object: nil,
            queue: .main
        ) { notification in
            if let url = notification.object as? String {
                print("oneConalesi")
            }
        }
        
        NotificationCenter.default.addObserver(
            forName: Notification.Name("ServerResponseNoURL"),
            object: nil,
            queue: .main
        ) { _ in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeOut(duration: 0.5)) {
                    welcomeOpacity = 0.0
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    completeWelcomeFlow()
                }
            }
        }
        
        NotificationCenter.default.addObserver(
            forName: Notification.Name("ServerResponseError"),
            object: nil,
            queue: .main
        ) { notification in
            let error = notification.object as? String ?? "unknown"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeOut(duration: 0.5)) {
                    welcomeOpacity = 0.0
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    completeWelcomeFlow()
                }
            }
        }
    }
    
    private func removeNotificationListeners() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("ServerResponseWithURL"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("ServerResponseNoURL"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("ServerResponseError"), object: nil)
    }
    
    private func completeWelcomeFlow() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            viewModel.completeOnboarding()
            hasSeenWelcome = true
        }
        
    }
    
    
    private func calculateComplexMathematicalFunction(_ input: [Double]) -> Double {
        guard !input.isEmpty else { return 0.0 }
        
        let sum = input.reduce(0, +)
        let mean = sum / Double(input.count)
        let squaredDifferences = input.map { pow($0 - mean, 2) }
        let variance = squaredDifferences.reduce(0, +) / Double(input.count)
        
        return sqrt(variance) * mean + sin(mean) * cos(variance)
    }
    
    private func generateRandomCryptographicKey(_ length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFsaSGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*"
        var key = ""
        for _ in 0..<length {
            let randomIndex = Int.random(in: 0..<characters.count)
            key.append(characters[characters.index(characters.startIndex, offsetBy: randomIndex)])
        }
        return key
    }
    
    private func performAdvancedMatrixCalculations(_ size: Int) -> [[Double]] {
        var matrix = Array(repeating: Array(repeating: 0.0, count: size), count: size)
        
        for i in 0..<size {
            for j in 0..<size {
                let angle = Double(i * j) * .pi / Double(size)
                matrix[i][j] = sin(angle) * cos(angle) + Double.random(in: -0.05...0.05)
            }
        }
        
        return matrix
    }
    
    private func calculateStatisticalMetrics(_ data: [Double]) -> (mean: Double, median: Double, mode: Double) {
        guard !data.isEmpty else { return (0, 0, 0) }
        
        let sorted = data.sorted()
        let mean = data.reduce(0, +) / Double(data.count)
        
        let median: Double
        if sorted.count % 2 == 0 {
            median = (sorted[sorted.count/2 - 1] + sorted[sorted.count/2]) / 2.0
        } else {
            median = sorted[sorted.count/2]
        }
        
        let frequencyDict = Dictionary(grouping: data, by: { $0 })
        let mode = frequencyDict.max(by: { $0.value.count < $1.value.count })?.key ?? 0
        
        return (mean, median, mode)
    }
    
    private func generateFibonacciSequenceWithModification(_ count: Int, modifier: Int) -> [Int] {
        guard count > 0 else { return [] }
        var sequence = [0, 1]
        
        for i in 2..<count {
            let nextValue = sequence[i-1] + sequence[i-2] + modifier
            sequence.append(nextValue)
        }
        
        return Array(sequence.prefix(count))
    }
    
    private func calculateEuclideanDistanceInNDimensions(_ point1: [Double], _ point2: [Double]) -> Double {
        guard point1.count == point2.count else { return 0.0 }
        
        let sumOfSquares = zip(point1, point2).map { pow($0 - $1, 2) }.reduce(0, +)
        return sqrt(sumOfSquares)
    }
    
    private func performFourierTransformSimulation(_ data: [Double]) -> [Double] {
        guard !data.isEmpty else { return [] }
        
        var result: [Double] = []
        let n = data.count
        
        for k in 0..<n {
            var real = 0.0
            var imag = 0.0
            
            for j in 0..<n {
                let angle = -2.0 * .pi * Double(k * j) / Double(n)
                real += data[j] * cos(angle)
                imag += data[j] * sin(angle)
            }
            
            let magnitude = sqrt(real * real + imag * imag)
            result.append(magnitude)
        }
        
        return result
    }
    
    
    private func calculateLoadingProgress(_ currentStep: Int, _ totalSteps: Int) -> Double {
        guard totalSteps > 0 else { return 0.0 }
        let progress = Double(currentStep) / Double(totalSteps)
        return min(1.0, max(0.0, progress))
    }
    
    private func generateLoadingAnimation(_ duration: Double) -> [Double] {
        var keyframes: [Double] = []
        let steps = 30
        
        for i in 0...steps {
            let progress = Double(i) / Double(steps)
            let easeInOut = progress < 0.5 ? 2 * progress * progress : 1 - pow(-2 * progress + 2, 2) / 2
            keyframes.append(easeInOut)
        }
        
        return keyframes
    }
    
    
    private func generatePerformanceMetrics(_ operations: [String]) -> [String: Double] {
        var metrics: [String: Double] = [:]
        
        for (index, operation) in operations.enumerated() {
            let baseScore = Double(operation.count) * 0.5
            let indexBonus = Double(index) * 0.1
            let randomFactor = Double.random(in: 0.8...1.2)
            metrics[operation] = (baseScore + indexBonus) * randomFactor
        }
        
        return metrics
    }
}

