{
  "[dart]" = {
      "editor.formatOnSave" = true;
      "editor.formatOnType" = true;
      "editor.rulers" = [
        80
    ];
      "editor.selectionHighlight" = false;
      "editor.suggest.snippetsPreventQuickSuggestions" = false;
      "editor.suggestSelection" = "first";
      "editor.tabCompletion" = "onlySnippets";
      "editor.wordBasedSuggestions" = "off";
  };
  "[json]" = {
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
  };
  "[jsonc]" = {
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
  };
  "[nix]" = {
      "editor.defaultFormatter" = "jnoortheen.nix-ide";
      "editor.formatOnSave" = false;
  };
  "[proto3]" = {
      "editor.defaultFormatter" = "zxh404.vscode-proto3";
  };
  "[sql]" = {
      "editor.defaultFormatter" = "adpyke.vscode-sql-formatter";
      "editor.formatOnSave" = false;
  };
  "[typescript]" = {
      "editor.defaultFormatter" = "biomejs.biome";
  };
  "[typescriptreact]" = {
      "editor.defaultFormatter" = "vscode.typescript-language-features";
  };
  "breadcrumbs.enabled" = true;
  "codeium.enableConfig" = {
      "*" = true;
      "markdown" = true;
      "prisma" = true;
      "typescript" = false;
  };
  "cursor.cpp.disabledLanguages" = ["scminput"];
  "cursor.cpp.enablePartialAccepts" = true;
  "custom-ui-style.electron" = {
      "frame" = false;
  };
  "customizeUI.titleBar" = "frameless";
  "diffEditor.ignoreTrimWhitespace" = false;
  "editor.accessibilitySupport" = "off";
  "editor.codeActionsOnSave" = {
      "quickfix.biome" = "explicit";
      "source.organizeImports.biome" = "always";
  };
  "editor.fontFamily" = "Fira Code";
  "editor.fontLigatures" = true;
  "editor.fontSize" = 14;
  "editor.formatOnSave" = true;
  "editor.inlineSuggest.enabled" = true;
  "editor.minimap.enabled" = false;
  "editor.renderWhitespace" = "all";
  "editor.rulers" = [
      120
  ];
  "editor.tabSize" = 2;
  "errorLens.excludeBySource" = ["ts(1005)"];
  "files.associations" = {
      "*.css" = "tailwindcss";
      "tiltfile" = "tiltfile";
  };
  "files.autoSave" = "afterDelay";
  "git.allowForcePush" = true;
  "git.autofetch" = true;
  "git.confirmSync" = false;
  "git.openRepositoryInParentFolders" = "never";
  "git.rebaseWhenSync" = true;
  "github.copilot.editor.enableAutoCompletions" = true;
  "github.copilot.enable" = {
      "*" = false;
      "markdown" = true;
      "plaintext" = true;
      "scminput" = false;
      "yaml" = true;
  };
  "go.lintTool" = "golangci-lint";
  "go.toolsManagement.autoUpdate" = true;
  "javascript.updateImportsOnFileMove.enabled" = "always";
  "json.schemas" = [
      {
        "https://spec.openapis.org/oas/3.0/schema/2021-09-28" = ["**/openapi.json" "**/openapi.yaml"];
    }
  ];
  "nix.enableLanguageServer" = true;
  "nix.serverPath" = "/etc/profiles/per-user/mate/bin/nixd";
  "nix.serverSettings" = {
      "nixd" = {
        "eval" = {
          "depth" = 10;
          "workers" = 1;
      };
        "formatting" = {
          "command" = "nixpkgs-fmt";
      };
    };
  };
  "protoc.options" = ["--proto_path=\${workspaceFolder}/api"];
  "remote.SSH.connectTimeout" = 300;
  "remote.SSH.logLevel" = "trace";
  "remote.SSH.remotePlatform" = {
      "homeserver" = "linux";
      "ubuntu-server" = "linux";
  };
  "security.promptForLocalFileProtocolHandling" = false;
  "security.workspace.trust.untrustedFiles" = "open";
  "tailwindCSS.experimental.classRegex" = [
      ["tva\\((([^()]*|\\([^()]*\\))*)\\)" "[\"'`]([^\"'`]*).*?[\"'`]"]
  ];
  "tailwindCSS.lint.cssConflict" = "ignore";
  "terminal.explorerKind" = "both";
  "terminal.external.linuxExec" = "warp";
  "terminal.external.osxExec" = "Warp.app";
  "terminal.integrated.fontFamily" = "monospace";
  "terminal.integrated.fontSize" = 15;
  "typescript.preferences.importModuleSpecifier" = "relative";
  "typescript.referencesCodeLens.enabled" = false;
  "typescript.updateImportsOnFileMove.enabled" = "always";
  "update.releaseTrack" = "prerelease";
  "window.customTitleBarVisibility" = "never";
  "window.nativeTabs" = true;
  "window.titleBarStyle" = "native";
  "workbench.editor.enablePreview" = false;
  "workbench.preferredDarkColorTheme" = "Default Dark+";
  "workbench.sideBar.location" = "right";
  "yaml.schemas" = {
      "https://spec.openapis.org/oas/3.0/schema/2021-09-28" = ["**/openapi.json" "**/openapi.yaml"];
  };
}
