//
//  PostsDataSource.swift
//  Picture board
//
//  Created by Eleazar Estrella on 2/12/21.
//

import Foundation
import RxSwift
import Moya
import Moya_ModelMapper

protocol PostsDataSource {
    func getPosts() -> Observable<Result<[Post], Error>>
}
