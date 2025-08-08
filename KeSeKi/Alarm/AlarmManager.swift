import AVFAudio

@MainActor
final class AlarmManager: ObservableObject {
    @Published var selectedDate: Date = .init()
    @Published var isRinging = false

    private var timer: Timer?
    private var player: AVAudioPlayer?

    func schedule() {
        cancel()

        let fire = nextFireDate(from: selectedDate)
        let interval = max(0, fire.timeIntervalSinceNow)

        // 간단하게 Timer로 대기 (앱이 포그라운드일 때만 신뢰)
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
            self?.startRinging()
        }
        RunLoop.main.add(timer!, forMode: .common)
    }

    func cancel() {
        timer?.invalidate()
        timer = nil
        stopRinging()
    }

    func stopRinging() {
        player?.stop()
        player = nil
        isRinging = false
    }

    private func startRinging() {
        // 알람 소리 반복 재생
        guard let url = Bundle.main.url(forResource: "dog-bark-sound", withExtension: "mp3") else {
            print("⚠️ alarm sound not found in bundle")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1 // 무한 반복
            player?.play()
            isRinging = true
        } catch {
            print("⚠️ audio error: \(error)")
        }
    }

    func nextFireDate(from base: Date) -> Date {
        // “오늘의 시/분”이 이미 지났으면 내일, 아니면 오늘
        var comps = Calendar.current.dateComponents([.hour, .minute], from: base)
        comps.second = 0
        let today = Calendar.current.date(bySettingHour: comps.hour ?? 0,
                                          minute: comps.minute ?? 0,
                                          second: 0,
                                          of: Date())!
        if today > Date() { return today }
        return Calendar.current.date(byAdding: .day, value: 1, to: today)!
    }
}
