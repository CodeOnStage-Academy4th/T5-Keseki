//
//  HomeView.swift
//  keseki
//
//  Created by Nell on 8/9/25.
//

import SwiftUI

enum HomeViewState {
    case setting
    case ready
    case alert

    func nextState() -> HomeViewState {
        switch self {
        case .setting:
            return .ready
        case .ready:
            return .alert
        case .alert:
            return .setting
        }
    }
}

@Observable
final class HomeViewModel {
    private(set) var state: HomeViewState
    private let decibelManager = DecibelManagerImpl()
    private let lockNotificationManager = LockNotificationManager()
    private let alarmManager = AlarmService()
    var date: Date
    var dogState: DogState

    /// Decibel
    var currentDB: Float = -60
    var sustained: TimeInterval = 0
    var isRecording = false
    var unlocked = false
    var errorMessage: String?

    init(state: HomeViewState = .setting) {
        self.state = state
        self.date = Date()
        self.dogState = .step1
    }

    func setAlarm(date: Date? = nil) {
        self.date = date ?? Date().addingTimeInterval(3)
        print("알람 예약 : \(self.date)")
        alarmManager.schedule(date: self.date) { dogState in
            print("알람 시작")
            self.startRecording()
            self.state = .alert
            self.dogState = dogState
            if dogState == .step4 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.alarmManager.cancel()
                    self.state = .setting
                    self.stopRecording()
                }
            }
        }
        state = .ready
    }

    func cancelAlarm() {
        alarmManager.cancel()
    }

    func next() {
        state = state.nextState()
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
                // TODO: 알람 해제하기 기능 추가
                print("데시벨 성공! 알람 해제!")
                guard let self else { return }
                self.stopRecording()
                self.cancelAlarm()
                self.unlocked = true
                self.isRecording = false
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
}
