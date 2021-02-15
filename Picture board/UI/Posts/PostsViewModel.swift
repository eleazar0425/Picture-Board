//
//  PostsViewModel.swift
//  Picture board
//
//  Created by Eleazar Estrella on 2/15/21.
//

import Foundation
import RxSwift
import Action
import Nuke

protocol PostsViewModelInput {
    func refresh()
}

protocol PostsViewModelOutput {
    var posts: Observable<[Post]>! { get }
    var isLoading: Observable<Bool>! { get }
}


protocol PostsViewModelType {
    var inputs: PostsViewModelInput { get }
    var outputs: PostsViewModelOutput { get }
}


class PostsViewModel: PostsViewModelInput, PostsViewModelOutput, PostsViewModelType {
    
    //MARK: outputs
    var posts: Observable<[Post]>!
    var isLoading: Observable<Bool>!

    //MARK: inputs & outputs
    var inputs: PostsViewModelInput { return self }
    var outputs: PostsViewModelOutput { return self }
    
    //MARK: properties
    private let isLoadingProperty = BehaviorSubject<Bool>(value: true)
    private let interactor: PostInteractorType
    
    init(interactor: PostInteractorType = PostInteractor()){
        self.interactor = interactor
        isLoading = isLoadingProperty.asObservable()
        
        posts = isLoading.distinctUntilChanged()
            .flatMap({ isLoading -> Observable<[Post]> in
                return interactor.getPosts()
                    .flatMap { result -> Observable<[Post]> in
                        guard isLoading else { return .empty() }
                        self.isLoadingProperty.onNext(false)
                        switch result {
                        case let .success(posts):
                            return .just(posts)
                        case .failure(_):
                            return .empty()
                        }
                    }
            })
        
    }
    
    func refresh() {
        isLoadingProperty.onNext(true)
        //Clear image cache
        Nuke.DataLoader.sharedUrlCache.removeAllCachedResponses()
        Nuke.ImageCache.shared.removeAll()
    }
}
