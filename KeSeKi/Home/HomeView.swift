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
            case .ready:
                ReadyView(viewModel)
            case .alert:
                AlertView(
                    viewModel,
                    date: viewModel.date,
                    dogState: viewModel.dogState
                )
            }
        }
        .onAppear {
            viewModel.askMicPermission()
        }
    }
}

#Preview {
    let viewModel = HomeViewModel(state: .ready)
    HomeView(viewModel: viewModel)
}
