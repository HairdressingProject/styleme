import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Opens a new connection to a SQLite `Database`
///
/// If not found, it is created and saved to `styleme.db`
Future<Database> getDb() async {
  return openDatabase(join(await getDatabasesPath(), 'styleme.db'),
      onCreate: (db, version) async {
    await db.execute(
        "CREATE TABLE IF NOT EXISTS users(id INTEGER PRIMARY KEY NOT NULL, token TEXT, user_name TEXT UNIQUE NOT NULL, user_email TEXT UNIQUE NOT NULL, first_name TEXT NOT NULL DEFAULT 'user', last_name TEXT, user_role TEXT DEFAULT 'user', date_created TEXT, date_updated TEXT);");

    await db.execute(
        "CREATE TABLE IF NOT EXISTS face_shapes(id INTEGER PRIMARY KEY NOT NULL, shape_name TEXT NOT NULL, label TEXT, date_created TEXT, date_updated TEXT);");

    await db.execute(
        "CREATE TABLE IF NOT EXISTS hair_styles(id INTEGER PRIMARY KEY NOT NULL, hair_style_name TEXT NOT NULL, label TEXT, date_created TEXT, date_updated TEXT);");

    await db.execute(
        "CREATE TABLE IF NOT EXISTS hair_lengths(id INTEGER PRIMARY KEY NOT NULL, hair_length_name TEXT NOT NULL, label TEXT, date_created TEXT, date_updated TEXT);");

    await db.execute(
        "CREATE TABLE IF NOT EXISTS colours(id INTEGER PRIMARY KEY NOT NULL, colour_name TEXT NOT NULL, colour_hash TEXT NOT NULL DEFAULT '** ERROR: missing category **', label TEXT, date_created TEXT, date_updated TEXT);");

    await db.execute(
        "CREATE TABLE IF NOT EXISTS pictures(id INTEGER PRIMARY KEY NOT NULL, file_name TEXT UNIQUE NOT NULL, file_path TEXT, file_size INTEGER, width INTEGER, height INTEGER, date_created TEXT, date_updated TEXT);");

    await db.execute(
        "CREATE TABLE IF NOT EXISTS model_pictures(id INTEGER PRIMARY KEY NOT NULL, file_name TEXT UNIQUE NOT NULL, file_path TEXT, file_size INTEGER, width INTEGER, height INTEGER, hair_style_id INTEGER REFERENCES hair_styles(id) ON DELETE CASCADE ON UPDATE CASCADE, hair_length_id INTEGER REFERENCES hair_lengths(id) ON UPDATE CASCADE ON DELETE CASCADE, face_shape_id INTEGER REFERENCES face_shapes(id) ON UPDATE CASCADE ON DELETE CASCADE, hair_colour_id INTEGER REFERENCES colours(id) ON DELETE CASCADE ON UPDATE CASCADE, date_created TEXT, date_updated TEXT);");

    await db.execute(
        "CREATE TABLE IF NOT EXISTS history(id INTEGER PRIMARY KEY NOT NULL, picture_id INTEGER REFERENCES pictures(id) ON DELETE CASCADE ON UPDATE CASCADE, original_picture_id INTEGER REFERENCES pictures(id) ON DELETE CASCADE ON UPDATE CASCADE, previous_picture_id INTEGER REFERENCES pictures(id) ON DELETE CASCADE ON UPDATE CASCADE, hair_colour_id INTEGER REFERENCES colours(id) ON DELETE CASCADE ON UPDATE CASCADE, hair_style_id INTEGER REFERENCES hair_styles(id) ON DELETE CASCADE ON UPDATE CASCADE, face_shape_id INTEGER REFERENCES face_shapes(id) ON DELETE CASCADE ON UPDATE CASCADE, user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE, date_created TEXT, date_updated TEXT);");
  }, version: 3);
}
