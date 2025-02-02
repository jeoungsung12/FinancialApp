//
//  FAQViewController.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/31/25.
//
import UIKit
import SnapKit

class FAQViewController: UIViewController {
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.text = FAQText
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .white
        textView.backgroundColor = .black
        textView.isEditable = false
        textView.isScrollEnabled = true
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureHierarchy()
        configureLayout()
    }
    
    private func configureView() {
        view.backgroundColor = .black
        title = "자주 묻는 질문"
    }
    
    private func configureHierarchy() {
        view.addSubview(textView)
    }
    
    private func configureLayout() {
        textView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
    }
}
