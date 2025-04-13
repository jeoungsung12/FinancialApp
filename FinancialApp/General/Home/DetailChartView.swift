//
//  DetailChartView.swift
//  SeSAC_Week4(Assignment5)
//
//  Created by 정성윤 on 1/18/25.
//
//
//  DetailChartView.swift
//  SeSAC_Week4(Assignment5)
//
//  Created by 정성윤 on 1/18/25.
//

import UIKit
import SnapKit
import iOSDropDown

enum ToastType {
    case add(title: String)
    case remove(title: String)
}

final class DetailChartView: UIView {
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let heartButton = UIButton()
    private let dropDown = DropDown()
    private let dropDownView = UIView()
    private var chartHostingViewController: ChartHostingViewController?
    
    private var chartType: Bool = false
    private var selectedType: Bool = false
    private let db = Database.shared
    
    var dropdownTapped: ((String)->Void)?
    var heartTapped: ((ToastType)->Void)?
    init(_ type: Bool) {
        super.init(frame: .zero)
        self.chartType = type
        configureView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ title: String, _ open_price: String, _ model: [CandleModel], _ dropDownText: String) {
        descriptionLabel.text = "시가 \(open_price)₩"
        selectedType = (db.heartList.map{ $0.name }.contains(title)) ? true : false
        titleLabel.text = cryptoData.filter( { $0.market == title }).first?.korean_name
        heartButton.setImage(UIImage(systemName: selectedType ? "heart.fill" : "heart"), for: .normal)
        
        // 드롭다운 텍스트 설정
        if chartType {
            dropDown.text = dropDownText
        }
        
        chartHostingViewController?.view.removeFromSuperview()
        chartHostingViewController = ChartHostingViewController(rootView: CandleChartView(chartData: model))
        configureView()
    }
       
}

extension DetailChartView {
    
    private func configureHierachy() {
        self.addSubview(titleLabel)
        self.addSubview(heartButton)
        self.addSubview(descriptionLabel)
        if let chartHostingViewController = chartHostingViewController {
            self.addSubview(chartHostingViewController.view)
        }
        configureLayout()
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.top.leading.equalToSuperview().inset(24)
        }
        
        heartButton.snp.makeConstraints { make in
            make.size.equalTo(25)
            make.top.trailing.equalToSuperview().inset(24)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.bottom.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(titleLabel.snp.trailing).offset(12)
            make.trailing.lessThanOrEqualTo(heartButton.snp.leading).offset(-4)
        }
        
        configureDropDown()
        
        chartHostingViewController?.view.snp.makeConstraints { make in
            make.height.equalTo(150)
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(chartType ? dropDown.snp.bottom : descriptionLabel.snp.bottom).offset(16)
        }
    }
    
    private func configureView() {
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        titleLabel.font = .systemFont(ofSize: 20, weight: .heavy)
        
        descriptionLabel.textColor = .gray
        descriptionLabel.textAlignment = .left
        descriptionLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        
        heartButton.tintColor = .white
        heartButton.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
        configureHierachy()
    }
    
    private func configureDropDown() {
        if !chartType { return }
        // "일"로 초기화하는 부분 제거함
        dropDown.selectedIndex = 0
        dropDown.textColor = .white
        dropDown.arrowColor = .white
        dropDown.textAlignment = .center
        dropDown.arrowSize = CGFloat(15)
        dropDown.backgroundColor = .black
        dropDown.rowBackgroundColor = .gray
        dropDown.selectedRowColor = .lightGray
        dropDown.optionArray = CandleType.allCases.map { $0.title }
        dropDown.didSelect { [weak self] selectedText, index, id in
            self?.dropdownTapped?(selectedText)
        }
        dropDownView.clipsToBounds = true
        dropDownView.layer.borderWidth = 1
        dropDownView.layer.cornerRadius = 5
        dropDownView.backgroundColor = .black
        dropDownView.layer.borderColor = UIColor.white.cgColor
        
        dropDownView.addSubview(dropDown)
        self.addSubview(dropDownView)
        
        dropDown.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.leading.verticalEdges.equalToSuperview().inset(5)
        }
        
        dropDownView.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.leading.equalToSuperview().offset(24)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
    }
    
    @objc
    private func heartButtonTapped(_ sender: UIButton) {
        print(#function)
        guard let text = titleLabel.text else { return }
        selectedType.toggle()
        if selectedType {
            heartTapped?(.add(title: text))
        } else {
            heartTapped?(.remove(title: text))
        }
        heartButton.setImage(UIImage(systemName: selectedType ? "heart.fill" : "heart"), for: .normal)
    }
}
