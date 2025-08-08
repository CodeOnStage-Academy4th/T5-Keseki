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
    
    init(state: HomeViewState = .alaramSetting) {
        self.state = state
    }
    
    func next() {
        state = state.nextState()
    }
}
