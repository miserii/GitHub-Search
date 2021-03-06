//
//  GithubModel.swift
//  GitHub-Search
//
//  Created by 逢坂 美芹 on 2021/01/23.
//

import Foundation

struct GithubResponse: Codable {
  var items: [GithubEntity]?
}

struct GithubEntity: Codable {

  let id: Int
  let name: String
  let fullName: String
  var urlStr: String { "https://github.com/\(fullName)" }

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case fullName = "full_name"
  }

}
