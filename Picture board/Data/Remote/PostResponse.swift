//
//  PostResponse.swift
//  Picture board
//
//  Created by Eleazar Estrella on 2/12/21.
//

import Foundation
import Mapper

class PostResponse: Mappable {
    var data: Array<Post>
    
    required init(map: Mapper) throws {
        try data = map.from("data")
    }
}
