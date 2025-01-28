//
//  NetworkError.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/28/25.
//

import Foundation

struct NetworkError {
    enum CustomError: Int, Error, CaseIterable, LocalizedError {
        case badRequest = 400
        case unauthorized = 401
        case forbidden = 403
        case notFount = 404
        case server = 500
        case network
        
        var errorDescription: String? {
            switch self {
            case .badRequest:
                "잘못된 요청입니다"
            case .unauthorized:
                "인증 오류가 발생했습니다"
            case .forbidden:
                "접근이 거부되었습니다"
            case .notFount:
                "페이지를 찾을 수 없습니다"
            case .server:
                "서버의 접속이 원활하지 않습니다"
            case .network:
                "네트워크 연결상태가 좋지 않습니다."
            }
        }
    }
    
    func checkErrorType(_ error: Int?) -> CustomError {
        guard let error = error, let type = CustomError.allCases.filter({ $0.rawValue == error }).first else { return .network }
        return type
    }
}
