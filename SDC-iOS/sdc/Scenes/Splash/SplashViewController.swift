//
//  SplashViewController.swift
//  sdc
//
//  Created by byunghak on 2021/11/02.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then

class SplashViewController: UIViewController {

    private let viewModel = SplashViewModel()

    private let bag = DisposeBag()

    private let textLabel = UILabel().then {
        $0.text = "Splash"
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 50, weight: .bold)
    }

    private let spinner = UIActivityIndicatorView(style: .large)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        bindRx()
        verifyAuthenticated()
    }
    
    // MARK: - Helpers
    
    private func move2Home() {
        let rootVC = HomeViewController()
        view.window?.rootViewController = rootVC
        view.window?.makeKeyAndVisible()
    }
    
    private func verifyAuthenticated() {
        viewModel.verifyToken()
    }
}


// MARK: - BaseViewController
extension SplashViewController {
    
    func configureView() {
        view.backgroundColor = .systemBackground
        view.addSubview(textLabel)
        view.addSubview(spinner)
        
        textLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-20)
        }
        
        spinner.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(50)
        }
    }
}

// MARK: - BindableViewController
extension SplashViewController {
    
    func bindRx() {
     
        viewModel.dependency.isLoading
            .subscribe(onNext:{ [weak self] isLoading in
                if isLoading {
                    self?.spinner.startAnimating()
                }
            })
            .disposed(by: bag)
        
        viewModel.output.isAuthenticated
            .subscribe(onNext: {[weak self] result in
                self?.spinner.stopAnimating()
                if result == true {
                    self?.move2Home()
                } else {
                    print("로그인 필요")
                }
            })
            .disposed(by: bag)
    }
}
