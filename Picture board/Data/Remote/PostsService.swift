//
//  PostsService.swift
//  Picture board
//
//  Created by Eleazar Estrella on 2/12/21.
//

import Foundation
import RxSwift
import Moya
import Moya_ModelMapper

class PostsService: PostsDataSource {
    var provider: MoyaProvider<PostsTarget>
        
    init(provider: MoyaProvider<PostsTarget> = MoyaProvider<PostsTarget>(plugins: [NetworkLoggerPlugin()])){
        self.provider = provider
    }
    
    func getPosts() -> Observable<Result<[Post], Error>> {
        let target = PostsTarget.getPosts
        return provider.rx.request(target)
            .retry(3)
            .map(to: PostResponse.self)
            .flatMap{.just($0.data)}
            .asObservable()
            .map(Result.success)
            .catchError { error -> Observable<Result<[Post], Error>> in
                return .just(Result<[Post], Error>.failure(error))
            }
    }
}
