# Secret Book

Secret Book is a password management application. This document provides a brief overview of the initial setup and future enhancements.

## SQLite Setup

On the first installation of the application, the SQLite database is automatically set up with the following schema:

```sqlite
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS tokens;
DROP TABLE IF EXISTS googleauths;
DROP TABLE IF EXISTS info;

CREATE TABLE accounts(
  id TEXT PRIMARY KEY,
  title TEXT,
  account TEXT,
  password TEXT,
  comment TEXT
);

CREATE TABLE tokens(
  id TEXT PRIMARY KEY,
  title TEXT,
  content TEXT,
  comment TEXT
);

CREATE TABLE googleauths(
  id TEXT PRIMARY KEY,
  title TEXT,
  token TEXT,
  comment TEXT
);

CREATE TABLE info(
  id INT,
  last_sync_date TEXT,
  server_addr,
  name TEXT,
  auto_push_event INT
);

INSERT INTO info(
  id,
  last_sync_date,
  server_addr,
  name,
  auto_push_event
) Values(0, 0, 'localhost:12345', '1234567', 1);
```

## Future Enhancements

Here are some of the planned improvements for the application:

1. Enhance context handling, e.g., database connections, event changes.
2. Improve the user interface for better user experience.
3. Display a notification after a password is generated during account addition.
4. Implement language switching functionality.
5. Enable data synchronization for individual events.
6. Implement automatic refresh when settings are changed.

## Server

You can set up a backend server to store the account data. The server can be found on [GitHub](https://github.com/stong1994/secret_book_server). With the server, you can share the accounts between multiple clients and also with a browser extension.

## Browser Extension

You can get the accounts related to the current web host in the browser with the [extension](https://github.com/stong1994/extension-secret-book).

```

```
