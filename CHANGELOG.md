# Changelog

## [2.3.0] - 2025-06-17

### Added
- Support for `terraform-provider-azuread` changelogs in `changelog-config.json`.
- 
## [2.2.1] - 2025-06-17

### Refactored
- Completed the change-type logic refactor by removing redundant use of `makeLog` in favor of inline extraction.

## [2.2.0] - 2025-06-17

### Enhanced
- Made change category detection more flexible: the parser now supports a mix of categorized and uncategorized entries within the same changelog.
- Set default entry type to `"N/D"` when no change category is matched, enabling smoother fallback behavior.

### Deprecated
- The `"change-type"` config field is now ignored. It is still accepted in config files for backward compatibility but no longer affects parsing behavior.

## [2.1.0] - 2025-05-08

### Added
- Support for `helm-chart-sonarqube` changelogs in `changelog-config.json`.

## [2.0.0] - 2025-05-08

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
