//
//  AlertView.swift
//  KeSeKi
//
//  Created by Nell on 8/9/25.
//

import SwiftUI

struct AlertView: View {
    var viewModel: HomeViewModel
    
    init(_ homeViewModel: HomeViewModel) {
        self.viewModel = homeViewModel
    }
    
    var body: some View {
        VStack {
            Button(action: {
                if viewModel.isRecording {
                    viewModel.stopRecording()
                } else {
                    viewModel.startRecording()
                }
            }) {
                Text(viewModel.isRecording ? "데시벨 측정 중지" : "데시벨 측정 시작")
            }
        }
    }
}

#Preview {
    AlertView(HomeViewModel())
}
