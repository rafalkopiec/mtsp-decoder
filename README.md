## mtsp-decoder

This is a Swift-based decoder for the `.mtsp` container, which is designed to be hosted alongside a website's `index.html`. 
For more information on `.mtsp`, visit [github.com/rafalkopiec/mtsp](https://github.com/rafalkopiec/mtsp).

### Usage:
- Add `MTSPDecoder` as an Swift Package Manager dependency `https://github.com/rafalkopiec/mtsp-decoder.git`.
- Initialise the `Decoder` class in your data model.
- Pass in a URL of a metaspace-supported website, such as [https://metaspace.rocks/mtsp](https://metaspace.rocks/mtsp).
- You will get back an optional `Container` if the download and parsing of the file was successful.
- The `Decoder` class has a published `containers` dictionary, and the parsed `Container` will be added to that on success.
- Subscribing to the published dictionary is recommended.

This `MTSPDecoder` swift-package module is minimal, and is covered with unit tests.
