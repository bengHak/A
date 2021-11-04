//
//  SignInViewController.swift
//  sdc
//
//  Created by byunghak on 2021/11/04.
//

import UIKit
import SnapKit
import RxSwift
//import RxCocoa
import Then

class SignInViewController: UIViewController {
    
    // MARK: - UI properties
    private let emailLabel = UILabel().then {
        $0.text = "이메일"
        $0.font = .systemFont(ofSize: 18)
    }
    
    private let emailTextView = UITextField().then {
        $0.placeholder = "이메일을 입력해주세요"
        $0.keyboardType = .emailAddress
    }
    
    private let emailTypeErrorMessage = UILabel().then {
        $0.text = "이메일 형식이 올바르지 않습니다."
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .red
        $0.isHidden = true
    }
    
    private let passwordLabel = UILabel().then {
        $0.text = "비밀번호"
        $0.font = .systemFont(ofSize: 18)
    }
    
    private let passwordTextView = UITextField().then {
        $0.placeholder = "비밀번호를 입력해주세요"
        $0.isSecureTextEntry = true
    }
    
    private let signInButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 18)
        $0.backgroundColor = .systemBlue
        $0.layer.cornerRadius = 8
    }
    
    private let signUpButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 18)
    }
    
    // MARK: - Properties
    var bag = DisposeBag()
    var viewModel = SignInViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "로그인"
        view.backgroundColor = .systemBackground
        
        configureView()
        configureSubViews()
        bindRx()
    }
    
    // MARK: - Helper
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

// MARK: - BaseViewController
extension SignInViewController {
    
    func configureView() {
        view.addSubview(emailLabel)
        view.addSubview(emailTextView)
        view.addSubview(emailTypeErrorMessage)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextView)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
    }
    
    func configureSubViews() {
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            $0.leading.equalTo(view).offset(32)
        }
        
        emailTextView.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(8)
            $0.leading.equalTo(emailLabel)
            $0.trailing.equalTo(view).offset(-32)
        }
        
        emailTypeErrorMessage.snp.makeConstraints {
            $0.top.equalTo(emailTextView.snp.bottom).offset(8)
            $0.leading.equalTo(emailLabel)
            $0.trailing.equalTo(view).offset(-32)
        }
        
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextView.snp.bottom).offset(32)
            $0.leading.equalTo(emailLabel)
        }
        
        passwordTextView.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(8)
            $0.leading.equalTo(emailLabel)
            $0.trailing.equalTo(view).offset(-32)
        }
        
        signInButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextView.snp.bottom).offset(32)
            $0.leading.equalTo(emailLabel)
            $0.trailing.equalTo(view).offset(-32)
            $0.height.equalTo(48)
        }
        
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(signInButton.snp.bottom).offset(8)
            $0.leading.equalTo(emailLabel)
            $0.trailing.equalTo(view).offset(-32)
            $0.height.equalTo(48)
        }
    }
}

// - MARK: - BindableViewController
extension SignInViewController {
    func bindRx() {
        bindViewModel()
        bindButtons()
        bindTextFields()
    }
    
    private func bindViewModel() {
        viewModel.input.email
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] email in
                guard let self = self else { return }
                
                if self.isValidEmail(email: email) {
                    self.emailTypeErrorMessage.isHidden = true
                } else {
                    self.emailTypeErrorMessage.isHidden = false
                }
            })
            .disposed(by: bag)
        
        viewModel.output.errorMessage
            .subscribe(onNext: { [weak self] errorMessage in
                guard let self = self else { return }
                self.showAlert(title: "로그인 실패", message: errorMessage)
            })
            .disposed(by: bag)
        
        viewModel.dependency.isSignedIn
            .subscribe(onNext: { [weak self] isSignedIn in
                guard let self = self else { return }
                if isSignedIn {
                    self.showAlert(title: "로그인 성공", message: "로그인이 성공하였습니다.", completion: {
                        self.navigationController?.dismiss(animated: true, completion: nil)
                    })
                }
            })
            .disposed(by: bag)
    }
    
    private func bindButtons() {
        signInButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.viewModel.signIn()
            })
            .disposed(by: bag)
        
        signUpButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let vc = SignUpViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: bag)
    }
    
    
    private func bindTextFields() {
        emailTextView.rx.text
            .orEmpty
            .bind(to: viewModel.input.email)
            .disposed(by: bag)
        
        passwordTextView.rx.text
            .orEmpty
            .bind(to: viewModel.input.password)
            .disposed(by: bag)
    }
}
