//
//  PostInteractor.swift
//  Picture board
//
//  Created by Eleazar Estrella on 2/15/21.
//

import Foundation
import RxSwift

protocol PostInteractorType: PostsDataSource {
    
}

class PostInteractor: PostInteractorType {
    
    private var remoteDataSource: PostsDataSource
    private var localDataSource: LocalPostDataSource
    
    private var disposeBag: DisposeBag
    
    init(remoteDataSource: PostsDataSource = PostsService(), localDataSource: LocalPostDataSource = LocalPostService()) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
        self.disposeBag = DisposeBag()
    }
    
    func getPosts() -> Observable<Result<[Post], Error>> {
        if InternetConnectionManager.isConnectedToNetwork() {
            return remoteDataSource.getPosts()
                .flatMap { [self] result -> Observable<Result<[Post], Error>> in
                    // updates the loca data source
                    if case let .success(posts) = result {
                        localDataSource.savePosts(posts: posts)
                            .subscribe()
                            .disposed(by: self.disposeBag)
                    }
                    
                    return .just(result)
                }
        }else {
            return localDataSource.getPosts()
        }
    }
}
