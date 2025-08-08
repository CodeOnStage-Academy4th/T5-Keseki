import SwiftUI

struct ProgressRing: View {
    var progress: Double            // 0.0 ~ 1.0
    var lineWidth: CGFloat = 12
    var color: Color = .blue

    var body: some View {
        ZStack {
            // 배경 링
            Circle()
                .stroke(color.opacity(0.2), lineWidth: lineWidth)

            // 진행률 링
            Circle()
                .trim(from: 0, to: progress.clamped(to: 0...1))
                .stroke(
                    color,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90)) // 12시 방향 시작
                .animation(.linear(duration: 0.2), value: progress)
        }
        .accessibilityLabel("진행률")
        .accessibilityValue("\(Int(progress * 100))%")
    }
}

private extension Double {
    /// 0~1 범위 고정
    func clamped(to range: ClosedRange<Double>) -> Double {
        min(max(self, range.lowerBound), range.upperBound)
    }
}

#Preview {
    ProgressRing(progress: 0.7, lineWidth: 12, color: Color("MainColor"))
        .frame(width: 120, height: 120)
        .padding()
}
