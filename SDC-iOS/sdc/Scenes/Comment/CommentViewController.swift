//
//  CommentViewController.swift
//  sdc
//
//  Created by byunghak on 2021/11/05.
//

import UIKit
import SnapKit
import RxSwift
import Then

class CommentViewController: UIViewController {
    
    
    // MARK: - UI properties
    var tableView: UITableView!

    private let textLabel = UILabel().then {
        $0.text = "첫 댓글을 달아주세요 👇👇👇"
        $0.font = UIFont.systemFont(ofSize: 20)
        $0.isHidden = true
    }
    
    // bottom comment text field box
    private let commentTextField = UITextField().then {
        $0.placeholder = "댓글을 입력해주세요"
        $0.font = UIFont.systemFont(ofSize: 20)
        $0.borderStyle = .roundedRect
        $0.returnKeyType = .done
        $0.enablesReturnKeyAutomatically = true
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
    }

    // MARK: - Properties
    var bag = DisposeBag()
    var viewModel = CommentViewModel()
    
    var postId: Int?
    
    // MARK: - Lifecycle
    init(postId: Int) {
        self.postId = postId
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "댓글"
        view.backgroundColor = .systemBackground
        
        configureView()
        configureSubViews()
        bindRx()
        fetch()
    }
    
    
    // MARK: - Helper
    func fetch() {
        guard let postId = self.postId else { return }
        viewModel.fetchComments(postId)
    }
}

// MARK: - BaseViewController
extension CommentViewController {
    
    private func configureView() {
        tableView = UITableView()
        tableView.register(CommentTableCell.self, forCellReuseIdentifier: CommentTableCell.identifier)
        tableView.delegate = self

        view.addSubview(tableView)
        view.addSubview(textLabel)
        view.addSubview(commentTextField)
    }
    
    private func configureSubViews() {
        commentTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-20)
            $0.height.equalTo(50)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(commentTextField.snp.top)
        }

        textLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

// MARK: - BindableViewController
extension CommentViewController {
    func bindRx() {
        
        bindTableView()
        bindViewModel()
    }
    
    private func bindTableView() {
        viewModel.output.comments
            .filter { $0 != nil }
            .map { $0! }
            .bind(to: tableView.rx.items(cellIdentifier: CommentTableCell.identifier, cellType: CommentTableCell.self)) { index, comment, cell in
                cell.setData(model: comment)
                cell.selectionStyle = .none
                UIView.performWithoutAnimation {
                    cell.layoutIfNeeded()
                }
            }
            .disposed(by: bag)
        
        viewModel.output.comments
            .subscribe(onNext: { [weak self] feeds in
                if feeds?.isEmpty ?? false {
                    self?.textLabel.isHidden = false
                } else {
                    self?.textLabel.isHidden = true
                }
            })
            .disposed(by: bag)
    }
    
    private func bindViewModel() {

    }
}

// MARK: - UITableViewDelegate
extension CommentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
