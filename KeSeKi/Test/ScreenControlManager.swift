//
//  Untitled.swift
//  keseki
//
//  Created by 10100 on 8/9/25.
//

import UIKit

@MainActor
enum ScreenControlManager {
    // 화면 자동 잠금 방지 ON/OFF
    static func setKeepAwake(_ on: Bool) {
        UIApplication.shared.isIdleTimerDisabled = on
    }
    // 밝기 설정 (0.0 ~ 1.0)
    static func setBrightness(_ value: CGFloat) {
        UIScreen.main.brightness = min(max(value, 0), 1)
    }
    static var currentBrightness: CGFloat { UIScreen.main.brightness }
}
