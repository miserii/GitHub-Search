//
//  GithubListViewModelTest.swift
//  GitHub-SearchTests
//
//  Created by OsakaMiseri on 2021/03/14.
//

import RxSwift
import RxCocoa
import XCTest
@testable import GitHub_Search

class GithubListViewModelTest: XCTestCase {

    func test() {
        let dependency = Dependency()
        let viewModel = dependency.testTarget

        let repository = GithubListEntity(id: 1, name: "testName", fullName: "testFullName", htmlURL: "testHtmlUrl")
        let disposeBag = DisposeBag()

        let searchResults = BehaviorRelay<[GithubListEntity]>(value: [])
        dependency.testTarget.changeModelsObservable
            .bind(to: searchResults)
            .disposed(by: disposeBag)

        guard let repositoryResult = searchResults.value.first else {
            XCTFail("searchResults.value.first is nil")
            return
        }
        XCTAssertEqual(repositoryResult.name, repository.name)
        XCTAssertEqual(repositoryResult.htmlURL, repository.htmlURL)
    }

}

private extension GithubListViewModelTest {

    struct Dependency {
        let testTarget: GithubListViewModel
        init() {
            self.testTarget = .init()
        }
    }

}
