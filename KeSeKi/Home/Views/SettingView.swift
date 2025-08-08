//
//  AlarmSettingView.swift
//  KeSeKi
//
//  Created by Nell on 8/9/25.
//

import SwiftUI

struct SettingView: View {
    var viewModel: HomeViewModel
    
    init(_ viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Button(action: {
                viewModel.setAlarm()
            }) {
                Text("3초뒤 알람 시작")
            }
        }
    }
}

#Preview {
    let viewModel = HomeViewModel()
    SettingView(viewModel)
}
