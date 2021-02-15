//
//  LocalPostDataSource.swift
//  Picture board
//
//  Created by Eleazar Estrella on 2/14/21.
//

import Foundation
import RxSwift

protocol LocalPostDataSource: PostsDataSource {
    func savePosts(posts: [Post]) -> Completable
}
