import SwiftUI

struct AlarmSettingView: View {
    @ObservedObject var alarm: AlarmManager
    var onSchedule: () -> Void
    
    var body: some View {
        Text("설정한 시간에 세키가 깨워드려요")
            .font(.system(size: 20, weight: .regular))
        
        DatePicker("알람 시간", selection: $alarm.selectedDate, displayedComponents: [.hourAndMinute])
            .datePickerStyle(.wheel)
            .font(.system(size: 16, weight: .light))
            .padding()
        
        
        Button(action: {
            print("버튼 눌림")
            alarm.schedule()
        }) {
            Text("설정")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 90, height: 90)
                .background(
                    Circle().fill(Color("MainColor"))
                )
                .contentShape(Circle())
        }
    }
}

#Preview {
    AlarmSettingView(alarm: AlarmManager(), onSchedule: {})
}
