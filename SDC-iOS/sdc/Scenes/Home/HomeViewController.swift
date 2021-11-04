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

class HomeViewController: UIViewController {
    
    // MARK: - UI properties
    private let textLabel = UILabel().then {
        $0.text = "글이 없어요 😢"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 30)
    }
    
    var tableView: UITableView!
    
    // MARK: - Properties
    var bag = DisposeBag()

    var viewModel = HomeViewModel()

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "피드"
        navigationItem.largeTitleDisplayMode = .automatic
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
        bindTableView()
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
            .subscribe(onNext: { model in
//                print(model)
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
