# secret_book

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## sqlite prepare
if you are first install app, the sqlite will auto execute;
```sqlite
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS tokens;
DROP TABLE IF EXISTS  googleauths;
DROP TABLE IF EXISTS  info;
CREATE TABLE accounts(id TEXT PRIMARY KEY, title TEXT, account TEXT, password TEXT, comment TEXT);
CREATE TABLE tokens(id TEXT PRIMARY KEY, title TEXT, content TEXT);
CREATE TABLE googleauths(id TEXT PRIMARY KEY, title TEXT, token TEXT);
CREATE TABLE info(id INT, last_sync_date TEXT, server_addr, name TEXT, auto_push_event INT);
INSERT INTO info(id, last_sync_date, server_addr, name, auto_push_event) Values(0, 0, '127.0.0.1:12345', '1234567', 1);
```
## todo
1. fulfill context, eg: db connection、changed event
2. optimize page，make it more beautiful
3. sync server addr check and compatible url that has prefix http.[✅]
4. show the notice after password generated in account adding
5. language switch
6. sync data for event single info
7. auto refresh when settings have changed
8. save system settings
9. can't push event after changed server url 
