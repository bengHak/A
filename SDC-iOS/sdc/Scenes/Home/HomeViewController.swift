//
//  HomeViewController.swift
//  sdc
//
//  Created by byunghak on 2021/11/02.
//

import UIKit
import SnapKit
import RxSwift
import Then

import SwiftKeychainWrapper

class HomeViewController: UIViewController {
    
    // MARK: - UI properties
    private let textLabel = UILabel().then {
        $0.text = "글이 없어요 😢"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 30)
    }
    
    lazy var config = UIImage.SymbolConfiguration(paletteColors: [.gray, .systemOrange])
    lazy var black = UIImage.SymbolConfiguration(weight: .bold)
    lazy var combined = config.applying(black)
    
    lazy var writeButton = UIBarButtonItem(title: "",
                                           image: UIImage(systemName: "square.and.pencil", withConfiguration: combined),
                                           primaryAction: nil,
                                           menu: nil)
    lazy var authButton = UIBarButtonItem(title: "",
                                          image: UIImage(systemName: "person.circle", withConfiguration: combined),
                                          primaryAction: nil,
                                          menu: nil)
    
    var tableView: UITableView!
    
    // MARK: - Properties
    var bag = DisposeBag()

    var viewModel = HomeViewModel()

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "피드"
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.rightBarButtonItems = [authButton, writeButton]
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground

        configureView()
        configureSubView()
        bindRx()
        fetch()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: - Helpers
    private func fetch() {
        viewModel.fetchFeeds()
    }
}

// MARK: - BaseViewController
extension HomeViewController {

    func configureView() {
        tableView = UITableView()
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
        tableView.delegate = self
        view.addSubview(tableView)
        
        
        view.addSubview(textLabel)
    }
    
    func configureSubView() {
        textLabel.isHidden = true
        textLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

// MARK: - BindableViewController
extension HomeViewController {
    func bindRx() {
        bindViewModel()
    }
    
    func bindViewModel() {
        bindButtons()
        bindTableView()
    }
    
    func bindButtons() {
        writeButton
            .rx
            .tap
            .subscribe(onNext: { _ in
                print("write")
                // 로그인 했을 경우
                
                // 로그인 안 했을 경우
            })
            .disposed(by: bag)
        
        authButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] _ in
                print("profile")
                guard let self = self else { return }
                
                if self.viewModel.dependency.isLogInNeeded {
                    DispatchQueue.main.async {
                        let navVC = UINavigationController(rootViewController: SignInViewController())
                        self.navigationController?.present(navVC, animated: true)
                    }
                } else {
                    print("로그인 됐으니까 프로필로")
                    print("하지만 지금은 지운다")
                    
                    KeychainWrapper.standard.removeAllKeys()
                }
            })
            .disposed(by: bag)
    }
    
    func bindTableView() {
        
        viewModel.output.feeds
            .filter { $0 != nil }
            .map { $0! }
            .bind(to: tableView.rx.items(cellIdentifier: HomeTableViewCell.identifier, cellType: HomeTableViewCell.self)) { index, post, cell in
                cell.setData(model: post)
                UIView.performWithoutAnimation {
                    cell.layoutIfNeeded()
                }
            }
            .disposed(by: bag)
        
        viewModel.output.feeds
            .subscribe(onNext: { [weak self] feeds in
                if feeds?.isEmpty ?? false {
                    self?.textLabel.isHidden = false
                } else {
                    self?.textLabel.isHidden = true
                }
            })
            .disposed(by: bag)
        
        tableView
            .rx
            .modelSelected(ModelFeed.self)
            .subscribe(onNext: { [weak self] model in
                DispatchQueue.main.async {
                    let detailVC = DetailViewController()
                    detailVC.postId = model.id
                    self?.navigationController?.pushViewController(detailVC, animated: true)
                }
            })
            .disposed(by: bag)
    }
}


// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}
