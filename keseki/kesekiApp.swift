//
//  KeSeKiApp.swift
//  KeSeKi
//
//  Created by Jay on 8/8/25.
//

import SwiftUI

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
