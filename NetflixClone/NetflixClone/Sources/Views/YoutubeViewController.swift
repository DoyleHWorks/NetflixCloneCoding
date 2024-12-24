//
//  YoutubeViewController.swift
//  NetflixClone
//
//  Created by t0000-m0112 on 2024-12-24.
//

import UIKit
import SnapKit
import YouTubeiOSPlayerHelper

class YoutubeViewController: UIViewController, YTPlayerViewDelegate {
    private let key: String
    private let playerView = YTPlayerView()
    
    init(key: String) {
        self.key = key
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        playerView.delegate = self
        playerView.load(withVideoId: key)
    }
    
    private func configureUI() {
        view.backgroundColor = .black
        view.addSubview(playerView)
        playerView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
}
