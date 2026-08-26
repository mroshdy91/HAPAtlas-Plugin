[CmdletBinding()]
param(
    [string]$MetadataPath = (Join-Path (Split-Path $PSScriptRoot -Parent) 'plugin.metadata.json')
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path $PSScriptRoot -Parent
$metadata = Get-Content -LiteralPath $MetadataPath -Raw | ConvertFrom-Json
$utf8NoBom = [System.Text.UTF8Encoding]::new($false)

function Write-JsonFile {
    param(
        [Parameter(Mandatory)] [string]$RelativePath,
        [Parameter(Mandatory)] $Value
    )

    $path = Join-Path $repoRoot $RelativePath
    $directory = Split-Path $path -Parent
    [System.IO.Directory]::CreateDirectory($directory) | Out-Null
    $json = $Value | ConvertTo-Json -Depth 20
    [System.IO.File]::WriteAllText($path, $json + "`n", $utf8NoBom)
}

$author = [ordered]@{
    name = $metadata.author.name
    url = $metadata.author.url
}

$commonInterface = [ordered]@{
    displayName = $metadata.interface.display_name
    shortDescription = $metadata.interface.short_description
    longDescription = $metadata.interface.long_description
    developerName = $metadata.product_name
    category = $metadata.category
    capabilities = @($metadata.interface.capabilities)
    defaultPrompt = @($metadata.interface.default_prompt)
}

$codexInterface = [ordered]@{}
foreach ($entry in $commonInterface.GetEnumerator()) {
    $codexInterface[$entry.Key] = $entry.Value
}
$codexInterface.websiteURL = $metadata.homepage
$codexInterface.privacyPolicyURL = "$($metadata.homepage)#runtime-privacy"
$codexInterface.termsOfServiceURL = "$($metadata.homepage)#alpha-use-terms"
$codexInterface.brandColor = $metadata.interface.brand_color

$codexPlugin = [ordered]@{
    name = $metadata.name
    version = $metadata.plugin_version
    description = $metadata.description
    author = $author
    homepage = $metadata.homepage
    repository = $metadata.repository
    license = $metadata.license
    keywords = @($metadata.keywords)
    skills = './skills/'
    mcpServers = './.mcp.json'
    interface = $codexInterface
}
Write-JsonFile '.codex-plugin/plugin.json' $codexPlugin

$portablePlugin = [ordered]@{
    name = $metadata.name
    version = $metadata.plugin_version
    description = $metadata.description
    author = $author
    homepage = $metadata.homepage
    repository = $metadata.repository
    license = $metadata.license
    keywords = @($metadata.keywords)
    skills = './skills/'
    mcpServers = './mcp.portable.json'
}

$claudePlugin = [ordered]@{ '$schema' = 'https://anthropic.com/claude-code/plugin.schema.json' }
foreach ($entry in $portablePlugin.GetEnumerator()) {
    $claudePlugin[$entry.Key] = $entry.Value
}
Write-JsonFile '.claude-plugin/plugin.json' $claudePlugin
Write-JsonFile '.zcode-plugin/plugin.json' $portablePlugin

# The shipping Codex client accepts a file path, not an inline MCP object.
# It roots relative cwd at the installed plugin, but does not expand root
# placeholders in args. Keep that adaptation out of the portable declaration.
Write-JsonFile '.mcp.json' ([ordered]@{
    mcpServers = [ordered]@{
        HAPAtlas = [ordered]@{
            type = 'stdio'
            command = $metadata.runtime.command
            args = @($metadata.runtime.args | ForEach-Object { $_.Replace('${CLAUDE_PLUGIN_ROOT}', '.') })
            cwd = '.'
            env_vars = @($metadata.runtime.platform_env_vars)
            startup_timeout_sec = [int]$metadata.runtime.startup_timeout_sec
        }
    }
})
Write-JsonFile 'mcp.portable.json' ([ordered]@{
    mcpServers = [ordered]@{
        HAPAtlas = [ordered]@{
            type = 'stdio'
            command = $metadata.runtime.command
            args = @($metadata.runtime.args)
        }
    }
})
Write-JsonFile 'mcp.json' ([ordered]@{
    '$schema' = 'https://agent-plugins.org/schemas/1.0.0/mcp.schema.json'
    mcpServers = [ordered]@{
        hapatlas = [ordered]@{
            type = 'stdio'
            command = $metadata.runtime.command
            args = @($metadata.runtime.args | ForEach-Object { $_.Replace('${CLAUDE_PLUGIN_ROOT}', '${PLUGIN_ROOT}') })
        }
    }
})

Write-JsonFile 'plugin.json' ([ordered]@{
    '$schema' = 'https://agent-plugins.org/schemas/1.0.0/plugin.schema.json'
    name = $metadata.name
    version = $metadata.plugin_version
    description = $metadata.description
    author = $author
    homepage = $metadata.homepage
    repository = $metadata.repository
    license = $metadata.license
    keywords = @($metadata.keywords)
})

Write-JsonFile 'gemini-extension.json' ([ordered]@{
    name = $metadata.name
    version = $metadata.plugin_version
    description = $metadata.description
    mcpServers = [ordered]@{
        HAPAtlas = [ordered]@{
            command = $metadata.runtime.command
            args = @($metadata.runtime.args | ForEach-Object { $_.Replace('${CLAUDE_PLUGIN_ROOT}', '${extensionPath}') })
        }
    }
})

Write-JsonFile '.agents/plugins/marketplace.json' ([ordered]@{
    name = $metadata.marketplaces.product.name
    interface = [ordered]@{ displayName = $metadata.marketplaces.product.display_name }
    plugins = @(
        [ordered]@{
            name = $metadata.name
            source = [ordered]@{ source = 'local'; path = './' }
            policy = [ordered]@{ installation = 'AVAILABLE'; authentication = 'ON_INSTALL' }
            category = $metadata.category
        }
    )
})

$marketplaceOwner = [ordered]@{
    name = $metadata.product_name
    url = $metadata.repository
}
$marketplaceDescription = 'The official HAPAtlas plugin marketplace.'
$marketplacePlugin = [ordered]@{
    name = $metadata.name
    source = './'
    description = $metadata.description
    version = $metadata.plugin_version
    category = 'engineering'
    keywords = @('carrier-hap', 'hvac', 'mcp')
}
Write-JsonFile '.claude-plugin/marketplace.json' ([ordered]@{
    '$schema' = 'https://anthropic.com/claude-code/marketplace.schema.json'
    name = $metadata.marketplaces.product.name
    owner = $marketplaceOwner
    metadata = [ordered]@{ description = $marketplaceDescription; version = $metadata.plugin_version }
    plugins = @($marketplacePlugin)
})

Write-JsonFile '.github/plugin/marketplace.json' ([ordered]@{
    name = $metadata.marketplaces.product.name
    owner = $marketplaceOwner
    metadata = [ordered]@{ description = $marketplaceDescription; version = $metadata.plugin_version }
    plugins = @(
        [ordered]@{
            name = $metadata.name
            source = './'
            description = $metadata.description
            version = $metadata.plugin_version
        }
    )
})

Write-JsonFile 'marketplace.json' ([ordered]@{
    name = $metadata.marketplaces.product.name
    description = $marketplaceDescription
    plugins = @(
        [ordered]@{
            name = $metadata.name
            version = $metadata.plugin_version
            description = $metadata.description
            category = 'engineering'
            tags = @('carrier-hap', 'hvac', 'mcp')
            source = '.'
            homepage = $metadata.homepage
            repository = $metadata.repository
        }
    )
})

Write-JsonFile 'provenance.json' ([ordered]@{
    schema_version = '1.1'
    product = $metadata.product_name
    product_version = $metadata.product_version
    plugin_version = $metadata.plugin_version
    plugin_repository = $metadata.repository
    universal_skill = [ordered]@{
        handoff_source_repository = $metadata.capability_guidance.source_repository
        handoff_source_commit = $metadata.runtime.release.source_commit
        handoff_source_path = 'plugins/hapatlas/skills/use-hapatlas'
    }
    capability_guidance = [ordered]@{
        source_repository = $metadata.capability_guidance.source_repository
        source_branch = $metadata.capability_guidance.source_branch
        source_commit = $metadata.capability_guidance.source_commit
        generated_inventory = $metadata.capability_guidance.generated_inventory
        runtime_contracts = @($metadata.capability_guidance.runtime_contracts)
        accepted_actions = @($metadata.capability_guidance.accepted_actions)
    }
    runtime = [ordered]@{
        delivery = $metadata.runtime.delivery
        distribution_profile = $metadata.runtime.distribution_profile
        unsigned = [bool]$metadata.runtime.unsigned
        command = $metadata.runtime.command
        args = @($metadata.runtime.args)
        platform_env_vars = @($metadata.runtime.platform_env_vars)
        release_url = $metadata.runtime.release.url
        release_tag = $metadata.runtime.release.tag
        source_commit = $metadata.runtime.release.source_commit
        development_main_at_handoff = $metadata.runtime.release.development_main_at_handoff
        package_implementation = $metadata.runtime.release.package_implementation
        zip_name = $metadata.runtime.release.zip_name
        zip_sha256 = $metadata.runtime.release.zip_sha256
        inventory_name = $metadata.runtime.release.inventory_name
        inventory_sha256 = $metadata.runtime.release.inventory_sha256
        runtime_manifest_sha256 = $metadata.runtime.release.runtime_manifest_sha256
        zip_size = $metadata.runtime.release.zip_size
        zip_url = $metadata.runtime.release.zip_url
        inventory_url = $metadata.runtime.release.inventory_url
    }
})

Write-Host "Generated client manifests for $($metadata.product_name) $($metadata.plugin_version)."
