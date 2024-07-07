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

final class ParserTests: XCTestCase {
    func testParse_Valid_Succeed() throws {
        let containerURL = URL(string: "https://metaspace.rocks/mtsp/index.html")!
        let input: String = """
        // Copyright 2024 Rafal Kopiec
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

        #METASPACE_HOST
        #METASPACE_VERSION:1
        #METASPACE_NAME:"Untitled"
        #METASPACE_PREVIEW_PATH:"preview.jpg"
        #METASPACE_3D_PATH:"file.usdz"
        """

        let expected = Container(
            name: "Untitled",
            previewImageURL: URL(string: "https://metaspace.rocks/mtsp/preview.jpg")!,
            sceneURL: URL(string: "https://metaspace.rocks/mtsp/file.usdz")!
        )

        let data = input.data(using: .utf8)!
        let result = try Parser.parse(data, containerURL: containerURL)

        XCTAssertEqual(expected, result)
    }

    func testParse_BadURL_Fail() throws {
        let containerURL = URL(string: "https://metaspace.rocks/mtsp")!
        let input: String = """
        // Copyright 2024 Rafal Kopiec
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

        #METASPACE_HOST
        #METASPACE_VERSION:1
        #METASPACE_NAME:"Untitled"
        #METASPACE_PREVIEW_PATH:"preview.jpg"
        #METASPACE_3D_PATH:"file.usdz"
        """

        let expected = Container(
            name: "Untitled",
            previewImageURL: URL(string: "https://metaspace.rocks/mtsp/preview.jpg")!,
            sceneURL: URL(string: "https://metaspace.rocks/mtsp/file.usdz")!
        )

        let data = input.data(using: .utf8)!
        let result = try Parser.parse(data, containerURL: containerURL)

        XCTAssertNotEqual(expected, result)
    }

    func testParse_MissingHost_Fail() throws {
        let containerURL = URL(string: "https://metaspace.rocks/mtsp/index.html")!
        let input: String = """
        // Copyright 2024 Rafal Kopiec
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

        #METASPACE_VERSION:1
        #METASPACE_NAME:"Untitled"
        #METASPACE_PREVIEW_PATH:"preview.jpg"
        #METASPACE_3D_PATH:"file.usdz"
        """

        let data = input.data(using: .utf8)!

        do {
            let _ = try Parser.parse(data, containerURL: containerURL)
            XCTFail("Expected to throw")
        } catch {
            XCTAssertEqual(DecoderError.containerNotRecognised, error as! DecoderError)
        }
    }

    func testParse_MissingVersion_Fail() throws {
        let containerURL = URL(string: "https://metaspace.rocks/mtsp/index.html")!
        let input: String = """
        // Copyright 2024 Rafal Kopiec
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

        #METASPACE_HOST
        #METASPACE_NAME:"Untitled"
        #METASPACE_PREVIEW_PATH:"preview.jpg"
        #METASPACE_3D_PATH:"file.usdz"
        """

        let data = input.data(using: .utf8)!

        do {
            let _ = try Parser.parse(data, containerURL: containerURL)
            XCTFail("Expected to throw")
        } catch {
            XCTAssertEqual(DecoderError.containerNotRecognised, error as! DecoderError)
        }
    }

    func testParse_MissingName_Fail() throws {
        let containerURL = URL(string: "https://metaspace.rocks/mtsp/index.html")!
        let input: String = """
        // Copyright 2024 Rafal Kopiec
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

        #METASPACE_HOST
        #METASPACE_VERSION:1
        #METASPACE_PREVIEW_PATH:"preview.jpg"
        #METASPACE_3D_PATH:"file.usdz"
        """

        let data = input.data(using: .utf8)!

        do {
            let _ = try Parser.parse(data, containerURL: containerURL)
            XCTFail("Expected to throw")
        } catch {
            XCTAssertEqual(DecoderError.containerNotRecognised, error as! DecoderError)
        }
    }

    func testParse_MissingPreview_Fail() throws {
        let containerURL = URL(string: "https://metaspace.rocks/mtsp/index.html")!
        let input: String = """
        // Copyright 2024 Rafal Kopiec
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

        #METASPACE_HOST
        #METASPACE_VERSION:1
        #METASPACE_NAME:"Untitled"
        #METASPACE_3D_PATH:"file.usdz"
        """

        let data = input.data(using: .utf8)!

        do {
            let _ = try Parser.parse(data, containerURL: containerURL)
            XCTFail("Expected to throw")
        } catch {
            XCTAssertEqual(DecoderError.containerNoPreviewURL, error as! DecoderError)
        }
    }

    func testParse_Missing3DPath_Fail() throws {
        let containerURL = URL(string: "https://metaspace.rocks/mtsp/index.html")!
        let input: String = """
        // Copyright 2024 Rafal Kopiec
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

        #METASPACE_HOST
        #METASPACE_VERSION:1
        #METASPACE_NAME:"Untitled"
        #METASPACE_PREVIEW_PATH:"preview.jpg"
        """

        let data = input.data(using: .utf8)!

        do {
            let _ = try Parser.parse(data, containerURL: containerURL)
            XCTFail("Expected to throw")
        } catch {
            XCTAssertEqual(DecoderError.containerNoSceneURL, error as! DecoderError)
        }
    }
}
