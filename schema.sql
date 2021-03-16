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
  absolute_path TEXT NOT NULL
, plugin_name   TEXT NOT NULL
, version       TEXT NOT NULL
, UNIQUE(absolute_path, plugin_name, version)
, FOREIGN KEY(absolute_path) REFERENCES tool_versions_files(absolute_path)
    ON DELETE CASCADE
-- NOTE: This won't quite work, because it could be the case that someone has a
--       `.tool-versions` file which references a plugin that's not added.
-- , FOREIGN KEY(plugin_name) REFERENCES plugins_added(name) ON DELETE CASCADE
);

CREATE TABLE packages_latest (
  plugin_name TEXT NOT NULL
, version     TEXT NOT NULL
, UNIQUE(plugin_name)
, FOREIGN KEY(plugin_name) REFERENCES plugins_added(name) ON DELETE CASCADE
);

-- VIEWS

CREATE VIEW v_plugins_missing AS
  SELECT
    plugin_name AS "Missing Plugin"
  , 'asdf plugin add ' || plugin_name || ' # [<git-url>]' AS "Command"
  FROM packages_declared
  WHERE plugin_name NOT IN ( SELECT name FROM plugins_added );

CREATE VIEW v_packages_missing AS
  SELECT
    plugin_name || ' ' || version AS "Missing Package"
  , 'asdf install ' || plugin_name || ' ' || version AS "Command"
  FROM packages_declared
  WHERE (plugin_name, version) NOT IN (
    SELECT plugin_name, version FROM packages_installed
  );

CREATE VIEW v_packages_outdated AS
  SELECT
    decl.absolute_path
  , decl.plugin_name
  , decl.version
  , late.version AS latest_version
  FROM packages_declared decl
  JOIN packages_latest   late ON decl.plugin_name = late.plugin_name
                             AND decl.version <> late.version;
