//
//  AiRepository.swift
//  FinancialApp
//
//  Created by 정성윤 on 3/15/25.
//

import Foundation
import RxSwift
import RxCocoa

protocol AiRepositoryType {
    func requestChat(search: String, info: String) -> Observable<ChatServiceModel>
}

final class AiRepository: AiRepositoryType {
    private let networkManager: NetworkManagerType = NetworkManager.shared
    func requestChat(search: String, info: String) -> Observable<ChatServiceModel> {
        return networkManager.getData(AiRouter.ai(search: search, info: info))
    }
}
