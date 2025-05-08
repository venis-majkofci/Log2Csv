# Changelog

## [1.2.0] - 2025-05-08

### Added
- Introduced the `makeLog` function to centralize the parsing logic of changelog entries.
- Implemented support for changelogs without explicit "change type" sections, assigning a default type `"N/D"`.

### Changed
- Refactored `Convert-Changelog.ps1` to improve readability and maintainability.
- Adjusted parsing flow to dynamically handle the presence or absence of "change type" sections.

## [1.1.0] - 2025-01-08

### Added
- Support for `azurerm 4.x` changelogs in `changelog-config.json`.

## [1.0.0] - 2024-12-21

### Added
- Initial release with core functionality.
