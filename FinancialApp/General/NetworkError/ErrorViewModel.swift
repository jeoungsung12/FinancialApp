//
//  ErrorViewModel.swift
//  CryptoApp
//
//  Created by 정성윤 on 3/9/25.
//

import Foundation
import RxSwift
import RxCocoa
import Network

enum ErrorSenderType: String {
    case exchange
    case info
    case search
    case detail
    case none
    case network = "네트워크 통신이 원활하지 않습니다."
}

protocol ErrorDelegate: AnyObject {
    func reloadNetwork(type: ErrorSenderType)
}

final class ErrorViewModel: BaseViewModel {
    private var disposeBag = DisposeBag()
    
    var notiType: ErrorSenderType
    weak var delegate: ErrorDelegate?
    struct Input {
        let reloadTrigger: ControlEvent<Void>
    }
    
    struct Output {
        let networkReloadTrigger: Driver<ErrorSenderType>
    }
    
    init(notiType: ErrorSenderType) {
        self.notiType = notiType
    }
}

extension ErrorViewModel {
    
    func transform(_ input: Input) -> Output {
        let networkReload: PublishRelay<ErrorSenderType> = PublishRelay()
        
        input.reloadTrigger
            .withUnretained(self)
            .flatMapLatest { owner, _ in
                switch owner.notiType {
                case .network:
                    return owner.checkNetwork()
                default:
                    owner.setDelegate()
                    return Observable.just((owner.notiType))
                }
            }
            .bind(to: networkReload)
            .disposed(by: disposeBag)
        
        return Output(
            networkReloadTrigger: networkReload.asDriver(onErrorJustReturn: .network)
        )
    }
    
    private func setDelegate() {
        delegate?.reloadNetwork(type: notiType)
    }
    
    private func checkNetwork() -> Observable<ErrorSenderType> {
        return Observable.create { observer in
            let monitor = NWPathMonitor()
            let path = monitor.currentPath
            
            if path.status == .satisfied {
                print("네트워크 연결됨")
                observer.onNext(.none)
                observer.onCompleted()
            } else {
                print("네트워크 없음")
                observer.onNext(.network)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

}
