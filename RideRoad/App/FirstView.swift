//
//  FirstView.swift

import SwiftUI

enum AppScreen {
    case onboarding1
    case onboarding2
    case onboarding3
    case home
    case dream
    case cars
    case speed
    case bike
    case profile
    case info
    case analiz
    case achiv
}

class AppState: ObservableObject {
    @Published var currentScreen: AppScreen = .onboarding1
    @Published var selectedCarsIndex: Int = 0
    @Published var selectedBikesIndex: Int = 0
}


struct FirstView: View {
    @StateObject var appState = AppState()
    @StateObject private var rideManager = RideUserMemory.shared
    
    var body: some View {
        Group {
            if rideManager.hasCompletedOnboarding {
                switch appState.currentScreen {
                case .home:
                    MainView().environmentObject(appState)
                case .dream:
                    DreamsView().environmentObject(appState)
                case .cars:
                    CarsView(collectionIndex: appState.selectedCarsIndex).environmentObject(appState)
                case .profile:
                    ProfileView().environmentObject(appState)
                case .info:
                    InfoView().environmentObject(appState)
                case .achiv:
                    AchivView().environmentObject(appState)
                case .analiz:
                    AnalizView().environmentObject(appState)
                case .speed:
                    SpeedView().environmentObject(appState)
                case .bike:
                    BikeView(collectionIndex: appState.selectedBikesIndex).environmentObject(appState)
                default:
                    MainView().environmentObject(appState)
                }
            } else {
                switch appState.currentScreen {
                case .onboarding1:
                    StartOnboardOne().environmentObject(appState)
                case .onboarding2:
                    StartOnboardTwo().environmentObject(appState)
                default:
                    StartOnboardOne().environmentObject(appState)
                }
            }
        }
        .onAppear {
            if rideManager.hasCompletedOnboarding {
                appState.currentScreen = .home
            } else {
                appState.currentScreen = .onboarding1
            }
        }
    }
}

