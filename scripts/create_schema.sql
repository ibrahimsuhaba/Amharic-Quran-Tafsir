DROP TABLE IF EXISTS Tafsir;
DROP TABLE IF EXISTS Ayah;
DROP TABLE IF EXISTS Surah;
DROP TABLE IF EXISTS Juz;

-- Table for Juz
CREATE TABLE Juz (
    id INTEGER PRIMARY KEY AUTOINCREMENT,       -- Unique identifier for the Juz
    name TEXT NOT NULL UNIQUE,                  -- Name of the Juz (e.g., "Juz 1")
    description TEXT                            -- Optional description of the Juz
);

-- Table for Surah
CREATE TABLE Surah (
    id INTEGER PRIMARY KEY AUTOINCREMENT,       -- Unique identifier for the Surah
    name TEXT NOT NULL,                         -- Name of the Surah (e.g., "Al-Fatiha")
    arabic_name TEXT NOT NULL,                  -- Arabic name of the Surah
    juz_id INTEGER NOT NULL,                    -- Foreign key linking to Juz table
    revelation_place TEXT CHECK (revelation_place IN ('Mecca', 'Medina')), -- Place of revelation
    verse_count INTEGER NOT NULL,              -- Total number of verses in the Surah
    FOREIGN KEY (juz_id) REFERENCES Juz(id)    -- Establish foreign key relationship
);

-- Table for Ayah
CREATE TABLE Ayah (
    id INTEGER PRIMARY KEY AUTOINCREMENT,       -- Unique identifier for the Ayah
    surah_id INTEGER NOT NULL,                  -- Foreign key linking to Surah table
    number_in_surah INTEGER NOT NULL,           -- Verse number within the Surah
    text TEXT NOT NULL,                         -- Arabic text of the Ayah
    UNIQUE (surah_id, number_in_surah),         -- Ensure no duplicate Ayah for the same Surah
    FOREIGN KEY (surah_id) REFERENCES Surah(id) -- Establish foreign key relationship
);

-- Table for Tafsir
CREATE TABLE Tafsir (
    id INTEGER PRIMARY KEY AUTOINCREMENT,       -- Unique identifier for the Tafsir
    ayah_id INTEGER NOT NULL,                   -- Foreign key linking to Ayah table
    tafsir_text TEXT NOT NULL,                  -- Tafsir text
    author TEXT DEFAULT 'Unknown',              -- Author of the Tafsir
    UNIQUE (ayah_id, tafsir_text),              -- Avoid duplicate Tafsir for the same Ayah
    FOREIGN KEY (ayah_id) REFERENCES Ayah(id)  -- Establish foreign key relationship
);

-- Indexes for Optimization
CREATE INDEX idx_juz_name ON Juz (name);
CREATE INDEX idx_surah_name ON Surah (name);
CREATE INDEX idx_surah_juz_id ON Surah (juz_id);
CREATE INDEX idx_ayah_surah_id ON Ayah (surah_id);
CREATE INDEX idx_tafsir_ayah_id ON Tafsir (ayah_id);