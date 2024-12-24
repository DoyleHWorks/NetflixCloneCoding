//
//  MainViewModel.swift
//  NetflixClone
//
//  Created by t0000-m0112 on 2024-12-24.
//

import Foundation
import RxSwift

class MainViewModel {
    
    private let disposeBag = DisposeBag()
    private var apiKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
            fatalError("API Key not found in xcconfig!")
        }
        return key
    }
    
    // View가 구독할 Subject
    let popularMovieSubject = BehaviorSubject(value: [Movie]())
    let topRatedMovieSubject = BehaviorSubject(value: [Movie]())
    let upcomingMovieSubject = BehaviorSubject(value: [Movie]())
    
    init() {
        fetchPopularMovie()
        fetchTopRatedMovie()
        fetchUpcomingMovie()
    }
    
    // MARK: - Business Logics
    func fetchPopularMovie() {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)") else {
            popularMovieSubject.onError(NetworkError.invalidUrl)
            return
        }
        
        NetworkManager.shared.fetch(url: url)
            .subscribe(
                onSuccess: { [weak self] (movieResponse: MovieResponse) in
                    self?.popularMovieSubject.onNext(movieResponse.results)
                },
                onFailure: { [weak self] error in
                    self?.popularMovieSubject.onError(error)
                }
            ).disposed(by: disposeBag)
    }
    
    func fetchTopRatedMovie() {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=\(apiKey)") else {
            topRatedMovieSubject.onError(NetworkError.invalidUrl)
            return
        }
        
        NetworkManager.shared.fetch(url: url)
            .subscribe(
                onSuccess: { [weak self] (movieResponse: MovieResponse) in
                    self?.topRatedMovieSubject.onNext(movieResponse.results)
                },
                onFailure: { [weak self] error in
                    self?.topRatedMovieSubject.onError(error)
                }
            ).disposed(by: disposeBag)
    }
    
    func fetchUpcomingMovie() {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/tv/popular?api_key=\(apiKey)") else {
            upcomingMovieSubject.onError(NetworkError.invalidUrl)
            return
        }
        
        NetworkManager.shared.fetch(url: url)
            .subscribe(
                onSuccess: { [weak self] (movieResponse: MovieResponse) in
                    self?.upcomingMovieSubject.onNext(movieResponse.results)
                },
                onFailure: { [weak self] error in
                    self?.upcomingMovieSubject.onError(error)
                }
            ).disposed(by: disposeBag)
    }
}
