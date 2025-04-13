//
//  WebSocketManager.swift
//  FinancialApp
//
//  Created by 정성윤 on 4/13/25.
//

import UIKit
import RxSwift
import RxCocoa
protocol WebSocketManagerType: AnyObject {
    func connect()
    func receiveMessage()
    func disConnect()
    func send(_ market: String)
    var messagePublisher: PublishSubject<WebSocketCandleData> { get }
}

final class WebSocketManager: WebSocketManagerType {
    static let shared: WebSocketManagerType = WebSocketManager()
    private init() { }
    private var webSocket: URLSessionWebSocketTask?
    
    let messagePublisher = PublishSubject<WebSocketCandleData>()
    
    func connect() {
        guard let url = URL(string: "wss://api.upbit.com/websocket/v1") else { return }
        let session = URLSession(configuration: .default)
        webSocket = session.webSocketTask(with: url)
        webSocket?.resume()
        receiveMessage()
    }
    
    func receiveMessage() {
        webSocket?.receive(completionHandler: { [weak self] result in
            switch result {
            case .success(let success):
                switch success {
                case .data(let value):
                    do {
                        if let jsonString = String(data: value, encoding: .utf8) {
                            print("수신된 데이터: \(jsonString)")
                        }
                        
                        let candleData = try JSONDecoder().decode(WebSocketCandleData.self, from: value)
                        self?.messagePublisher.onNext(candleData)
                    } catch {
                        print("디코딩 오류: \(error)")
                    }
                case .string(let value):
                    print("문자열 형식으로 받음: \(value)")
                    if let data = value.data(using: .utf8) {
                        do {
                            let candleData = try JSONDecoder().decode(WebSocketCandleData.self, from: data)
                            self?.messagePublisher.onNext(candleData)
                        } catch {
                            print("문자열 디코딩 오류: \(error)")
                        }
                    }
                @unknown default:
                    print("알 수 없는 형식")
                }
            case .failure(let failure):
                print("WebSocket 오류: \(failure)")
            }
            self?.receiveMessage()
        })
    }
    
    func disConnect() {
        webSocket?.cancel(with: .goingAway, reason: nil)
        webSocket = nil
    }
    
    func send(_ market: String) {
        let message = "[{\"ticket\":\"test\"},{\"type\":\"trade\",\"codes\":[\"\(market)\"]}]"
        print("전송 메시지: \(message)")
        
        webSocket?.send(
            .string(message),
            completionHandler: { error in
                if let error = error {
                    print("전송 오류: \(error)")
                }
            })
    }
}
