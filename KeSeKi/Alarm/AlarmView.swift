import SwiftUI

struct AlarmView: View {
    @StateObject private var alarm = SimpleAlarmManager()

    var body: some View {
        VStack(spacing: 20) {
            DatePicker("알람 시간", selection: $alarm.selectedDate, displayedComponents: [.hourAndMinute])
                .datePickerStyle(.wheel)

            HStack {
                Button("알람 설정") {
                    alarm.schedule()
                }
                .buttonStyle(.borderedProminent)

                Button("취소") {
                    alarm.cancel()
                }
                .buttonStyle(.bordered)
            }

            if alarm.isRinging {
                Button("🔕 끄기") {
                    alarm.stopRinging()
                }
                .font(.title3)
                .padding(.top, 8)
            }
        }
        .padding()
    }
}
