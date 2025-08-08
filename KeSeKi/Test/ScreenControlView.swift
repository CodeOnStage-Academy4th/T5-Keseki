//
//  ScreenControlView.swift
//  KeSeKi
//
//  Created by 10100 on 8/9/25.
//

import SwiftUI

struct ScreenControlView: View {
    @State private var keepAwake = false
    @State private var prevBrightness: CGFloat = ScreenControlManager.currentBrightness

    var body: some View {
        VStack(spacing: 16) {
            Toggle("화면 유지(자동 잠금 방지)", isOn: $keepAwake)
                .onChange(of: keepAwake) { _, newValue in
                    if newValue {
                        // 켤 때 현재 밝기 기억(복구용)
                        prevBrightness = ScreenControlManager.currentBrightness
                    }
                    ScreenControlManager.setKeepAwake(newValue)
                }

            Button("화면 유지 + 밝기 최저로") {
                prevBrightness = ScreenControlManager.currentBrightness
                ScreenControlManager.setKeepAwake(true)
                keepAwake = true
                ScreenControlManager.setBrightness(0.0) // 최저 밝기
            }

            Button("밝기 복구 & 화면 유지 해제") {
                ScreenControlManager.setBrightness(prevBrightness)
                ScreenControlManager.setKeepAwake(false)
                keepAwake = false
            }
        }
        .padding()
        // 이 뷰를 떠날 때는 항상 원복 (안전장치)
        .onDisappear {
            ScreenControlManager.setBrightness(prevBrightness)
            ScreenControlManager.setKeepAwake(false)
        }
    }
}

#Preview {
    ScreenControlView()
}
