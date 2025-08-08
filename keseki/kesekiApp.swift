//
//  KeSeKiApp.swift
//  KeSeKi
//
//  Created by Jay on 8/8/25.
//

import SwiftUI

struct Config {
    static let shoutingDecibel: Float = -10
    static let shoutingDuration: Double = 1
    static let alertStepInterval: Double = 2
    static let alertStepVolumes: [Float] = [0.3, 0.6, 1.0]
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
