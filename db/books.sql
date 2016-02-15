DROP TABLE IF EXISTS authors;
DROP TABLE IF EXISTS books;

CREATE TABLE authors (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  session_token VARCHAR(255),

  FOREIGN KEY(author_id) REFERENCES authors(id)
);

CREATE TABLE books (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  author_id INTEGER
);


-- INSERT INTO
--   books (title, author_id)
-- VALUES
--   ("Harry Potter and the Half Blood Prince", null),
--   ("Finley", null),
--   ("Hobbes", 1);
--
-- INSERT INTO
--   authors (name)
-- VALUES
--   ("JK Rowling");
