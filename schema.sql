CREATE TABLE plugins_added (
  name TEXT NOT NULL UNIQUE
, url  TEXT NOT NULL
, ref1 TEXT NOT NULL
, ref2 TEXT NOT NULL
);
CREATE TABLE packages_installed (
  plugin_name TEXT NOT NULL
, version     TEXT NOT NULL
, UNIQUE(plugin_name, version)
, FOREIGN KEY(plugin_name) REFERENCES plugins_added(name) ON DELETE CASCADE
);
