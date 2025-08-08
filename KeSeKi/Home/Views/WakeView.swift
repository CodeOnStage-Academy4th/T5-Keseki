//
//  WakeView.swift
//  keseki
//
//  Created by Nell on 8/9/25.
//

import SwiftUI
import AVFAudio

struct WakeView: View {
    private var viewModel: HomeViewModel
    @State private var player: AVAudioPlayer?
    
    init(_ viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    private var backgroundImage: String = "Step4Background"
    private var dogImage: String = "Step4Dog"
    
    private func playWakeMp3() {
        do {
            let url = Bundle.main.url(forResource: "dog4", withExtension: "mp3")
            self.player = try? AVAudioPlayer(contentsOf: url!)
            self.player?.numberOfLoops = 1
            self.player?.play()
            print("played")
        } catch {
            print("failed to playWakeMp3 : \(error)")
        }
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
                Spacer()
                
                // 안내 문구
                Text("잘했개.\n오늘도 좋은 하루 보내개.")
                    .font(.system(size: 32, weight: .heavy))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 3)
                
                
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
        .onAppear {
            self.playWakeMp3()
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.1) {
                viewModel.state = .setting
            }
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
    WakeView(HomeViewModel())
}
