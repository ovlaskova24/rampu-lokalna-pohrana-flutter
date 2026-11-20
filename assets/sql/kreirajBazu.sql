CREATE TABLE kategorija (
    kategorija_id    INTEGER PRIMARY KEY AUTOINCREMENT,
    naziv_kategorije TEXT    NOT NULL UNIQUE,
    boja             TEXT    NOT NULL
);

CREATE TABLE zadatak (
    zadatak_id    INTEGER PRIMARY KEY AUTOINCREMENT,
    naslov        TEXT    NOT NULL,
    zavrsen       INTEGER NOT NULL DEFAULT 0 CHECK (zavrsen IN (0, 1)),
    kategorija_id INTEGER NOT NULL,
    FOREIGN KEY (kategorija_id) REFERENCES kategorija (kategorija_id)
        ON DELETE RESTRICT
);

INSERT INTO kategorija (naziv_kategorije, boja) VALUES ('RAMPU', '#000080');
INSERT INTO kategorija (naziv_kategorije, boja) VALUES ('RPP', '#FF0000');
INSERT INTO kategorija (naziv_kategorije, boja) VALUES ('RWA', '#008000');

INSERT INTO zadatak (naslov, kategorija_id) VALUES ('Predaj seminarski', 1);
INSERT INTO zadatak (naslov, kategorija_id) VALUES ('Pripremi labose', 2);
INSERT INTO zadatak (naslov, kategorija_id) VALUES ('Spoji se na server', 3);