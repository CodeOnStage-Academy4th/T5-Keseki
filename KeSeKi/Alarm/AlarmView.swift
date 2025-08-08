import SwiftUI

struct AlarmView: View {
    @StateObject private var alarm = AlarmManager()
    
    // 진행률/토글 상태
    @State private var showProgress = false
    @State private var progress: Double = 0.0        // 1 → 0으로 감소
    @State private var fireDate: Date? = nil
    @State private var total: TimeInterval = 1
    @State private var remaining: TimeInterval = 0    // ⬅️ 남은 초
    
    // 1초마다 틱
    private let ticker = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 0) {
            Text("설정한 시간에 세키가 깨워드려요")
                .font(.system(size: 20, weight: .regular))
                .padding(.top, 120)
    
            Spacer()
            
            if showProgress {
                ZStack {
                    ProgressRing(progress: progress, lineWidth: 12, color: Color("MainColor"))
                    
                    VStack(spacing: 8) {
                        // 🔔 07:00 표시
                        if let fire = fireDate {
                            HStack(spacing: 6) {
                                Image(systemName: "bell.fill")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundStyle(.primary)
                                Text(fire, style: .time) // 지역 설정 따라 07:00처럼 노출
                                    .font(.system(size: 20, weight: .regular))
                                    .foregroundStyle(.primary)
                            }
                        }
                        // 남은 시간 08:34:56
                        Text(formatHMS(remaining))
                            .font(.system(size: 48, weight: .semibold, design: .default).monospacedDigit())
                            .foregroundStyle(.primary)
                    }
                }
                .frame(width: 320, height: 320)
                
                Spacer()
                
                Button(action: {
                    // 수정: 알람 취소 + 상태 초기화 + DatePicker로 복귀
                    alarm.cancel()
                    showProgress = false
                    progress = 0
                    remaining = 0
                    fireDate = nil
                    total = 1
                }) {
                    Text("수정")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 90, height: 90)
                        .background(Circle().fill(Color("MainColor")))
                        .contentShape(Circle())
                }
                .padding(.bottom, 120)
                
            } else {
                DatePicker("알람 시간", selection: $alarm.selectedDate, displayedComponents: [.hourAndMinute])
                    .datePickerStyle(.wheel)
                    .font(.system(size: 16, weight: .light))
                    .padding()
                
                Spacer()
                
                Button(action: {
                    // 1) 알람 예약
                    alarm.schedule()
                    // 2) 기준 시각/진행도 초기값 설정
                    let fire = alarm.nextFireDate(from: alarm.selectedDate)
                    fireDate = fire
                    total = max(1, fire.timeIntervalSinceNow)
                    remaining = total
                    progress = 1                      // 꽉 찬 상태에서 시작(카운트다운)
                    showProgress = true
                }) {
                    Text("설정")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 90, height: 90)
                        .background(Circle().fill(Color("MainColor")))
                        .contentShape(Circle())
                }
                .padding(.bottom, 120)
            }
            
            if alarm.isRinging {
                Button("🔕 끄기") {
                    alarm.stopRinging()
                }
                .font(.title3)
                .padding(.top, 8)
            }
        }
        // 남은 시간/프로그레스 갱신 (1 → 0 감소)
        .onReceive(ticker) { _ in
            guard showProgress, let fire = fireDate else { return }
            let r = max(0, fire.timeIntervalSinceNow)
            remaining = r
            progress = max(0, r / total)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // 08:34:56 형식
    private func formatHMS(_ t: TimeInterval) -> String {
        let s = Int(max(0, t))
        let h = s / 3600
        let m = (s % 3600) / 60
        let sec = s % 60
        return String(format: "%02d:%02d:%02d", h, m, sec)
    }
}

#Preview { AlarmView() }
