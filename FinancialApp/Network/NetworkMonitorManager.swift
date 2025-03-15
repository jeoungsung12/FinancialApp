//
//  NetworkMonitorManager.swift
//  FinancialApp
//
//  Created by 정성윤 on 3/15/25.
//

import Foundation
import Network

protocol NetworkMonitorManagerType {
    func startMonitoring(statusUpdateHandler: @escaping (NWPath.Status) -> Void)
    func stopMonitoring()
}

final class NetworkMonitorManager: NetworkMonitorManagerType {
    private let queue = DispatchQueue.global(qos: .background)
    private let monitor = NWPathMonitor()
    
    func startMonitoring(statusUpdateHandler: @escaping (NWPath.Status) -> Void) {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                print("네트워크 상태 변경 감지 : \(path.status)")
                statusUpdateHandler(path.status)
            }
        }
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
