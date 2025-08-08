//
//  LockNotificationManager.swift
//  keseki
//
//  Created by Nell on 8/9/25.
//

import AVFoundation
import Combine
import SwiftUI
import UserNotifications

final class LockNotificationManager: ObservableObject {
    private var audioPlayer: AVAudioPlayer?
    init() {
        requestNotificationPermission()
        registerForLockNotification()
    }

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [
            .alert, .sound,
        ]) { granted, error in
            if let error = error {
                print("Notification 권한 요청 실패: \(error.localizedDescription)")
            } else {
                print(granted ? "Notification 권한 허용됨" : "Notification 권한 거부됨")
            }
        }
    }

    private func registerForLockNotification() {
        let center = CFNotificationCenterGetDarwinNotifyCenter()
        CFNotificationCenterAddObserver(
            center,
            UnsafeRawPointer(Unmanaged.passUnretained(self).toOpaque()),
            { (_, observer, name, _, _) in
                if let name = name?.rawValue as String?,
                    name == "com.apple.springboard.lockcomplete"
                {
                    let lockManager = Unmanaged<LockNotificationManager>
                        .fromOpaque(
                            observer!
                        ).takeUnretainedValue()
                    lockManager.scheduleLocalNotification()
                    lockManager.playAlarmSound()
                }
            },
            "com.apple.springboard.lockcomplete" as CFString,
            nil,
            .deliverImmediately
        )
    }

    func scheduleLocalNotification() {
        let center = UNUserNotificationCenter.current()

        // 알림 콘텐츠 설정
        let content = UNMutableNotificationContent()
        content.title = "🐶"
        content.body = "앱을 켜라멍!"
        content.sound = nil

        // 알람 시간을 여기서 지정
        let triggerDate =
            Calendar.current.date(byAdding: .second, value: 3, to: Date())
            ?? Date()

        let triggerDateComponents = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: triggerDate
        )

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: triggerDateComponents,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: "alarmNotification",
            content: content,
            trigger: trigger
        )

        center.add(request) { error in
            if let error = error {
                print("알림 스케줄링 실패: \(error.localizedDescription)")
            } else {
                print("알림 스케줄링 성공: \(triggerDate)")
            }
        }
    }

    func playAlarmSound() {
        guard
            let url = Bundle.main.url(forResource: "dog0", withExtension: "mp3")
        else {
            print("음원 파일을 찾을 수 없습니다.")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1  // 한 번 재생
            audioPlayer?.play()

        } catch {
            print("오디오 재생 실패: \(error.localizedDescription)")
        }
    }

    func stopAlarmSound() {
        audioPlayer?.stop()
        audioPlayer = nil
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            print("AVAudioSession 비활성화 실패: \(error.localizedDescription)")
        }
    }

    deinit {
        CFNotificationCenterRemoveEveryObserver(
            CFNotificationCenterGetDarwinNotifyCenter(),
            UnsafeRawPointer(Unmanaged.passUnretained(self).toOpaque())
        )
    }
}
