//
//  SoundLevelMeter.swift
//  KeSeKi
//
//  Created by 10100 on 8/8/25.
//

import AVFoundation

// 저수준 엔진
protocol DecibelMeasuring {
    func start(onLevel: @escaping (Float) -> Void,
               onError: @escaping (Error) -> Void)
    func stop()
}


enum DecibelEngineError: Error {
    case micPermissionDenied
    case audioSessionFailed(Error)
    case recorderInitFailed(Error)
}

final class DecibelMeasuringImpl: DecibelMeasuring {
    private var recorder: AVAudioRecorder?
    private var timer: Timer?
    
    deinit { stop() }
    
    static func requestMicPermission(_ completion: @escaping (Bool) -> Void) {
        if #available(iOS 17.0, *) {
            AVAudioApplication.requestRecordPermission { granted in
                DispatchQueue.main.async { completion(granted) }
            }
        } else {
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                DispatchQueue.main.async { completion(granted) }
            }
        }
    }
    
    func start(onLevel: @escaping (Float) -> Void,
               onError: @escaping (Error) -> Void) {
        Self.requestMicPermission { granted in
            guard granted else { return onError(DecibelEngineError.micPermissionDenied) }
            
            let session = AVAudioSession.sharedInstance()
            do {
                try session.setCategory(.playAndRecord, options: [.defaultToSpeaker, .mixWithOthers, .allowBluetooth])
                try session.setMode(.voiceChat) // ✅ AEC/NS/AGC로 자기소리 영향 줄이기
                try session.setActive(true)
            } catch { return onError(DecibelEngineError.audioSessionFailed(error)) }
            
            // 파일은 /tmp에 버림(실제 저장 안 씀)
            let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("meter.caf")
            let settings: [String: Any] = [
                AVFormatIDKey: kAudioFormatAppleLossless,
                AVSampleRateKey: 44_100,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue
            ]
            
            do {
                let rec = try AVAudioRecorder(url: url, settings: settings)
                rec.isMeteringEnabled = true
                rec.record()
                self.recorder = rec
            } catch { return onError(DecibelEngineError.recorderInitFailed(error)) }
            
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
                guard let self, let rec = self.recorder else { return }
                rec.updateMeters()
                onLevel(rec.averagePower(forChannel: 0)) // 대략 -60 ~ 0 dBFS
            }
        }
    }
    
    func stop() {
        timer?.invalidate(); timer = nil
        recorder?.stop(); recorder = nil
        try? AVAudioSession.sharedInstance().setActive(false)
    }
}
