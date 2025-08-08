//
//  AlarmService.swift
//  keseki
//
//  Created by Nell on 8/9/25.
//

import AVFAudio

final class AlarmService {
    var isRinging = false
    private var timer: Timer?
    private var changeTimer: Timer?
    private var player: AVAudioPlayer?

    func schedule(date: Date, onStart: @escaping (DogState) -> Void) {
        cancel()
        let interval = max(0, date.timeIntervalSinceNow)

        // 간단하게 Timer로 대기 (앱이 포그라운드일 때만 신뢰)
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false)
        { [weak self] _ in

            self?.startRinging(onStart)
        }
        RunLoop.main.add(timer!, forMode: .common)
    }

    func cancel() {
        changeTimer?.invalidate()
        timer?.invalidate()
        changeTimer = nil
        timer = nil

        stopRinging()
    }

    func stopRinging() {
        player?.stop()
        player = nil
        isRinging = false
    }

    private func startRinging(_ onStart: @escaping (DogState) -> Void) {
        let sounds = ["dog1", "dog2", "dog3"]
        var currentIndex = 0

        func playSound(named name: String) {
            print("play : \(name)")
            guard
                let url = Bundle.main.url(
                    forResource: name,
                    withExtension: "mp3"
                )
            else {
                print("⚠️ alarm sound \(name) not found in bundle")
                return
            }
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.numberOfLoops = -1  // 무한 반복
                player?.volume = Config.alertStepVolumes[currentIndex]
                player?.play()
                isRinging = true
            } catch {
                print("⚠️ audio error: \(error)")
            }
        }

        onStart(DogState.allCases[currentIndex])
        playSound(named: sounds[currentIndex])

        // 10초마다 다음 음원으로 변경
        self.changeTimer = Timer.scheduledTimer(
            withTimeInterval: Config.alertStepInterval,
            repeats: true
        ) { _ in
            currentIndex += 1
            if currentIndex < sounds.count {
                onStart(DogState.allCases[currentIndex])
                playSound(named: sounds[currentIndex])
            }
            if currentIndex >= sounds.count - 1 {
                self.changeTimer?.invalidate()
                self.changeTimer = nil
            }
        }
        RunLoop.main.add(changeTimer!, forMode: .common)
    }

    private func nextFireDate(from base: Date) -> Date {
        // “오늘의 시/분”이 이미 지났으면 내일, 아니면 오늘
        var comps = Calendar.current.dateComponents(
            [.hour, .minute],
            from: base
        )
        comps.second = 0
        let today = Calendar.current.date(
            bySettingHour: comps.hour ?? 0,
            minute: comps.minute ?? 0,
            second: 0,
            of: Date()
        )!
        if today > Date() { return today }
        return Calendar.current.date(byAdding: .day, value: 1, to: today)!
    }
}

