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
CREATE TABLE tool_versions_files (
  absolute_path TEXT NOT NULL UNIQUE
);
CREATE TABLE packages_declared (
  absolute_filepath TEXT NOT NULL
, plugin_name       TEXT NOT NULL
, version           TEXT NOT NULL
, UNIQUE(absolute_filepath, plugin_name, version)
, FOREIGN KEY(absolute_filepath) REFERENCES tool_versions_files(absolute_filepath) ON DELETE CASCADE
-- NOTE: This won't quite work, because it could be the case that someone has a
--       `.tool-versions` file which references a plugin that's not added.
-- , FOREIGN KEY(plugin_name) REFERENCES plugins_added(name) ON DELETE CASCADE
);
