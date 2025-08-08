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
            case .setting:
                SettingView(viewModel)
            case .alert:
                AlertView(
                    viewModel,
                    date: viewModel.date,
                    dogState: viewModel.dogState
                )
            case .wake:
                WakeView(viewModel)
            }
        }
        .onAppear {
            viewModel.askMicPermission()
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                viewModel.state = .setting
            }
        }
    }
}

#Preview {
    let viewModel = HomeViewModel(state: .setting)
    HomeView(viewModel: viewModel)
}
