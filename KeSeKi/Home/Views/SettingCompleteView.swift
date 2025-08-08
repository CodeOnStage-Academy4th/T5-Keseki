//
//  SettingCompleteView.swift
//  keseki
//
//  Created by Nell on 8/9/25.
//

import SwiftUI

struct SettingCompleteView: View {
    
    var homeViewModel: HomeViewModel
    
    init(_ homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
    }
    
    var body: some View {
        VStack {
            Button(action: homeViewModel.next) {
                Text("알람 세팅 완료 뷰")
            }
        }
    }
}

#Preview {
    let viewModel = HomeViewModel()
    SettingCompleteView(viewModel)
}
