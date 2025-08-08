//
//  DecibelManager.swift
//  keseki
//
//  Created by 10100 on 8/8/25.
//

import Foundation

final class DecibelManager: DecibelManaging {
    private let meter: DecibelMeasuring
    private var sustained: TimeInterval = 0
    private var lastSampleTime: CFAbsoluteTime?

    init(meter: DecibelMeasuring = SoundLevelMeter()) { // DI 가능
        self.meter = meter
    }

    func requestPermission(_ completion: @escaping (Bool) -> Void) {
        SoundLevelMeter.requestMicPermission { completion($0) }
    }

    func start(thresholdDB: Float,
               requiredSeconds: TimeInterval,
               onTick: ((Float, TimeInterval) -> Void)? = nil,
               onSuccess: @escaping () -> Void,
               onError: @escaping (Error) -> Void) {

        sustained = 0
        lastSampleTime = nil

        meter.start(onLevel: { [weak self] db in
            guard let self else { return }
            let now = CFAbsoluteTimeGetCurrent()
            let delta = (lastSampleTime != nil) ? now - lastSampleTime! : 0
            lastSampleTime = now

            if db >= thresholdDB { sustained += max(delta, 0) } else { sustained = 0 }
            onTick?(db, sustained)

            if sustained >= requiredSeconds {
                stop()
                onSuccess()
            }
        }, onError: { err in
            onError(err)
        })
    }

    func stop() {
        meter.stop()
        sustained = 0
        lastSampleTime = nil
    }
}
