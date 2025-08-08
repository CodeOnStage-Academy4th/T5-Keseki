//
//  HomeView.swift
//  keseki
//
//  Created by Nell on 8/9/25.
//

import AVFAudio
import SwiftUI

enum HomeViewState {
    case setting
    case alert
    case wake
}

@Observable
final class HomeViewModel {
    var state: HomeViewState
    private let decibelManager = DecibelManagerImpl()
    private let lockNotificationManager = LockNotificationManager()
    private let alarmManager = AlarmService()
    var date: Date
    var dogState: DogState

    /// Decibel
    var currentDB: Float = -60
    var sustained: TimeInterval = 0
    var isRecording = false
    var errorMessage: String?

    init(state: HomeViewState = .setting) {
        self.state = state
        self.date = Date()
        self.dogState = .step1
        self.configureAudioSession()
    }
    
    func setAlarm() {
        print("알람 예약 : \(self.date)")
        alarmManager.schedule(date: self.date) { dogState in
            print("알람 시작")
            self.startRecording()
            self.state = .alert
            self.dogState = dogState
        }
    }
    
    func cancelAlarm() {
        stopRecording()
        alarmManager.cancel()
        isRecording = false
    }

    func onScenePhaseChanged(_ phase: ScenePhase) {
        if phase == .active {
            print("앱이 활성화됨 - 사운드 중지")
            lockNotificationManager.stopAlarmSound()
        } else if phase == .background {
            print("백그라운드 - 사운드 재생")
            lockNotificationManager.playAlarmSound()
        }
    }

    func askMicPermission() {
        decibelManager.requestPermission { [weak self] ok in
            guard let self else { return }
            if !ok { self.errorMessage = "마이크 권한이 필요합니다." }
        }
    }

    func startRecording(
        threshold: Float = Config.shoutingDecibel,
        required: TimeInterval = Config.shoutingDuration
    ) {
        guard !isRecording else { return }
        isRecording = true

        decibelManager.start(
            thresholdDB: threshold,
            requiredSeconds: required,
            onTick: { [weak self] db, sec in
                guard let self else { return }
                self.currentDB = db
                self.sustained = sec
                print("데시벨 측정 중 : \(db)(\(sec)s)")
            },
            onUnlocked: { [weak self] in
                print("데시벨 성공! 알람 해제!")
                guard let self else { return }
                self.cancelAlarm()
                self.state = .wake
            },
            onError: { [weak self] err in
                guard let self else { return }
                self.errorMessage = err.localizedDescription
                self.isRecording = false
            }
        )
    }

    func stopRecording() {
        decibelManager.stop()
        isRecording = false
        sustained = 0
    }

    func configureAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(
                .playAndRecord,  // Mic + Playback
                mode: .default,
                options: [.defaultToSpeaker, .mixWithOthers]  // Duck 방지
            )
            try session.setActive(true)
        } catch {
            print("⚠️ Failed to set audio session: \(error)")
        }
    }
}
