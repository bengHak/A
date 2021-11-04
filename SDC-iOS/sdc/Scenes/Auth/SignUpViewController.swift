//
//  SignUpViewController.swift
//  sdc
//
//  Created by byunghak on 2021/11/04.
//

import UIKit
import SnapKit
import RxSwift
import Then

class SignUpViewController: UIViewController {
    
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
    
    private let passwordConfirmationLabel = UILabel().then {
        $0.text = "비밀번호 확인"
        $0.font = .systemFont(ofSize: 18)
    }
    
    private let passwordConfirmationTextView = UITextField().then {
        $0.placeholder = "비밀번호를 한번 더 입력해주세요"
        $0.isSecureTextEntry = true
    }

    private let passwordErrorMessage = UILabel().then {
        $0.text = "비밀번호가 일치하지 않습니다."
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .systemRed
    }

    private let signUpButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 18)
        $0.backgroundColor = .systemBlue
        $0.layer.cornerRadius = 8
    }
    
    // MARK: - Properties
    var bag = DisposeBag()
    var viewModel = SignUpViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "회원가입"
        view.backgroundColor = .systemBackground

        configureView()
        configureSubViews()
    }

    // MARK: - Helper
}

// MARK: - BaseViewController
extension SignUpViewController {

    func configureView() {
        view.addSubview(emailLabel)
        view.addSubview(emailTextView)
        view.addSubview(emailTypeErrorMessage)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextView)
        view.addSubview(passwordConfirmationLabel)
        view.addSubview(passwordConfirmationTextView)
        view.addSubview(passwordErrorMessage)
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
            $0.leading.equalTo(emailTextView)
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
        
        passwordConfirmationLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextView.snp.bottom).offset(32)
            $0.leading.equalTo(emailLabel)
        }

        passwordConfirmationTextView.snp.makeConstraints {
            $0.top.equalTo(passwordConfirmationLabel.snp.bottom).offset(8)
            $0.leading.equalTo(emailLabel)
            $0.trailing.equalTo(view).offset(-32)
        }

        passwordErrorMessage.snp.makeConstraints {
            $0.top.equalTo(passwordConfirmationTextView.snp.bottom).offset(8)
            $0.leading.equalTo(emailLabel)
            $0.trailing.equalTo(view).offset(-32)
        }

        signUpButton.snp.makeConstraints {
            $0.top.equalTo(passwordErrorMessage.snp.bottom).offset(32)
            $0.leading.equalTo(emailLabel)
            $0.trailing.equalTo(view).offset(-32)
            $0.height.equalTo(48)
        }
    }
}
