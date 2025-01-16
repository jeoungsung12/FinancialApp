//
//  AiViewController.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/07.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import DGCharts
import iOSDropDown
import Kingfisher
import Foundation
import NVActivityIndicatorView

class AiViewController : UIViewController, UITextFieldDelegate {
    private var disposeBag = DisposeBag()
    private let aiViewModel = AiViewModel()
    private let rewardHelper = RewardedHelper()
    private var koreanName : [String] = []
    private var englishName : [String] = []
    private var marketName : [String] = []
    
    //MARK: UI Components
    private lazy var tapGesture : UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        return gesture
    }()
    //검색 창
    private let searchView : UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.keyColor.cgColor
        view.frame = CGRect(x: 0, y: 0, width: 250, height: 35)
        return view
    }()
    //검색 텍스트
    private let searchText : UITextField = {
        let down = UITextField()
        down.textColor = .black
        down.clipsToBounds = true
        down.placeholder = "코인명(한/영/심볼) 입력"
        down.font = UIFont.systemFont(ofSize: 15)
        return down
    }()
    //검색
    private let searchBtn : UIButton = {
        let btn = UIButton()
        btn.clipsToBounds = true
        btn.tintColor = .keyColor
        btn.backgroundColor = .clear
        btn.contentMode = .scaleAspectFit
        btn.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        return btn
    }()
    //타이틀
    private let navigationTitleLabel : UILabel = {
        let label = UILabel()
        label.text = "Bitcher"
        label.textColor = .keyColor
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    private let loadingIndicator : NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballBeat, color: .keyColor)
        view.clipsToBounds = true
        return view
    }()
    //스크롤
    private let scrollView : UIScrollView = {
        let view = UIScrollView()
        view.clipsToBounds = true
        view.isScrollEnabled = true
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = true
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    //애니메이션
    private let descriptionText : UITextView = {
        let view = UITextView()
        view.isEditable = false
        view.textColor = .gray
        view.clipsToBounds = true
        view.isScrollEnabled = false
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return view
    }()
    private let gifImage : AnimatedImageView = {
        let view = AnimatedImageView()
        view.clipsToBounds = true
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        return view
    }()
    //차트 이미지
    private let chartImage : UIImageView = {
        let view = UIImageView()
        view.image = nil
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFit
        
        let bottomBorder = CALayer()
        bottomBorder.backgroundColor = UIColor.black.cgColor
        bottomBorder.frame = CGRect(x: 0, y: view.frame.size.height - 1, width: view.frame.size.width, height: 1)
        view.layer.addSublayer(bottomBorder)
        
        return view
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = false
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.backgroundColor = .white
        setLayout()
        setBinding()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.hidesBackButton = false
        disposeBag = DisposeBag()
    }
}
//MARK: - UI Layout
extension AiViewController {
    private func setLayout() {
        self.title = "Ai"
        self.view.clipsToBounds = true
        self.view.backgroundColor = .white
        self.view.addGestureRecognizer(tapGesture)
        self.navigationItem.titleView = navigationTitleLabel
       
        self.searchText.text = nil
        self.setGif(imageName: "Cube")
        self.descriptionText.text = "🧐 궁금한 코인을 검색하고, Ai가 분석해 주는 결과를 보며 투자 비율을 조정해 보세요!"
        
        searchView.addSubview(searchText)
        searchView.addSubview(searchBtn)
        self.view.addSubview(searchView)
        self.view.addSubview(loadingIndicator)
        
        searchText.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview().inset(5)
            make.width.equalToSuperview().dividedBy(1.3)
        }
        searchBtn.snp.makeConstraints { make in
            make.leading.equalTo(searchText.snp.trailing).offset(5)
            make.trailing.top.bottom.equalToSuperview().inset(5)
        }
        searchView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(self.view.frame.height / 8)
        }
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        
        scrollView.addSubview(chartImage)
        scrollView.addSubview(descriptionText)
        scrollView.addSubview(gifImage)
        self.view.addSubview(scrollView)
        
        chartImage.snp.makeConstraints { make in
            make.height.equalTo(0)
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        descriptionText.snp.makeConstraints { make in
            make.top.equalTo(chartImage.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview().inset(20)
        }
        gifImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(200)
            make.leading.trailing.equalToSuperview().inset(60)
        }
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom).offset(50)
            make.bottom.equalToSuperview().inset(self.view.frame.height / 10)
        }
        //구글 애드몹 리워드 추가
        rewardHelper.loadRewardedAd()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
}
//MARK: - setBinding
private extension AiViewController {
    private func setBinding() {
        aiViewModel.inputTrigger.onNext(())
        aiViewModel.outputResult.bind(onNext: {[weak self] coinName in
            guard let self = self else { return }
            let market = coinName.compactMap { $0.market }
            let koreanName = coinName.compactMap { $0.korean_name }
            let englishName = coinName.compactMap { $0.english_name }
            self.marketName = market
            self.koreanName = koreanName
            self.englishName = englishName
        }).disposed(by: disposeBag)
        
        searchBtn.rx.tap
            .bind(onNext: {[weak self] _ in
                guard let self = self else { return }
                self.hideKeyboard()
                if let text = searchText.text {
                    if searchText.text != "" {
                        if (self.marketName.contains(text)) || (self.koreanName.contains(text)) || (self.englishName.contains(text)) {
                            rewardHelper.showRewardedAd(viewController: self)
                            self.loadingIndicator.startAnimating()
                            DispatchQueue.main.asyncAfter(deadline: .now()+5.0) {
                                self.chartImage.image = nil
                                self.chartImage.snp.remakeConstraints { make in
                                    make.height.equalTo(0)
                                    make.top.equalToSuperview()
                                    make.leading.trailing.equalToSuperview().inset(20)
                                }
                                self.resizeTextAnimation(text: self.descriptionText, title: "관련 데이터를 분석 중 입니다...")
                                self.setGif(imageName: "data")
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                    var market : String = ""
                                    if (self.marketName.contains(text)) {
                                        market = text
                                    }else if (self.koreanName.contains(text)) {
                                        for index in 0..<self.koreanName.count {
                                            if self.koreanName[index] == text {
                                                market = self.marketName[index]
                                                break
                                            }
                                        }
                                    }else if (self.englishName.contains(text)) {
                                        for index in 0..<self.englishName.count {
                                            if self.englishName[index] == text {
                                                market = self.marketName[index]
                                                break
                                            }
                                        }
                                    }
                                    self.loadingIndicator.stopAnimating()
                                    self.setGif(imageName: "chart")
                                    self.aiViewModel.WMTrigger.onNext([market, "months"])
                                    self.resizeTextAnimation(text: self.descriptionText, title: "암호화폐의 차트를 분석 중 입니다...")
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                        self.aiViewModel.newsTrigger.onNext(text)
                                        self.resizeTextAnimation(text: self.descriptionText, title: "암호화폐의 관련 기사를 수집 중 입니다...")
                                        self.setGif(imageName: "news")
                                    }
                                }
                            }
                        }else{
                            setAlert(title: "코인명(한/영/마켓) 확인", message: "⚠️ 코인명(한/영)을 다시 확인해 주세요")
                        }
                    }else{
                        setAlert(title: "코인명(한/영/마켓) 확인", message: "⚠️ 코인명(한/영)을 다시 확인해 주세요")
                    }
                }
            }).disposed(by: disposeBag)
        //분석
        self.aiViewModel.WMResult.bind(onNext: {[weak self] candle in
            guard let self = self else { return }
            self.aiViewModel.newsResult.bind(onNext: {[weak self] news in
                guard let self = self else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.setGif(imageName: "coin")
                    self.resizeTextAnimation(text: self.descriptionText, title: "암호화폐를 분석 중 입니다...")
                    self.aiViewModel.chatTrigger.onNext(ChatModel(data: candle, news: news))
                }
            }).disposed(by: self.disposeBag)
        }).disposed(by: self.disposeBag)
        //결과
        self.aiViewModel.chatResult.bind(onNext: {[weak self] result in
            guard let self else { return }
            self.gifImage.image = nil
            self.loadingIndicator.stopAnimating()
            let message = result.choices.compactMap { $0.message }
            let content = message.compactMap { $0.content }
            self.descriptionText.text = nil
            imageMatching(content: content)
            self.descriptionText.textAlignment = .left
        }).disposed(by: self.disposeBag)
    }
}
//MARK: - Action
private extension AiViewController {
    private func setAlert(title : String, message : String) {
        let Alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let Ok = UIAlertAction(title: "확인", style: .default)
        Alert.addAction(Ok)
        self.present(Alert, animated: true)
    }
    private func resizeTextAnimation(text: UITextView, title : String){
        text.text = title
        text.textAlignment = .center
        UIView.animate(withDuration: 1.0, animations: {
            text.alpha = 0.0
        }) { _ in
            UIView.animate(withDuration: 1.0, animations: {
                text.alpha = 1.0
            })
        }
    }
    private func setGif(imageName : String) {
        if let gifUrl = Bundle.main.url(forResource: "\(imageName)", withExtension: "gif") {
            self.gifImage.kf.setImage(with: gifUrl)
        }
    }
    private func TypingAnimation(text : String) {
        self.loadingIndicator.stopAnimating()
        Observable<Int>
            .interval(.milliseconds(100), scheduler: MainScheduler.instance)
            .take(text.count)
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                let stringIndex = text.index(text.startIndex, offsetBy: index)
                self.descriptionText.text += String(text[stringIndex])
            }).disposed(by: disposeBag)
    }
    //패턴 이미지 매칭
    private func imageMatching(content : [String]) {
        var contains : Bool = false
        for (pattern, imageName) in patterns {
            if content.first?.contains(pattern) == true {
                contains = true
                DispatchQueue.main.async {
                    self.loadingIndicator.startAnimating()
                    self.chartImage.image = UIImage(named: imageName)
                    self.chartImage.snp.remakeConstraints { make in
                        make.height.equalTo(200)
                        make.top.equalToSuperview()
                        make.leading.trailing.equalToSuperview().inset(20)
                    }
                    self.TypingAnimation(text: content.first ?? "")
                }
                break
            }
        }
        if contains == false {
            self.TypingAnimation(text: content.first ?? "")
        }
    }
}
