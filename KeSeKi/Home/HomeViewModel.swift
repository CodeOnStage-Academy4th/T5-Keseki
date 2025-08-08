//
//  HomeView.swift
//  keseki
//
//  Created by Nell on 8/9/25.
//

import SwiftUI

enum HomeViewState {
    case alaramSetting
    case settingComplete

    func nextState() -> HomeViewState {
        switch self {
        case .alaramSetting:
            return .settingComplete
        case .settingComplete:
            return .alaramSetting
        }
    }
}

@Observable
final class HomeViewModel {
    private(set) var state: HomeViewState
    let lockNotificationManager = LockNotificationManager()

    init(state: HomeViewState = .alaramSetting) {
        self.state = state
    }

    func next() {
        state = state.nextState()
    }

    func onScenePhaseChanged(_ phase: ScenePhase) {
        if phase == .active {
            print("앱이 활성화됨 - 사운드 중지")
            lockNotificationManager.stopAlarmSound()
        } else if phase == .background {
            print("백그라운드 - 사운드 재생")
            lockNotificationManager.playAlarmSound()
        }
    }
}
