//
//  ShoutMeterViewModel.swift
//  KeSeKi
//
//  Created by 10100 on 8/8/25.
//

import Combine
import Foundation

@MainActor
final class ShoutMeterViewModel: ObservableObject {
    @Published var currentDB: Float = -60
    @Published var sustained: TimeInterval = 0
    @Published var isMeasuring = false
    @Published var unlocked = false
    @Published var errorMessage: String?

    private let decibelManager: DecibelManager

    init(decibel: DecibelManager = DecibelManagerImpl()) {
        self.decibelManager = decibel
    }

    func askPermission() {
        decibelManager.requestPermission { [weak self] ok in
            guard let self else { return }
            if !ok { self.errorMessage = "마이크 권한이 필요합니다." }
        }
    }

    func start(threshold: Float = -10, required: TimeInterval = 2.0) {
        guard !isMeasuring else { return }
        isMeasuring = true

        decibelManager.start(
            thresholdDB: threshold,
            requiredSeconds: required,
            onTick: { [weak self] db, sec in
                guard let self else { return }
                self.currentDB = db
                self.sustained = sec
            },
            onUnlocked: { [weak self] in
                guard let self else { return }
                self.unlocked = true
                self.isMeasuring = false
            },
            onError: { [weak self] err in
                guard let self else { return }
                self.errorMessage = err.localizedDescription
                self.isMeasuring = false
            }
        )
    }

    func stop() {
        decibelManager.stop()
        isMeasuring = false
        sustained = 0
    }
}
