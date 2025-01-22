//
//  HeartTableViewCell.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/22/25.
//
import UIKit
import SnapKit

final class HeartTableViewCell : UITableViewCell {
    static let id : String = "HeartTableViewCell"
    //MARK: - UI Components
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    //거래량 총액
    private let availLabel : UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.backgroundColor = .black
        return label
    }()
    
    //코인 가격
    private let price : UILabel = {
        let label = UILabel()
        label.backgroundColor = .black
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor
        return label
    }()
    
    //코인 상승세
    private let arrow : UILabel = {
        let label = UILabel()
        label.backgroundColor = .black
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 10)
        return label
    }()
    
    private let icon : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.clipsToBounds = true
        label.textAlignment = .center
        label.layer.cornerRadius = 20
        label.backgroundColor = .clear.randomColor()
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - UI Layout
private extension HeartTableViewCell {
    private func setLayout() {
        self.addSubview(icon)
        self.addSubview(titleLabel)
        self.addSubview(availLabel)
        self.addSubview(price)
        self.addSubview(arrow)
        
        icon.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.leading.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.height.equalTo(15)
            make.leading.equalTo(icon.snp.trailing).offset(12)
        }
        availLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(icon.snp.trailing).offset(22)
        }
        price.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.top.equalToSuperview().offset(8)
        }
        arrow.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.top.equalTo(price.snp.bottom).offset(5)
        }
        
    }
}
//MARK: - Configure
extension HeartTableViewCell {
    public func configure(with model: [AddTradesModel]) {
        //TODO: - 수정
        guard let model = model.first else { return }
        let name = model.coinName
        let englishName = model.englishName
        let price = model.tradesData.trade_price
        let ask_bid = model.tradesData.ask_bid
        let volume = model.tradesData.trade_volume
        
        self.titleLabel.text = name
        self.price.text = "\(price.formatted())₩"
        self.availLabel.text = "\(volume)"
        if let text = englishName.first {
            icon.text = String(text)
        }
        
        //TODO: - 빼내기
        if ask_bid == "ASK" {
            self.price.layer.borderColor = UIColor.red.cgColor
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.price.layer.borderColor = UIColor.black.cgColor
            }
            self.arrow.text = "📈매수"
            self.arrow.textColor = .red
        }else {
            self.price.layer.borderColor = UIColor.blue.cgColor
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.price.layer.borderColor = UIColor.black.cgColor
            }
            self.arrow.text = "📉매도"
            self.arrow.textColor = .blue
        }
    }
}
