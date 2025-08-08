//
//  AlarmView.swift
//  KeSeKi
//
//  Created by 10100 on 8/9/25.
//

import SwiftUI

enum DogState: CaseIterable { case step1, step2, step3, step4 }

struct AlertView: View {
    let date: Date
    let dogState: DogState
    var viewModel: HomeViewModel
    
    init(_ viewModel: HomeViewModel, date: Date, dogState: DogState) {
        self.date = date
        self.dogState = dogState
        self.viewModel = viewModel
    }
    
    private var backgroundImage: String {
        switch dogState {
        case .step1: return "Step1Background"
        case .step2: return "Step2Background"   // 폭우 배경
        case .step3: return "Step3Background"
        case .step4: return "Step4Background"
        }
    }
    private var dogImage: String {
        switch dogState {
        case .step1: return "Step1Dog"
        case .step2: return "Step2Dog"  // 으르렁 치와와
        case .step3: return "Step3Dog"
        case .step4: return "Step4Dog"
        }
    }
    
    private var period: String {
        date.formatted(.dateTime.locale(Locale(identifier: "ko_KR"))
            .hour(.defaultDigits(amPM: .abbreviated))).contains("오전") ? "오전" : "오후"
    }
    private var timeText: String {
        DateFormatter.cachedKoTime.string(from: date)
    }
    
    var body: some View {
        ZStack {
            // 배경
            Image(backgroundImage)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // 안내 문구
                Text("샤우팅으로 알람을 꺼보세요!")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.85))
                    .padding(.bottom, 16)
                
                // 시간
                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    Text(period)
                        .font(.system(size: 40, weight: .heavy))
                        .foregroundStyle(.white.opacity(0.9))
                    Text(timeText)
                        .font(.system(size: 110, weight: .black, design: .rounded))
                        .foregroundStyle(.white.opacity(0.9))
                }
                
                Spacer()
                
                // 강아지
                Image(dogImage)
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 0)
                    .padding(.bottom, 0)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

private extension DateFormatter {
    static let cachedKoTime: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ko_KR")
        f.dateFormat = "h:mm"
        return f
    }()
}

#Preview {
    AlertView(HomeViewModel(), date: .now, dogState: .step2)
}

