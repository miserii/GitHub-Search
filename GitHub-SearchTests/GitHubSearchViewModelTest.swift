//
//  GitHubSearchViewModelTest.swift
//  GitHub-SearchTests
//
//  Created by OsakaMiseri on 2021/04/06.
//

import RxSwift
import RxCocoa
import XCTest
@testable import GitHub_Search

class GithubSearchViewModelTest: XCTestCase {

    func test() {
        let dependency = Dependency()
        let viewModel = dependency.testTarget

        let repository = GithubEntity(id: 1, name: "", fullName: "")
        let disposeBag = DisposeBag()

        let searchResults = BehaviorRelay<[GithubEntity]>(value: [])
        dependency.testTarget
            .bind(to: searchResults)
            .disposed(by: disposeBag)

        let searchTextResult = BehaviorRelay<String?>(value: nil)
        dependency.testTarget
            .bind(to: searchTextResult)
            .disposed(by: disposeBag)

        let searchText = "test"

        guard let searchTextResultValue = searchTextResult.value else {
            XCTFail(" searchTextResult.value is nil")
            return
        }

        XCTAssertEqual(searchTextResultValue, searchText)

        guard let repositoryResult = searchResults.value.first else {
            XCTFail("searchResults.value.first is nil")
            return
        }

        XCTAssertEqual(repositoryResult.fullName, repository.name)
        XCTAssertEqual(repositoryResult.urlStr, repository.urlStr)
    }

}

private extension GithubSearchViewModelTest {

    struct Dependency {
        let searchText = PublishRelay<String>()
        let testTarget: GithubSearchViewModel

        init() {
            self.testTarget = GithubSearchViewModel()
        }
    }

}

