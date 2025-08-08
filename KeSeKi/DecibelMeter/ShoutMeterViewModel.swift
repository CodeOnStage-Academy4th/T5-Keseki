//
//  ShoutMeterViewModel.swift
//  KeSeKi
//
//  Created by 10100 on 8/8/25.
//

import Combine

@MainActor
final class ShoutMeterViewModel: ObservableObject {
    @Published var currentDB: Float = -60
    @Published var sustained: TimeInterval = 0
    @Published var isMeasuring = false
    @Published var unlocked = false
    @Published var errorMessage: String?

    private let decibel: DecibelManaging

    init(decibel: DecibelManaging = DecibelManager()) {
        self.decibel = decibel
    }

    func askPermission() {
        decibel.requestPermission { [weak self] ok in
            guard let self else { return }
            if !ok { self.errorMessage = "마이크 권한이 필요합니다." }
        }
    }

    func start(threshold: Float = -10, required: TimeInterval = 2.0) {
        guard !isMeasuring else { return }
        isMeasuring = true

        decibel.start(thresholdDB: threshold, requiredSeconds: required,
                      onTick: { [weak self] db, sec in
            guard let self else { return }
            self.currentDB = db
            self.sustained = sec
        }, onSuccess: { [weak self] in
            guard let self else { return }
            self.unlocked = true
            self.isMeasuring = false
        }, onError: { [weak self] err in
            guard let self else { return }
            self.errorMessage = err.localizedDescription
            self.isMeasuring = false
        })
    }

    func stop() {
        decibel.stop()
        isMeasuring = false
        sustained = 0
    }
}

