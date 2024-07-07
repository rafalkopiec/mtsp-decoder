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

import Foundation

public class Decoder: ObservableObject {
    @Published public var containers: [URL: Container] = [:]

    /// The MTSP Decoder v1.0.
    /// Will store decoded `Container` in the published `containers` variable.
    /// To be used with remote URLs.
    /// Compatible with the v1.0 implementation of MTSP.
    /// [metaspace.rocks/mtsp](https://metaspace.rocks/mtsp)
    public init() { }

    /// Attempts to retrieve a `Container` from a given `url`.
    ///
    /// ```
    /// URL can be:
    ///         -`.../index.html`
    ///         -`.../index.mtsp`
    ///         -`.../`
    /// let url = URL(...)
    /// try await Decoder.decode(from: url) // "Container(...)"
    /// ```
    ///
    /// - Parameters:
    ///     - url: The `URL` from which to get the container file.
    ///
    /// - Returns: An optional container for the given `url`.
    @discardableResult
    public func decode(from url: URL) async throws -> Container? {
        guard let containerURL = URLMap.getContainerURL(from: url) else {
            throw DecoderError.containerURLNotFound
        }

        guard let data = try await Downloader.downloadFile(from: containerURL) else {
            throw DecoderError.containerNotAvailable
        }

        let container = try Parser.parse(data, containerURL: containerURL)
        containers[url] = container
        return container
    }
}
