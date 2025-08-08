//
//  HomeView.swift
//  KeSeKi
//
//  Created by Nell on 8/9/25.
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel: HomeViewModel

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            switch viewModel.state {
            case .alaramSetting:
                AlarmSettingView(viewModel)
            case .settingComplete:
                SettingCompleteView(viewModel)
            }
        }
    }
}

#Preview {
    let viewModel = HomeViewModel()
    HomeView(viewModel: viewModel)
}
