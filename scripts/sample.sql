-- Insert data into Juz
INSERT INTO Juz (name, description) VALUES 
('Juz 1', 'The first Juz of the Quran'),
('Juz 2', 'The second Juz of the Quran');

-- Insert data into Surah
INSERT INTO Surah (name, arabic_name, juz_id, revelation_place, verse_count) VALUES 
('Al-Fatiha', 'الفاتحة', 1, 'Mecca', 7),
('Al-Baqarah', 'البقرة', 2, 'Medina', 286);

-- Insert data into Ayah
INSERT INTO Ayah (surah_id, number_in_surah, text) VALUES 
(1, 1, 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ'),
(1, 2, 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ'),
(2, 1, 'الم'),
(2, 2, 'ذَٰلِكَ الْكِتَابُ لَا رَيْبَ فِيهِ هُدًى لِّلْمُتَّقِينَ');

-- Insert data into Tafsir
INSERT INTO Tafsir (ayah_id, tafsir_text, author) VALUES 
(1, 'In the name of Allah, the Most Gracious, the Most Merciful', 'Author A'),
(2, 'Praise be to Allah, Lord of all the worlds', 'Author B'),
(3, 'Alif Lam Meem - Only Allah knows its meaning', 'Author C'),
(4, 'This is the Book about which there is no doubt, a guidance for those conscious of Allah', 'Author D');