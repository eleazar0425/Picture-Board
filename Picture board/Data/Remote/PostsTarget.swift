//
//  PostsTarget.swift
//  Picture board
//
//  Created by Eleazar Estrella on 2/12/21.
//

import Foundation
import Moya

enum PostsTarget {
    case getPosts
}

extension PostsTarget: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://mock.koombea.io/mt/api")!
    }
    
    var path: String {
        return "/posts"
    }
    
    var headers: [String : String]? {
        return [:]
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self{
        case .getPosts:
            return .requestPlain
        }
    }
}
