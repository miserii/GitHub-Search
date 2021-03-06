//
//  GithubAPI.swift
//  GitHub-Search
//
//  Created by 逢坂 美芹 on 2021/01/23.
//

import Alamofire
import RxSwift

final class GithubAPI {
//  static let shared = GithubAPI()
//  private init() {}

// successとエラーで分ける
  static func get(searchWord: String, isDesc: Bool = true, success: (([GithubEntity]) -> Void)? = nil, error: ((Error) -> Void)? = nil) {
    guard searchWord.count > 0 else {
      success?([])
      return
    }
    AF.request("https://api.github.com/search/repositories?q=\(searchWord)&sort=stars&order=\(isDesc ? "desc" : "asc")").response { response in
      switch response.result {
      case .success:
        guard
          let data = response.data,
          let githubResponse = try? JSONDecoder().decode(GithubResponse.self, from: data),
          let models = githubResponse.items
        else
        {
          success?([])
          return
        }
        success?(models)
      case .failure(let err):
        error?(err)
      }
    }
  }

}

extension GithubAPI: ReactiveCompatible {}

extension Reactive where Base: GithubAPI {

  static func get(searchWord: String, isDesc: Bool = true) -> Observable<[GithubEntity]> {
    return Observable.create { observer in
      GithubAPI.get(searchWord: searchWord, success: { models in
        // successの時
        observer.on(.next(models))
      }, error: { err in
        // errorのとき
        observer.on(.error(err))
      })
      return Disposables.create()
    }.share(replay: 1, scope: .whileConnected)
  }

}
