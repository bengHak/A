//
//  DetailViewController.swift
//  sdc
//
//  Created by byunghak on 2021/11/04.
//

import UIKit
import SnapKit
import Then
import RxSwift

class DetailViewController: UIViewController {
    
    // MARK: - UI properties
    private let scrollView = UIScrollView().then {
        $0.bounces = true
    }
    
    private let scrollContentView = UIView()
    
    private let usernameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .secondaryLabel
    }
    
    private let dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .secondaryLabel
    }
    
    private let contentView = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .black
        $0.numberOfLines = 0
    }
    
    
    // MARK: - Properties
    var bag = DisposeBag()
    
    var viewModel = DetailViewModel()
    
    var postId: Int?
    var oldLineCount: Int = 0
    var lineCount: Int = 0
    private let lineSpacingValue = 6
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        configureView()
        configureSubViews()
        bindRx()
        fetch()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        oldLineCount = lineCount
        lineCount = contentView.calculateMaxLines()
        if oldLineCount != lineCount {
            adjustScrollContentView()
        }
    }
    // MARK: - Helpers
    func adjustScrollContentView() {
        scrollContentView.snp.updateConstraints {
            $0.height.equalTo(120 + lineCount * (lineSpacingValue + 18))
        }
    }
    
    func fetch() {
        if postId != nil {
            viewModel.fetchPost(postId!)
        } else {
            print("🔴 post id is nil")
        }
    }
}

// MARK: - BaseViewController
extension DetailViewController {
    
    func configureView() {
        [usernameLabel, dateLabel, contentView].forEach {
            scrollContentView.addSubview($0)
        }
        
        scrollView.addSubview(scrollContentView)
        view.addSubview(scrollView)
    }
    
    func configureSubViews() {
        usernameLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(usernameLabel)
            $0.leading.equalTo(usernameLabel.snp.trailing).offset(10)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(usernameLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().inset(30)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        scrollContentView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
            $0.width.equalTo(view.frame.width)
            $0.height.equalTo(200 + lineCount * 16)
        }
    }
}

// MARK: - BindableController
extension DetailViewController {
    
    func bindRx() {
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.output.post
            .subscribe(onNext: { [weak self] post in
                guard let self = self else { return }
                
                guard let post = post else {
                    print("🔴 post is nil")
                    return
                }
                
                DispatchQueue.main.async {
                    self.title = post.title
                    self.usernameLabel.text = "유저네임"
                    self.dateLabel.text = Date.getDateStringFromTimestamp(post.createdAt ?? 0)
                    self.contentView.text = post.content
                    self.contentView.addInterlineSpacing(spacingValue: CGFloat(self.lineSpacingValue))
                }
            })
            .disposed(by: bag)
    }
}
