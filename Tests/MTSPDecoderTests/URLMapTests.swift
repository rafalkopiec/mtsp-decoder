// Copyright 2024 Rafal Kopiec
// https://metaspace.rocks/mtsp
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import XCTest
@testable import MTSPDecoder

final class URLMapTests: XCTestCase {
    func testURL_fromExact_Succeed() {
        let input = URL(string: "https://metaspace.rocks/mtsp/index.mtsp")!
        let expected = URL(string: "https://metaspace.rocks/mtsp/index.mtsp")!
        let result = URLMap.getContainerURL(from: input)
        XCTAssertEqual(expected, result)
    }

    func testURL_FromIndex_Succeed() {
        let input = URL(string: "https://metaspace.rocks/mtsp/index.html")!
        let expected = URL(string: "https://metaspace.rocks/mtsp/index.mtsp")!
        let result = URLMap.getContainerURL(from: input)
        XCTAssertEqual(expected, result)
    }

    func testURL_FromIndexEmptyExtension_Fail() {
        let input = URL(string: "https://metaspace.rocks/mtsp/index.")!
        let result = URLMap.getContainerURL(from: input)
        XCTAssertNil(result)
    }

    func testURL_FromIndexNoExtension_Fail() {
        let input = URL(string: "https://metaspace.rocks/mtsp/index")!
        let result = URLMap.getContainerURL(from: input)
        XCTAssertNil(result)
    }

    func testURL_NoLastPath_Succeed() {
        let input = URL(string: "https://metaspace.rocks/mtsp/")!
        let expected = URL(string: "https://metaspace.rocks/mtsp/index.mtsp")!
        let result = URLMap.getContainerURL(from: input)
        XCTAssertEqual(expected, result)
    }

    func testPreviewURL_ViablePath_Succeed() {
        let path = "preview.jpg"
        let containerURL = URL(string: "https://metaspace.rocks/mtsp/index.mtsp")!
        let expected = URL(string: "https://metaspace.rocks/mtsp/preview.jpg")!
        let result = URLMap.getFileURL(from: path, using: containerURL)
        XCTAssertEqual(expected, result)
    }

    func testPreviewURL_NonViablePath_Fail() {
        let path = "preview"
        let containerURL = URL(string: "https://metaspace.rocks/mtsp/index.mtsp")!
        let result = URLMap.getFileURL(from: path, using: containerURL)
        XCTAssertNil(result)
    }

    func testPreviewURL_EmptyPath_Fail() {
        let path = ""
        let containerURL = URL(string: "https://metaspace.rocks/mtsp/index.mtsp")!
        let result = URLMap.getFileURL(from: path, using: containerURL)
        XCTAssertNil(result)
    }

    func testNavigationURL_ViablePath_Succeed() {
        let path = "some_path -> result/index.mtsp"
        let containerURL = URL(string: "https://metaspace.rocks/mtsp/index.mtsp")!
        let expected = URL(string: "https://metaspace.rocks/mtsp/result/index.mtsp")
        let result = URLMap.getNavigationURL(from: path, separator: " -> ", using: containerURL)
        XCTAssertEqual(expected, result)
    }

    func testNavigationURL_ViablePathUpOneLevel_Succeed() {
        let path = "some_path -> ../index.mtsp"
        let containerURL = URL(string: "https://metaspace.rocks/mtsp/index.mtsp")!
        let expected = URL(string: "https://metaspace.rocks/index.mtsp")
        let result = URLMap.getNavigationURL(from: path, separator: " -> ", using: containerURL)
        XCTAssertEqual(expected, result)
    }

    func testNavigationURL_ViablePathUpTwoLevels_Succeed() {
        let path = "some_path -> ../../index.mtsp"
        let containerURL = URL(string: "https://metaspace.rocks/mtsp/path/index.mtsp")!
        let expected = URL(string: "https://metaspace.rocks/index.mtsp")
        let result = URLMap.getNavigationURL(from: path, separator: " -> ", using: containerURL)
        XCTAssertEqual(expected, result)
    }

    func testNavigationURL_NonViablePath_Fail() {
        let path = "some_path - result/index.mtsp"
        let containerURL = URL(string: "https://metaspace.rocks/mtsp/index.mtsp")!
        let expected = URL(string: "https://metaspace.rocks/mtsp/result/index.mtsp")
        let result = URLMap.getNavigationURL(from: path, separator: " -> ", using: containerURL)
        XCTAssertNotEqual(expected, result)
    }
}
