![banner-log2csv](https://github.com/user-attachments/assets/2e1e0ba1-2c5c-478b-a20a-86eb33e2a938)

<div align="center">

[![GitHub license](https://img.shields.io/github/license/venis-majkofci/Log2Csv)](https://github.com/venis-majkofci/Log2Csv/blob/main/LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/venis-majkofci/Log2Csv)](https://github.com/venis-majkofci/Log2Csv/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/venis-majkofci/Log2Csv)](https://github.com/venis-majkofci/Log2Csv/network)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/venis-majkofci/Log2Csv)
[![GitHub issues](https://img.shields.io/github/issues/venis-majkofci/Log2Csv)](https://github.com/venis-majkofci/Log2Csv/issues)
[![GitHub contributors](https://img.shields.io/github/contributors/venis-majkofci/Log2Csv)](https://github.com/venis-majkofci/Log2Csv/graphs/contributors)
[![Built with PowerShell](https://img.shields.io/badge/Built%20with-PowerShell-blue)](https://www.electronjs.org/)
[![Buy Me A Coffee](https://img.shields.io/badge/Support-Buy%20Me%20A%20Coffee-orange)](https://www.buymeacoffee.com/venis)
</div>

**Log2Csv** is a PowerShell script designed to convert changelogs into structured CSV files. It is particularly useful for extracting and organizing changelog data from various formats, making it easier to analyze and process.

---

## Requirements

- PowerShell *(version 7.0 or later recommended)*
- Internet connection for fetching changelogs from remote URLs.

## Supported Changelogs

**Log2Csv** officially supports the following changelogs. These configurations are included in the default `changelog-config.json` file and are used to parse and extract information from the respective changelog files.  

| **Name** | **Major Version** | Repository | **Changelog URL** |
| -------- | ----------------- | ---------- | ----------------- |
| **azurerm-v3** | 3.x | [terraform-provider-azurerm](https://github.com/hashicorp/terraform-provider-azurerm) | [AzureRM v3 Changelog](https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/CHANGELOG-v3.md) |
| **azurerm-v4** | 4.x | [terraform-provider-azurerm](https://github.com/hashicorp/terraform-provider-azurerm) | [AzureRM v4 Changelog](https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/CHANGELOG.md) |
| **azuread** | All | [terraform-provider-azuread](https://github.com/hashicorp/terraform-provider-azuread) | [AzureAD Changelog](https://raw.githubusercontent.com/hashicorp/terraform-provider-azuread/refs/heads/main/CHANGELOG.md) |
| **azapi** | All | [terraform-provider-azapi](https://github.com/Azure/terraform-provider-azapi) | [AzAPI Changelog](https://raw.githubusercontent.com/Azure/terraform-provider-azapi/refs/heads/main/CHANGELOG.md) |
| **checkov** | All | [checkov](https://github.com/bridgecrewio/checkov/) | [Checkov Changelog](https://raw.githubusercontent.com/bridgecrewio/checkov/refs/heads/main/CHANGELOG.md) |
| **gitlab-v17** | 17.x | [GitLab](https://gitlab.com/gitlab-org/gitlab/) | [GitLab Changelog](https://gitlab.com/gitlab-org/gitlab/-/raw/master/CHANGELOG.md) |
| **helm-chart-sonarqube** | All | [helm-chart-sonarqube](https://github.com/SonarSource/helm-chart-sonarqube) | [helm-chart-sonarqube Changelog](https://github.com/SonarSource/helm-chart-sonarqube/blob/master/charts/sonarqube/CHANGELOG.md) |

## How It Works

The script works in three main steps:

1. **Fetch Changelog**: The script retrieves changelogs from specified URLs defined in a configuration file.
2. **Parse Changelog**: It processes the changelog based on regular expressions and categorizes updates.
3. **Export CSV**: Finally, it exports the processed data into a CSV file with a custom delimiter.

## Features

- **Changelog Retrieval:** Fetches changelogs from remote sources (e.g., GitHub repositories).
- **Customizable Parsing:** Supports flexible parsing rules using a configuration file.
- **Version Filtering:** Filters entries by minimum and maximum version constraints.
- **CSV Export:** Converts parsed changelog data into CSV files with customizable delimiters.
- **Category Matching:** Groups changelog entries by categories such as features, bug fixes, enhancements, and more.

## How to Use

### Configuration

Edit the `config/changelog-config.json` file to define changelog sources and parsing rules. Each changelog source has its own configuration block with the following properties:
- `changelog-url`: URL to fetch the changelog.
- `regex-patterns`: Regular expressions to parse the changelog.

### Steps to Run

1. Move to Log2Csv directory:
    ```bash
    cd C:\path\to\Log2Csv
    ```
2. Modify the `main.ps1` file to specify your desired changelog name, version range, and scopes:
    ```powershell
    $changelogName = "azurerm-v3"
    $maxVersion = "latest"
    $minVersion = "3.24.0" 
    $scopes = @("") #or for e.g. @("scope1", "scope2", ...)
    ```
3. Run the `main.ps1` script:
    ```bash
    .\main.ps1
    ```
4. Find the generated CSV file in the 'output' directory. The file name will follow the pattern:
    ```text
    changelog-<changelogName>-<random_number>.csv
    ```

## Advanced Functions
### Advanced Functions

#### 1. **[Convert-Changelog.ps1](.\src\Convert-Changelog.ps1)**
**Description:**  
This function converts a changelog into a structured PowerShell object, filtering entries by version range and specific categories.  

**Syntax:**  
```powershell
Convert-Changelog -changelogName "<Name>" [-minVersion "<Version>"] [-maxVersion "<Version>"] [-scopes @("")] [-strictScope <bool>] [-configPath "<Path>"]
```

**Parameters:**
- `-changelogName` *(Mandatory)*: The name of the changelog to process.  
- `-minVersion` *(Optional)*: Minimum version to include in the filter. Default: `"oldest"`.  
- `-maxVersion` *(Optional)*: Maximum version to include in the filter. Default: `"latest"`.  
- `-scopes` *(Optional)*: Array of strings to filter changes by specific scopes. Default: `@("")`.  
- `-strictScope` *(Optional)*: Boolean to apply strict filtering on scopes. Default: `$false`.  
- `-configPath` *(Optional)*: Path to the JSON configuration file. Default: `".\config\changelog-config.json"`.  

#### 2. **[Export-ChangelogCSV.ps1](.\src\Export-ChangelogCSV.ps1)**  
**Description:**  
This function exports changelog data into a readable CSV file, with options to define the delimiter and the output directory.  

**Syntax:**  
```powershell
Export-ChangelogCSV -changelog <Object> -changelogName "<Name>" [-outputDir "<Path>"] [-csvSeparator "<Char>"] [-configPath "<Path>"]
```

**Parameters:**
- `-changelog` *(Mandatory)*: PowerShell object generated by `Convert-Changelog`.  
- `-changelogName` *(Mandatory)*: Name for the output CSV file.  
- `-outputDir` *(Optional)*: Directory where the CSV file will be saved. Default: `".\output\"`.  
- `-csvSeparator` *(Optional)*: Character used as the delimiter in the CSV file. Default: `"^"`.
- `-configPath` *(Optional)*: Path to the JSON configuration file. Default: `".\config\csv-config.json"`.  

## Config
### [changelog-config.json](\config\changelog-config.json)
This file defines the rules for parsing changelogs from various sources. It specifies URLs, patterns for extracting versions, change categories, and rules for handling special cases or ignoring irrelevant content.

For an example of practical configuration go [here](.\config\changelog-config.json)

```
{
    "changelog-name": { // The name of the changelog configuration (can have any name)
        "changelog-url": "https://raw.githubusercontent.com/user/project/CHANGELOG.md", // URL to the raw changelog file
        "regex-patterns": { // Patterns used to parse the changelog
            "version-line": "^## \\d+\\.\\d+\\.\\d+ \\([A-Za-z]+ \\d{1,2}, \\d{4}\\)", // Regex to identify version lines
            "version": "(\\d+\\.\\d+\\.\\d+)", // Regex to extract version numbers
            "change-categories": [ // Definitions for different change categories
                {
                    "name": "__default", // Default category if no specific match
                    "patterns": { // Patterns for matching and cleaning data
                        "match": {
                            "name": "`([^`]+)`", // Regex to extract names
                            "description": "(?<=- ).*" // Regex to extract descriptions
                        },
                        "replace": {
                            "name": "`" // Regex to clean the name field
                        }
                    }
                },
                {
                    "name": "FEATURES", // Specific change category
                    "name-pattern": "^FEATURES$", // Regex to match category header
                    "default-pattern": false, // Whether to use the default pattern for this category
                    "patterns": { // Custom patterns for this category
                        "match": {
                            "name": "`([^`]+)`", // Regex for names
                            "description": "\\*([^\\`]+)" // Regex for descriptions
                        },
                        "replace": {
                            "name": "`", // Clean-up regex for names
                            "description": "^\\s+|\\s+$|[*:]" // Clean-up regex for descriptions
                        }
                    }
                },
                {
                    "name": "ENHANCEMENTS", // Specific change category
                    "name-pattern": "^ENHANCEMENTS$", // Regex to match category header
                    "default-pattern": true // __default patterns will be used
                }
            ],
            "specials": [ // Special cases that require custom handling (elaboprocessed before change-categories)
                "^[^*].*" // Lines not starting with '*' are treated as special
            ],
            "ignore": [ // Lines to ignore completely
                "---" // Separator lines to skip
            ]
        }
    }
}
```

### [csv-config.json](\config\csv-config.json)
This file defines the structure and naming conventions for the generated CSV output.

For an example of practical configuration go [here](.\config\csv-config.json)

```
{
    "columns-names": { // Defines the mapping of parsed data fields to CSV column names
        "version": "Version", // The column name for the version number of the update
        "update-type": "Update type", // The column name for the type of update (e.g., feature, bug fix)
        "resource": "Resource", // The column name for the affected resource or component
        "description": "Description" // The column name for the detailed description of the change
    },
    "file-prefix": "changelog" // Prefix for the generated CSV file name
}
```

<!--
 /\_/\
( o.o )
 > ^ <
-->

## Example Output
The exported CSV contains the following columns:

* **Version**: The version of the update.
* **Update Type**: The type of change (e.g., Features, Bug Fixes).
* **Resource**: The resource affected by the update.
* **Description**: A description of the change.

#### Example:
| Version  | Update Type | Resource        | Description            |
|----------|-------------|-----------------|------------------------|
| 3.24.0   | Features    | Virtual Machine | Added support for XYZ  |
| 3.23.0   | Bug Fixes   | Storage Account | Fixed issue with ABC   |

## Contributing

Contributions are welcome! If you'd like to contribute, please follow these steps:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Make your changes.
4. Test your changes thoroughly.
5. Submit a pull request explaining the changes you made.

## Support

If you find this project helpful, you can support its development by buying me a coffee:

[![Buy Me A Coffee](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/venis)


## License

This project is licensed under the [MIT license](LICENSE).
