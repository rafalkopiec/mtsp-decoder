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

public struct Container: Equatable, Sendable, Hashable, Codable {
    /// The user-friendly name of a metaspace.
    public let name: String

    /// The preview image to show when not presenting the metaspace scene.
    public let previewImageURL: URL

    /// The URL to the metaspace scene, a `.usdz` 3D file.
    public let sceneURL: URL
}
