//
//  DevView.swift
//  KeSeKi
//
//  Created by Nell on 8/9/25.
//

import SwiftUI

struct DevView: View {
    @State var decibel: String = String(format: "Shouting Decibel: %.2f", Config.shoutingDecibel)
    
    var body: some View {
        VStack {
            Text(decibel)
                .padding()
            Slider(value: Binding(
                get: { Config.shoutingDecibel },
                set: {
                    decibel = String(format: "Shouting Decibel: %.2f", Config.shoutingDecibel)
                    Config.shoutingDecibel = $0
                }
            ), in: -21...21, step: 1)
        }
        .padding()
    }
}

#Preview {
    DevView()
}
