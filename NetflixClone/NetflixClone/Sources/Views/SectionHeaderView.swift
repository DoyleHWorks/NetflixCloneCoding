//
//  SectionHeaderView.swift
//  NetflixClone
//
//  Created by t0000-m0112 on 2024-12-24.
//

import UIKit
import SnapKit
import Then

class SectionHeaderView: UICollectionReusableView {
    // MARK: - Properties
    static let identifer = "SectionHeader"
    
    let titleLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 18)
        $0.textColor = .white
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func setupUI() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}
