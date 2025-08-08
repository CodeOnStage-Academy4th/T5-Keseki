//
//  ContentView.swift
//  keseki
//
//  Created by Nell on 8/8/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var lockManager = LockNotificationManager()
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        Text("SwiftUI 잠금 감지 데모")
            .padding()
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .active {
                    print("앱이 활성화됨 - 사운드 중지")
                    lockManager.stopAlarmSound()
                } else if newPhase == .background {
                    print("백그라운드 - 사운드 재생")
                    lockManager.playAlarmSound()
                }
            }
    }
}
