//
//  Post.swift
//  Picture board
//
//  Created by Eleazar Estrella on 2/12/21.
//

import Foundation
import Mapper

class PostContent: Mappable {
    var id: Int
    var date: String
    var pictures: Array<String>

    required init(map: Mapper) throws {
        try id = map.from("id")
        try date = map.from("date")
        try pictures = map.from("pics")
    }
    
    init(id: Int, date: String, pictures: Array<String>){
        self.id = id
        self.date = date
        self.pictures = pictures
    }
}


class Post: Mappable {
    var id, name, email, profilePicture: String
    var content: PostContent
    
    required init(map: Mapper) throws {
        try id = map.from("uid")
        try name = map.from("name")
        try email = map.from("email")
        try profilePicture = map.from("profile_pic")
        try content = map.from("post")
    }
    
    init(id: String, name: String, email: String, profilePicture: String, content: PostContent){
        self.id = id
        self.name = name
        self.email = email
        self.profilePicture = profilePicture
        self.content = content
    }
}
