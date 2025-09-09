CREATE OR REPLACE FUNCTION auto_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql'; 

-- BOOK TABLE
CREATE TABLE book(
    id uuid NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    isbn varchar(13) UNIQUE NOT NULL
);
-- BOOK TABLE

-- PLAYLIST TABLE
CREATE TABLE playlist(
    id uuid NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    user_id varchar(32) NOT NULL,
    -- SPOTIFY PLAYLIST ID
    playlist_id TEXT NOT NULL,
    book_id uuid NOT NULL,
    CONSTRAINT fk_book FOREIGN KEY(book_id) REFERENCES book(id) ON DELETE CASCADE
);
-- PLAYLIST TABLE