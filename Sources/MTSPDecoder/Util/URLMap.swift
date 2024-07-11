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

internal enum URLMap {
    private static let pathExtension: String = "mtsp"

    static func getContainerURL(from url: URL) -> URL? {
        guard url.pathExtension != pathExtension else {
            return url
        }

        guard url.pathExtension.isEmpty else {
            return url.deletingPathExtension().appendingPathExtension(pathExtension)
        }

        guard !url.hasDirectoryPath else {
            return url.appending(path: "index").appendingPathExtension(pathExtension)
        }

        return nil
    }

    static func getFileURL(from path: String?, using containerURL: URL) -> URL? {
        guard let path else {
            return nil
        }
        
        guard !path.isEmpty else {
            return nil
        }

        guard path.contains(".") else {
            return nil
        }

        return containerURL.deletingLastPathComponent().appending(component: path)
    }

    static func getNavigationURL(from path: String, separator: String, using containerURL: URL) -> URL? {
        guard path.contains(separator) else {
            return nil
        }

        let components = path.components(separatedBy: separator)

        guard components.count == 2 else {
            return nil
        }

        var containerURL = containerURL.deletingLastPathComponent()
        var upPathComponents = components[1].components(separatedBy: "../")
        let count = upPathComponents.count - 1

        if count > 0 {
            for _ in 0..<count {
                upPathComponents.removeFirst()
                containerURL.deleteLastPathComponent()
            }
        }

        return containerURL.appending(path: upPathComponents.joined())
    }
}
