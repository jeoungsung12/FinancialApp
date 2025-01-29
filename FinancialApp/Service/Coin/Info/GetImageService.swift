//
//  GetImageService.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/05.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class GetImageService {
    func getCoin(englishName: String) -> Observable<GetImageModel> {
        return Observable.create { observer in
            let url = "https://api.coinpaprika.com/v1/coins"
            let headers: HTTPHeaders = ["accept" : "application/json"]
            return NetworkManager.shared.getData(url, headers: headers)
                .flatMap { (response: [GetPaprikaModel]) -> Observable<GetImageModel> in
                    if let data = response.first(where: { $0.name == englishName }) {
                        return self.getLogo(data.id)
                    }
                    return Observable.error(NSError(domain: "DataNotFound", code: -1, userInfo: nil))
                }
                .subscribe(observer)
        }
    }
    
    private func getLogo(_ id: String) -> Observable<GetImageModel> {
        let url = "https://api.coinpaprika.com/v1/coins/\(id)"
        let headers: HTTPHeaders = ["accept" : "application/json"]
        return NetworkManager.shared.getData(url, headers: headers)
            .flatMap { (response: GetImageModel) -> Observable<GetImageModel> in
                return Observable.just(response)
            }
    }
}
