import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/lead_model.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('leads.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE leads (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        contact TEXT NOT NULL,
        status TEXT NOT NULL,
        notes TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');
  }

  // Create - Add new lead
  Future<Lead> createLead(Lead lead) async {
    final db = await database;
    final id = await db.insert('leads', lead.toMap());
    return lead.copyWith(id: id);
  }

  // Read - Get all leads
  Future<List<Lead>> getAllLeads() async {
    final db = await database;
    final result = await db.query('leads', orderBy: 'updatedAt DESC');
    return result.map((map) => Lead.fromMap(map)).toList();
  }

  // Read - Get leads by status
  Future<List<Lead>> getLeadsByStatus(String status) async {
    final db = await database;
    final result = await db.query(
      'leads',
      where: 'status = ?',
      whereArgs: [status],
      orderBy: 'updatedAt DESC',
    );
    return result.map((map) => Lead.fromMap(map)).toList();
  }

  // Read - Get single lead
  Future<Lead?> getLead(int id) async {
    final db = await database;
    final result = await db.query(
      'leads',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return Lead.fromMap(result.first);
  }

  // Update - Update lead
  Future<int> updateLead(Lead lead) async {
    final db = await database;
    return await db.update(
      'leads',
      lead.copyWith(updatedAt: DateTime.now()).toMap(),
      where: 'id = ?',
      whereArgs: [lead.id],
    );
  }

  // Delete - Remove lead
  Future<int> deleteLead(int id) async {
    final db = await database;
    return await db.delete(
      'leads',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Search leads by name
  Future<List<Lead>> searchLeads(String query) async {
    final db = await database;
    final result = await db.query(
      'leads',
      where: 'name LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'updatedAt DESC',
    );
    return result.map((map) => Lead.fromMap(map)).toList();
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
