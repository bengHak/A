//
//  CommentTableCell.swift
//  sdc
//
//  Created by byunghak on 2021/11/05.
//

import UIKit
import SnapKit
import RxSwift
import Then

class CommentTableCell: UITableViewCell {
    
    // MARK: - UI properties
    private let profileIcon = UIImageView().then {
        $0.image = UIImage(systemName: "person.crop.circle")
        $0.layer.cornerRadius = $0.frame.width / 2
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }

    private let nameLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 16)
    }

    private let dateLabel = UILabel().then {
        $0.textColor = .gray
        $0.font = .systemFont(ofSize: 14)
    }

    private let commentLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 14)
    }
    
    // MARK: - Properties
    static let identifier = "CommentTableCell"
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helper
    
    func configureView() {
        contentView.addSubview(profileIcon)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(commentLabel)
        
        profileIcon.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.width.height.equalTo(40)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileIcon)
            $0.leading.equalTo(profileIcon.snp.trailing).offset(10)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(5)
            $0.leading.equalTo(nameLabel)
        }
        
        commentLabel.snp.makeConstraints {
            $0.top.equalTo(profileIcon.snp.bottom).offset(10)
            $0.leading.equalTo(profileIcon).offset(8)
            $0.trailing.equalToSuperview().offset(-10)
        }
    }
    
    func setData(model: ModelComment) {
        self.nameLabel.text = model.username ?? ""
        self.dateLabel.text = Date.getDateStringFromTimestamp(model.createdAt ?? 0)
        self.commentLabel.text = model.content ?? ""
    }
}
