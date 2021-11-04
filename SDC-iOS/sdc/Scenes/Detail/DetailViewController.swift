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
    
    lazy var config = UIImage.SymbolConfiguration(paletteColors: [.gray, .systemOrange])
    lazy var black = UIImage.SymbolConfiguration(weight: .bold)
    lazy var combined = config.applying(black)
    
    lazy var updateButton = UIBarButtonItem(title: "",
                                           image: UIImage(systemName: "pencil.and.outline", withConfiguration: combined),
                                           primaryAction: nil,
                                           menu: nil)
    lazy var deleteButton = UIBarButtonItem(title: "",
                                          image: UIImage(systemName: "trash.slash.fill", withConfiguration: combined),
                                          primaryAction: nil,
                                          menu: nil)
    

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
    func deleteAlert(completion: @escaping () -> Void) {
        let alert = UIAlertController(title: "삭제하시겠습니까?", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            completion()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }

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
        bindButtons()
        bindViewModel()
    }

    private func bindButtons() {
        updateButton.rx.tap.bind { [weak self] _ in
            guard let self = self else { return }
            guard let title = self.title,
                  let content = self.contentView.text,
                  let postId = self.postId else {
                      return
                  }
            
            DispatchQueue.main.async {
                let updateVC = UpdatePostViewController(postId: postId, title: title, content: content)
                let navVC = UINavigationController(rootViewController: updateVC)
                self.navigationController?.present(navVC, animated: true)
            }
        }.disposed(by: bag)
        
        deleteButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            guard let postId = self.postId else { return }
            self.deleteAlert {
                self.viewModel.deletePost(postId)
                self.navigationController?.popViewController(animated: true)
            }
        }.disposed(by: bag)
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
                    self.usernameLabel.text = "..."
                    self.dateLabel.text = Date.getDateStringFromTimestamp(post.createdAt ?? 0)
                    self.contentView.text = post.content
                    self.contentView.addInterlineSpacing(spacingValue: CGFloat(self.lineSpacingValue))
                }
            })
            .disposed(by: bag)
        
        viewModel.output.writer
            .subscribe(onNext: { [weak self] userData in
                guard let self = self else { return }
                
                guard let userData = userData else {
                    print("🔴 user data is nil")
                    return
                }
                
                self.usernameLabel.text = userData.username
                
                if UserDefaults.standard.integer(forKey: "userId") == userData.id {
                    self.navigationItem.rightBarButtonItems = [self.deleteButton, self.updateButton]
                } else {
                    self.navigationItem.rightBarButtonItems = []
                }
            })
            .disposed(by: bag)
    }
}
