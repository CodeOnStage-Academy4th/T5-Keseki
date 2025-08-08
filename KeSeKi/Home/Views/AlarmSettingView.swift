//
//  AlarmSettingView.swift
//  KeSeKi
//
//  Created by Nell on 8/9/25.
//

import SwiftUI

struct AlarmSettingView: View {
    
    var homeViewModel: HomeViewModel
    
    init(_ homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
    }
    
    var body: some View {
        VStack {
            Button(action: homeViewModel.next) {
                Text("알람세팅뷰")
            }
        }
    }
}

#Preview {
    let viewModel = HomeViewModel()
    AlarmSettingView(viewModel)
}
