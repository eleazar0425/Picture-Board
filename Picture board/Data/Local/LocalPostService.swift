//
//  LocalPostService.swift
//  Picture board
//
//  Created by Eleazar Estrella on 2/15/21.
//

import Foundation
import CouchbaseLiteSwift
import RxSwift

class LocalPostService : LocalPostDataSource {
    
    private let couchLiteIstance: CouchLiteDataBase
    
    private let PostsDocType = "posts_type"
    
    init(couchLiteIstance: CouchLiteDataBase = CouchLiteDataBase.shared) {
        self.couchLiteIstance = couchLiteIstance
    }
    
    func savePosts(posts: [Post]) -> Completable {
        for post in posts{
            
            var mutableDoc = self.couchLiteIstance.database.document(withID: post.id)?.toMutable()
            
            if mutableDoc == nil {
                mutableDoc = MutableDocument()
                    .setString(post.id, forKey: PostKeys.id.rawValue)
                    .setString(post.name, forKey: PostKeys.name.rawValue)
                    .setString(post.email, forKey: PostKeys.email.rawValue)
                    .setString(post.profilePicture, forKey: PostKeys.profilePic.rawValue)
                    .setInt(post.content.id, forKey: PostKeys.postId.rawValue)
                    .setDictionary(MutableDictionaryObject(data: [PostKeys.postId.rawValue: post.content.id, PostKeys.date.rawValue: post.content.date, PostKeys.pics.rawValue: post.content.pictures]), forKey: PostKeys.post.rawValue)
                    .setString(PostsDocType, forKey: "type")
            }
                
            do {
                try self.couchLiteIstance.database.saveDocument(mutableDoc!)
            } catch {
                return Completable.error(AppError(message: "Error saving document"))
            }
        }
        
        return Completable.empty()
    }
    
    func getPosts() -> Observable<Swift.Result<[Post], Error>> {
        return Single<Swift.Result<[Post], Error>>.create { [self] (single) -> Disposable in
            
            var posts: [Post] = []

            let query = QueryBuilder
              .select(SelectResult.all(), SelectResult.expression(Meta.id))
                .from(DataSource.database(couchLiteIstance.database))
                .where(Expression.property("type")
                .equalTo(Expression.string(PostsDocType)))

            do {
              for result in try query.execute() {
                guard let dict = result.dictionary(forKey: CouchLiteDataBase.DataBaseName),
                          let id = dict.string(forKey: PostKeys.id.rawValue),
                    let name = dict.string(forKey: PostKeys.name.rawValue),
                    let email = dict.string(forKey: PostKeys.email.rawValue),
                    let profilePic = dict.string(forKey: PostKeys.profilePic.rawValue),
                    let postDict = dict.dictionary(forKey: PostKeys.post.rawValue),
                    let postDate = postDict.string(forKey: PostKeys.date.rawValue),
                    let pictures = postDict.array(forKey: PostKeys.pics.rawValue) else {
                        continue
                    }

                    let post: Post = Post(
                        id: id,
                        name: name,
                        email: email,
                        profilePicture: profilePic,
                        content: PostContent(id: postDict.int(forKey: PostKeys.postId.rawValue), date: postDate, pictures: pictures.toArray().compactMap { String(describing: $0)} )
                        )
                    posts.append(post)
              }
                
                single(.success(Swift.Result.success(posts)))
                
              } catch {
                single(.error(AppError(message: "Error fetching document")))
            }

            
            return Disposables.create()
        }.asObservable()
    }
}
