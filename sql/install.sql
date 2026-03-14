-- Matches your existing dbs_mining table; adds columns if you add them manually.
-- Your base table: identifier, xp, level, name, mined
-- Optional columns this script can use: total_ores, best_streak, rare_finds, last_seen
-- If your table already exists with only the base columns, storage.lua will add the rest on start.

CREATE TABLE IF NOT EXISTS `dbs_mining` (
  `identifier` varchar(64) NOT NULL,
  `xp` int(11) NOT NULL DEFAULT 0,
  `level` int(11) NOT NULL DEFAULT 0,
  `name` varchar(100) DEFAULT NULL,
  `mined` int(11) DEFAULT 0,
  `total_ores` int(11) NOT NULL DEFAULT 0,
  `best_streak` int(11) NOT NULL DEFAULT 0,
  `rare_finds` int(11) NOT NULL DEFAULT 0,
  `last_seen` datetime DEFAULT NULL,
  PRIMARY KEY (`identifier`),
  KEY `idx_xp` (`xp`),
  KEY `idx_total_ores` (`total_ores`),
  KEY `idx_mined` (`mined`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
