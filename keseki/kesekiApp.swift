//
//  KeSeKiApp.swift
//  KeSeKi
//
//  Created by Jay on 8/8/25.
//

import SwiftUI

struct Config {
    static var shoutingDecibel: Float = -10
    static let shoutingDuration: Double = 0.5
    static let alertStepInterval: Double = 5
    static let alertStepVolumes: [Float] = [0.01, 0.04, 0.06]
}

@main
struct KeSeKiApp: App {
    let homeViewModel: HomeViewModel = .init()
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: homeViewModel)
                .onChange(of: scenePhase) { oldPhase, newPhase in
                    homeViewModel.onScenePhaseChanged(newPhase)
                }
        }
    }
}
