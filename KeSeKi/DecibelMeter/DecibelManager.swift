//
//  DecibelManager.swift
//  keseki
//
//  Created by 10100 on 8/8/25.
//

import Foundation

// 외부에 공개할 매니저
protocol DecibelManager {
    func requestPermission(_ completion: @escaping (Bool) -> Void)
    
    func start(
        thresholdDB: Float,
        requiredSeconds: TimeInterval,
        onTick: @escaping (Float, TimeInterval) -> Void,
        onUnlocked: @escaping () -> Void,
        onError: @escaping (Error) -> Void
    )
    
    func stop()
}

final class DecibelManagerImpl: DecibelManager {
    private let decibelMeasuring: DecibelMeasuring
    private var sustained: TimeInterval = 0
    private var lastSampleTime: CFAbsoluteTime?
    
    init(decibelMeasuring: DecibelMeasuring = DecibelMeasuringImpl()) {
        self.decibelMeasuring = decibelMeasuring
    }
    
    func requestPermission(_ completion: @escaping (Bool) -> Void) {
        DecibelMeasuringImpl.requestMicPermission { completion($0) }
    }
    
    func start(
        thresholdDB: Float,
        requiredSeconds: TimeInterval,
        onTick: @escaping (Float, TimeInterval) -> Void,
        onUnlocked: @escaping () -> Void,
        onError: @escaping (Error) -> Void
    ) {
        // dB 측정 + 임계치/지속시간 판정
        sustained = 0; lastSampleTime = nil
        decibelMeasuring.start(onLevel: { [weak self] db in
            guard let self else { return }
            let now = CFAbsoluteTimeGetCurrent()
            let delta = (self.lastSampleTime != nil) ? now - self.lastSampleTime! : 0
            self.lastSampleTime = now
            
            if db >= thresholdDB { self.sustained += max(delta, 0) } else { self.sustained = 0 }
            onTick(db, self.sustained)
            
            if self.sustained >= requiredSeconds {
                self.stop()
                onUnlocked()
            }
        }, onError: { err in
            onError(err)
        })
    }
    
    func stop() {
        decibelMeasuring.stop()
        sustained = 0; lastSampleTime = nil
    }
}
