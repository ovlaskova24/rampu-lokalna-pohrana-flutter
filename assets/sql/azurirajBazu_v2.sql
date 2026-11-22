CREATE TABLE podzadatak (
    zadatak_id INTEGER NOT NULL,
    redni_broj INTEGER NOT NULL,
    opis       TEXT    NOT NULL,
    obavljen   INTEGER NOT NULL DEFAULT 0 CHECK (obavljen IN (0, 1)),
    PRIMARY KEY (zadatak_id, redni_broj),
    FOREIGN KEY (zadatak_id) REFERENCES zadatak (zadatak_id)
        ON DELETE CASCADE
);

INSERT INTO podzadatak (zadatak_id, redni_broj, opis)
SELECT zadatak_id, 1, 'Pročitaj upute' FROM zadatak;