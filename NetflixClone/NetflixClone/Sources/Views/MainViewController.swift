//
//  MainViewController.swift
//  NetflixClone
//
//  Created by t0000-m0112 on 2024-12-24.
//

import UIKit
import SnapKit
import RxSwift
import AVKit

class MainViewController: UIViewController {
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let viewModel = MainViewModel()
    private var popularMovies = [Movie]()
    private var topRatedMovies = [Movie]()
    private var upcomingMovies = [Movie]()
    
    private let label = UILabel().then {
        $0.text = "NEATFLIX"
        $0.textColor = UIColor(red: 229/255, green: 9/255, blue: 20/255, alpha: 1.0)
        $0.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.register(PosterCell.self, forCellWithReuseIdentifier: PosterCell.identifer)
        $0.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.identifer)
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configureUI()
    }
    
    private func bind() {
        viewModel.popularMovieSubject
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] movies in
                    self?.popularMovies = movies
                    self?.collectionView.reloadData()
                },
                onError: { error in
                    print("Error: \(error)")
                }
            ).disposed(by: disposeBag)
        
        viewModel.topRatedMovieSubject
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] movies in
                    self?.topRatedMovies = movies
                    self?.collectionView.reloadData()
                },
                onError: { error in
                    print("Error: \(error)")
                }
            ).disposed(by: disposeBag)
        
        viewModel.upcomingMovieSubject
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] movies in
                    self?.upcomingMovies = movies
                    self?.collectionView.reloadData()
                },
                onError: { error in
                    print("Error: \(error)")
                }
            ).disposed(by: disposeBag)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        // 각 아이템의 크기는 각 그룹 내에서 전체 너비와 전체 높이를 차지
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // 각 그룹의 크기는 화면 너비의 25%를 차지하고, 높이는 22%를 자치
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.25),
            heightDimension: .fractionalHeight(0.22)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        section.contentInsets = .init(top: 10, leading: 10, bottom: 20, trailing: 10)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44)
        )
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        section.boundarySupplementaryItems = [header]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func configureUI() {
        view.backgroundColor = .black
        [
            label,
            collectionView
        ].forEach {
            view.addSubview($0)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(10)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide.snp.horizontalEdges)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func playVideoUrl() {
        let url = URL(string: "https://storage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4")!
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        present(playerViewController, animated: true) {
            player.play()
        }
    }
}

enum Section: Int, CaseIterable {
    case popularMovies
    case topRatedMovies
    case upcomingMovies
    
    var title: String {
        switch self {
        case .popularMovies: return "이 시간 핫한 영화"
        case .topRatedMovies: return "가장 평점이 높은 영화"
        case .upcomingMovies: return "곧 개봉되는 영화"
        }
    }
}

extension MainViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .popularMovies: return popularMovies.count
        case .topRatedMovies: return topRatedMovies.count
        case .upcomingMovies: return upcomingMovies.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCell.identifer, for: indexPath) as? PosterCell else {
            return UICollectionViewCell()
        }
        
        switch Section(rawValue: indexPath.section) {
        case .popularMovies:
            cell.configure(with: popularMovies[indexPath.row])
        case .topRatedMovies:
            cell.configure(with: topRatedMovies[indexPath.row])
        case .upcomingMovies:
            cell.configure(with: upcomingMovies[indexPath.row])
        default:
            return UICollectionViewCell()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SectionHeaderView.identifer,
            for: indexPath
        ) as? SectionHeaderView else { return UICollectionReusableView() }
        
        let sectionType = Section.allCases[indexPath.section]
        headerView.configure(with: sectionType.title)
        return headerView
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch Section(rawValue: indexPath.section) {
        case .popularMovies:
            viewModel.fetchTrailerKey(movie: popularMovies[indexPath.row])
                .observe(on: MainScheduler.instance)
                .subscribe(
                    onSuccess: { [weak self] key in
                        self?.navigationController?.pushViewController(YoutubeViewController(key: key), animated: true)
                    }, onFailure: { error in
                        print("Error: \(error)")
                    }
                ).disposed(by: disposeBag)
            
        case .topRatedMovies:
            viewModel.fetchTrailerKey(movie: topRatedMovies[indexPath.row])
                .observe(on: MainScheduler.instance)
                .subscribe(
                    onSuccess: { [weak self] key in
                        self?.navigationController?.pushViewController(YoutubeViewController(key: key), animated: true)
                    }, onFailure: { error in
                        print("Error: \(error)")
                    }
                ).disposed(by: disposeBag)
            
        case .upcomingMovies:
            viewModel.fetchTrailerKey(movie: upcomingMovies[indexPath.row])
                .observe(on: MainScheduler.instance)
                .subscribe(
                    onSuccess: { [weak self] key in
                        self?.navigationController?.pushViewController(YoutubeViewController(key: key), animated: true)
                    }, onFailure: { error in
                        print("Error: \(error)")
                    }
                ).disposed(by: disposeBag)
            
        default:
            return
        }
    }
}
