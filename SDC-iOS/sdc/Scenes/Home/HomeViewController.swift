//
//  HomeViewController.swift
//  sdc
//
//  Created by byunghak on 2021/11/02.
//

import UIKit
import SnapKit
import Then

class HomeViewController: UIViewController {
    
    private let textLabel = UILabel().then {
        $0.text = "Home"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 30)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        configureView()
    }
}

extension HomeViewController {

    func configureView() {
        view.addSubview(textLabel)
        textLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
