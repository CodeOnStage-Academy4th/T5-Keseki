//
//  DecibelProtocols.swift
//  KeSeKi
//
//  Created by 10100 on 8/8/25.
//

import Foundation

// 저수준 엔진
protocol DecibelMeasuring {
    func start(onLevel: @escaping (Float) -> Void,
               onError: @escaping (Error) -> Void)
    func stop()
}

// 외부에 공개할 매니저
protocol DecibelManaging {
    func requestPermission(_ completion: @escaping (Bool) -> Void)
    func start(thresholdDB: Float,
               requiredSeconds: TimeInterval,
               onTick: ((Float, TimeInterval) -> Void)?,
               onSuccess: @escaping () -> Void,
               onError: @escaping (Error) -> Void)
    func stop()
}
