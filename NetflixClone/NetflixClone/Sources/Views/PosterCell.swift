//
//  PosterCell.swift
//  NetflixClone
//
//  Created by t0000-m0112 on 2024-12-24.
//

import UIKit
import Then

class PosterCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifer = "PosterCell"
    
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .darkGray
        $0.layer.cornerRadius = 10
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    func configure(with movie: Movie) {
        guard let posterPath = movie.posterPath else { return }
        let urlString = "https://image.tmdb.org/t/p/w500/\(posterPath).jpg"
        guard let url = URL(string: urlString) else { return }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.sync {
                        self?.imageView.image = image
                    }
                }
            }
        }
    }
}
