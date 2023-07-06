user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

user_pref("privacy.clearOnShutdown.cache", false);
user_pref("privacy.clearOnShutdown.cookies", false);
user_pref("privacy.clearOnShutdown.offlineApps", false);

user_pref("browser.download.autohideButton", true);
user_pref("extensions.activeThemeID", "firefox-compact-dark@mozilla.org");
user_pref("browser.theme.content-theme", 0);
user_pref("browser.theme.toolbar-theme", 0);

const uiCustomizationState = {
  placements: {
    "widget-overflow-fixed-list": [],
    "unified-extensions-area": [
      "ublock0_raymondhill_net-browser-action",
      "addon_darkreader_org-browser-action",
      "treestyletab_piro_sakura_ne_jp-browser-action",
      "_7be2ba16-0f1e-4d93-9ebc-5164397477a9_-browser-action",
    ],
    "nav-bar": [
      "back-button",
      "forward-button",
      "stop-reload-button",
      "urlbar-container",
      "save-to-pocket-button",
      "downloads-button",
      "fxa-toolbar-menu-button",
      "unified-extensions-button",
      "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action",
    ],
    "toolbar-menubar": ["menubar-items"],
    TabsToolbar: ["tabbrowser-tabs", "new-tab-button", "alltabs-button"],
    PersonalToolbar: ["import-button", "personal-bookmarks"],
  },
  seen: [
    "developer-button",
    "ublock0_raymondhill_net-browser-action",
    "addon_darkreader_org-browser-action",
    "treestyletab_piro_sakura_ne_jp-browser-action",
    "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action",
    "_7be2ba16-0f1e-4d93-9ebc-5164397477a9_-browser-action",
  ],
  dirtyAreaCache: [
    "nav-bar",
    "unified-extensions-area",
    "PersonalToolbar",
    "toolbar-menubar",
    "TabsToolbar",
  ],
  currentVersion: 19,
  newElementCount: 3,
};

user_pref(
  "browser.uiCustomization.state",
  JSON.stringify(uiCustomizationState)
);

user_pref("devtools.debugger.remote-enabled", true);
user_pref("devtools.editor.keymap", "vim");
