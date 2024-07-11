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

internal enum Parser {
    private static let mtspIdentifier: String = "#METASPACE_HOST"
    private static let mtspVersion: String = "#METASPACE_VERSION"
    private static let mtspName: String = "#METASPACE_NAME"
    private static let mtspPreviewPath: String = "#METASPACE_PREVIEW_PATH"
    private static let mtsp3DPath: String = "#METASPACE_3D_PATH"
    private static let mtspNavigation: String = "#METASPACE_NAVIGATION"
    private static let mtspNavigationSeparator: String = " -> "

    private static let mtspExpectedVersion: Int = 1

    static func parse(_ data: Data, containerURL: URL) throws -> Container? {
        guard let string = String(data: data, encoding: .utf8) else {
            throw DecoderError.containerNotReadable
        }

        let mtspLines = string
            .components(separatedBy: "\n")
            .filter { $0.hasPrefix("#") }

        guard mtspLines.contains(mtspIdentifier) else {
            throw DecoderError.containerNotRecognised
        }

        var version: Int?
        var name: String?
        var previewPath: String?
        var scenePath: String?
        var navigationPaths: [String] = []

        for line in mtspLines {
            switch line.components(separatedBy: ":").first {
            case mtspVersion: version = getIntFrom(line)
            case mtspName: name = getStringFrom(line)
            case mtspPreviewPath: previewPath = getStringFrom(line)
            case mtsp3DPath: scenePath = getStringFrom(line)
            case mtspNavigation: 
                if let path = getStringFrom(line) {
                    navigationPaths.append(path)
                }
            default: break
            }
        }

        guard version == mtspExpectedVersion, let name else {
            throw DecoderError.containerNotRecognised
        }

        guard let previewURL = URLMap.getFileURL(from: previewPath, using: containerURL) else {
            throw DecoderError.containerNoPreviewURL
        }

        guard let sceneURL = URLMap.getFileURL(from: scenePath, using: containerURL) else {
            throw DecoderError.containerNoSceneURL
        }

        var navigation: [String: URL] = [:]

        for navigationPath in navigationPaths {
            if let navigationURL = URLMap.getNavigationURL(
                from: navigationPath,
                separator: mtspNavigationSeparator,
                using: containerURL
            ) {
                if let dir = navigationPath.components(separatedBy: mtspNavigationSeparator).first {
                    navigation[dir] = navigationURL
                } else {
                    throw DecoderError.containerNavigationKeyNotRecognised
                }
            } else {
                throw DecoderError.containerNavigationPathNotRecognised
            }
        }

        return Container(
            name: name,
            previewImageURL: previewURL,
            sceneURL: sceneURL,
            navigation: navigation
        )
    }

    private static func getIntFrom(_ value: String) -> Int? {
        let components = value.components(separatedBy: ":")
        guard components.count == 2 else { return nil }
        return Int(components.last!)
    }

    private static func getStringFrom(_ value: String) -> String? {
        let components = value.components(separatedBy: ":")
        guard components.count == 2 else { return nil }
        return components.last!.replacingOccurrences(of: "\"", with: "")
    }
}
