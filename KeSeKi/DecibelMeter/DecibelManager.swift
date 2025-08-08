//
//  DecibelManager.swift
//  keseki
//
//  Created by 10100 on 8/8/25.
//

import AVFoundation

final class DecibelManager: DecibelManaging {
    private let meter: DecibelMeasuring
    private var player: AVAudioPlayer?
    private var sustained: TimeInterval = 0
    private var lastSampleTime: CFAbsoluteTime?
    
    init(meter: DecibelMeasuring = SoundLevelMeter()) {
        self.meter = meter
    }
    
    func requestPermission(_ completion: @escaping (Bool) -> Void) {
        SoundLevelMeter.requestMicPermission { completion($0) }
    }
    
    func start(
        alarmURL: URL,
        thresholdDB: Float,
        requiredSeconds: TimeInterval,
        onTick: @escaping (Float, TimeInterval) -> Void,
        onUnlocked: @escaping () -> Void,
        onError: @escaping (Error) -> Void
    ) {
        // 1) MP3 재생 시작 (무한루프)
        do {
            let p = try AVAudioPlayer(contentsOf: alarmURL)
            p.numberOfLoops = -1
            p.volume = 1.0      // 필요시 0.7 등으로 줄여 피드백 감소
            p.prepareToPlay()
            p.play()
            player = p
        } catch { return onError(error) }
        
        // 2) dB 측정 + 임계치/지속시간 판정
        sustained = 0; lastSampleTime = nil
        meter.start(onLevel: { [weak self] db in
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
        player?.stop(); player = nil
        meter.stop()
        sustained = 0; lastSampleTime = nil
    }
}
