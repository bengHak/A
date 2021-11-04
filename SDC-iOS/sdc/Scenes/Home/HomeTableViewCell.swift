//
//  HomeTableViewCell.swift
//  sdc
//
//  Created by byunghak on 2021/11/04.
//

import UIKit
import SnapKit
import Then

class HomeTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "HomeTableViewCell"
    
    private let title = UILabel().then {
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 24, weight: .bold)
    }
    
    private let content = UILabel().then {
        $0.textColor = .secondaryLabel
        $0.font = .systemFont(ofSize: 16)
        $0.numberOfLines = 3
    }
    
    private let createdAt = UILabel().then {
        $0.textColor = .secondaryLabel
        $0.font = .systemFont(ofSize: 16)
    }
    
    private let blogTitle = UILabel().then {
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 16)
    }
    
    // 이미지 삽입할 때 스택으로 넣기
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        configureSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    func configureView() {
        [title, content, createdAt, blogTitle].forEach {
            contentView.addSubview($0)
        }
    }
    
    func configureSubViews() {
        title.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(24)
            $0.top.trailing.equalToSuperview().inset(24)
        }
        
        content.snp.makeConstraints {
            $0.leading.trailing.equalTo(title)
            $0.top.equalTo(title.snp.bottom).offset(4)
        }
        
        createdAt.snp.makeConstraints {
            $0.leading.equalTo(title)
            $0.top.equalTo(content.snp.bottom).offset(4)
        }
        
        blogTitle.snp.makeConstraints {
            $0.leading.equalTo(title)
            $0.top.equalTo(createdAt.snp.bottom).offset(8)
        }
    }
    
    func setData(model: ModelFeed) {
        title.text = model.title
        content.text = model.content
        blogTitle.text = "블로그 제목"
        createdAt.text = Date.getDateStringFromTimestamp(model.createdAt ?? 0)
        
    }
}
