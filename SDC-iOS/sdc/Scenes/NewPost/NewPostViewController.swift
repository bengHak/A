//
//  NewPostViewController.swift
//  sdc
//
//  Created by byunghak on 2021/11/05.
//

import UIKit
import SnapKit
import RxSwift
import Then

class NewPostViewController: UIViewController {
    
    // MARK: - UI Properties
    private let titleTextField = UITextField().then {
        $0.placeholder = "제목을 입력해주세요."
        $0.borderStyle = .roundedRect
        $0.font = UIFont.systemFont(ofSize: 24)
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
        $0.spellCheckingType = .no
        $0.returnKeyType = .done
    }
    
    private let contentTextView = UITextView().then {
        $0.text = "내용을 입력해주세요"
        $0.font = UIFont.systemFont(ofSize: 18)
        $0.textColor = .lightGray
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
        $0.spellCheckingType = .no
        $0.returnKeyType = .done
    }
    
    private let uploadButton = UIButton().then {
        $0.setTitle("업로드", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemBlue
        $0.layer.cornerRadius = 5
    }
    
    private let dismissButton = UIButton().then {
        $0.setTitle("닫기", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.layer.cornerRadius = 5
    }
    
    
    // MARK: - Properties
    var bag = DisposeBag()
    var viewModel = NewPostViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "새 글 작성"
        view.backgroundColor = .systemBackground
        
        configureView()
        configureSubviews()
        
        bindRx()
    }
    
    // MARK: - Helper
    private func showEmptyAlert() {
        let alert = UIAlertController(title: "제목과 내용을 모두 입력해주세요.", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func showUploadFailedAlert() {
        let alert = UIAlertController(title: "업로드에 실패했습니다.", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


// MARK: - BaseViewController
extension NewPostViewController {
    
    func configureView() {
        view.addSubview(titleTextField)
        view.addSubview(contentTextView)
        view.addSubview(uploadButton)
        view.addSubview(dismissButton)
    }
    
    func configureSubviews() {
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(450)
        }
        
        uploadButton.snp.makeConstraints {
            $0.top.equalTo(contentTextView.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(50)
        }
        
        dismissButton.snp.makeConstraints {
            $0.top.equalTo(uploadButton.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(50)
        }
        
    }
    
}

// MARK: - BindableViewController
extension NewPostViewController {
    func bindRx() {
        bindTextFields()
        bindButtons()
        bindViewModel()
    }
    
    private func bindTextFields() {
        titleTextField.rx.text.orEmpty
            .bind(to: viewModel.input.title)
            .disposed(by: bag)
        
        contentTextView.rx.text.orEmpty
            .bind(to: viewModel.input.content)
            .disposed(by: bag)
        
        contentTextView.rx.didBeginEditing
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                if(self.contentTextView.text == "내용을 입력해주세요" ){
                    self.contentTextView.text = nil
                    self.contentTextView.textColor = .secondaryLabel
                }}).disposed(by: bag)
        
        contentTextView.rx.didEndEditing
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                if(self.contentTextView.text == nil || self.contentTextView.text == ""){
                    self.contentTextView.text = "내용을 입력해주세요"
                    self.contentTextView.textColor = .lightGray
                }}).disposed(by: bag)
    }
    
    private func bindButtons() {
        uploadButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                guard let title = self.titleTextField.text,
                      let content = self.contentTextView.text else {
                          return
                      }
                
                guard !title.isEmpty, !content.isEmpty else {
                    self.showEmptyAlert()
                    return
                }
                
                self.viewModel.uploadPost(title: title, content: content)
            }).disposed(by: bag)
        
        dismissButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.navigationController?.dismiss(animated: true, completion: nil)
            }).disposed(by: bag)
    }
    
    private func bindViewModel() {
        viewModel.dependency.uploadPostDone
            .subscribe(onNext: { [weak self] done in
                guard let self = self else { return }
                if done {
                    self.navigationController?.dismiss(animated: true, completion: nil)
                } else {
                    self.showUploadFailedAlert()
                }
            }).disposed(by: bag)
    }
}
