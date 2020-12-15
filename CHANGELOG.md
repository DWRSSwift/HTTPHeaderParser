# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Support for `Retry-After` header


## [0.2.1] - 2020-10-26
### Fixed
- `rel` subscript on `LinkHeader` is now exposed publicly

## [0.2.0] - 2020-10-26
### Added
- This changelog
- Support for looking up links in a header by `rel`
### Changed
- `Link.parse(value:)` now returns a `LinkHeader` struct rather than `[LinkValue]`

## [0.1.0] - 2020-10-25
_Initial version_
### Added
- Support parsing `Link` headers

[Unreleased]: https://github.com/DWRSSwift/HTTPHeaderParser/compare/0.2.1...HEAD
[0.2.1]: https://github.com/DWRSSwift/HTTPHeaderParser/compare/0.2.0...0.2.1
[0.2.0]: https://github.com/DWRSSwift/HTTPHeaderParser/compare/0.1.0...0.2.0
[0.1.0]: https://github.com/DWRSSwift/HTTPHeaderParser/releases/tag/0.1.0
