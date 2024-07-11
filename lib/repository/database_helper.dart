import 'dart:developer';
import 'dart:io';

import 'package:elabv01/StockPage/Model/stock_model.dart';
import 'package:elabv01/TimeTable/Model/time_table_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import '../ClassPage/class_model.dart';
import '../ExamPage/question_exam_model.dart';
import '../LoginPage/Model/user.model.dart';

class DatabaseHelper {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 6;

  static const tableUsers = 'users';
  static const columnId = 'id';
  static const columnUser = 'user';
  static const columnPassword = 'password';
  static const columnModelData = 'model_data';
  static const columnStatus = 'status';
  static const columnEmail = 'email';
  static const columnUpdatedDate = 'updatedDate';
  static const columnUserImage = 'userImage';
  static const columnLevel = 'level';

  ///
  static const timeTable = 'timetable';
  static const columnUserId = 'userId';
  static const columnListUserTime = 'listUserTime';
  static const classRoomTable = 'classRoom';
  static const columnFromDate = 'fromDate';
  static const columnToDate = 'toDate';
  static const columnName = 'name';
  static const columnNumberSession = 'numberSession';
  static const columnNumberHour = 'numberHour';
  static const columnFaculty = 'faculty';

  //table question
  static const questionsTable = 'questions';
  static const columnQuestion = 'question';
  static const columnOptions = 'options';
  static const columnSelection = 'selection';
  static const columnAnswer = 'answer';
  static const columnExamId = 'examId';
  static const columnSubjectId = 'subjectId';
  static const columnQuestionImage = 'questionImage'; //
  //account table
  static const accountTable = 'account';

  //result
  static const resultTable = 'results';
  static const columnResultId = 'resultId';
  static const columnScore = 'score';

  //Stock
  static const stockTable = 'stocks';
  static const columnStockName = 'name';
  static const columnStockPrice = 'price';

  static const stockBasisTable = 'baseStock';
  static const columnParameters = 'parameters';

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static late Database _database;

  Future<Database> get database async {
    _database = await _initDatabase();
    return _database;
  }
  String path ='';
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    //await db.execute("DELETE FROM $questionsTable");
    //   await db.execute("DELETE FROM $tableUsers");
    await db.execute("DROP TABLE IF EXISTS $accountTable");
    await db.execute("DROP TABLE IF EXISTS $stockBasisTable");
    await db.execute('''
          CREATE TABLE $accountTable (
            $columnUserId TEXT PRIMARY KEY NOT NULL,
            $columnUser TEXT ,
            $columnPassword TEXT ,
            $columnModelData TEXT ,
            $columnUserImage TEXT,
            $columnEmail TEXT,
            $columnStatus INTEGER,
            $columnUpdatedDate INTEGER,
            $columnLevel INTEGER
          )
          ''');
    await db.execute('''
          CREATE TABLE $resultTable (
            $columnResultId TEXT PRIMARY KEY NOT NULL,
            $columnUserId TEXT ,
            $columnExamId TEXT ,
            $columnScore TEXT ,           
            $columnUpdatedDate INTEGER
          )
          ''');
    await db.execute('''
          CREATE TABLE $tableUsers (
            $columnUserId TEXT PRIMARY KEY NOT NULL,
            $columnUser TEXT ,
            $columnPassword TEXT ,
            $columnModelData TEXT ,
            $columnUserImage TEXT,
            $columnEmail TEXT,
            $columnStatus INTEGER,
            $columnUpdatedDate INTEGER,
            $columnLevel INTEGER
          )
          ''');
    await db.execute('''
          CREATE TABLE $timeTable  (
            $columnUserId TEXT PRIMARY KEY NOT NULL,
            $columnListUserTime TEXT NOT NULL       
          )
          ''');
    await db.execute('''
          CREATE TABLE $classRoomTable (
            $columnId TEXT PRIMARY KEY NOT NULL,
            $columnFromDate INTEGER, 
            $columnToDate INTEGER,     
            $columnName TEXT NOT NULL,
            $columnNumberSession INTEGER,
            $columnNumberHour INTEGER,
            $columnFaculty TEXT NOT NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE $questionsTable (
            $columnId TEXT PRIMARY KEY NOT NULL,                        
            $columnQuestion TEXT NOT NULL,
            $columnOptions TEXT NOT NULL,
            $columnSelection TEXT,
            $columnAnswer INTEGER,
            $columnExamId TEXT,
            $columnSubjectId TEXT,            
            $columnQuestionImage TEXT,
            $columnFromDate INTEGER  
          )
          ''');
    await db.execute(
        '''CREATE TABLE $stockTable($columnStockName TEXT PRIMARY KEY NOT NULL,
            $columnStockPrice TEXT )''');
    await db.execute(
        '''CREATE TABLE $stockBasisTable($columnStockName TEXT PRIMARY KEY NOT NULL, $columnParameters TEXT)''');
  }
  String getDatabasePath(){
    return path;
  }
  String getDatabaseName(){
    return _databaseName;
  }
  Future<int> insert(User user) async {
    try {
      Database db = await instance.database;
      return await db.insert(tableUsers, user.toMap());
    } catch (e) {
      return -1;
    }
  }

  Future<int> insertResult(ResultExam resultExam) async {
    try {
      Database db = await instance.database;
      return await db.insert(resultTable, resultExam.toJson());
    } catch (e) {
      return -1;
    }
  }

  Future<int> insertAccount(User user) async {
    try {
      Database db = await instance.database;
      return await db.insert(accountTable, user.toMap());
    } catch (e) {
      return -1;
    }
  }

  Future<int> insertClassRoom(ClassModel classModel) async {
    try {
      Database db = await instance.database;
      return await db.insert(classRoomTable, classModel.toJson());
    } catch (e) {
      //print("ko ghi dc");
      return -1;
    }
  }

  Future<int> insertTimeTable(TimeTable timetable) async {
    Database db = await instance.database;
    //print("Chuan bi in${timetable.toJson()}");
    return await db.insert(timeTable, timetable.toJson());
  }

  Future<int> insertQuestionTable(QuestionExam questionExam) async {
    try {
      Database db = await instance.database;
      //print("Chuan bi in${questionExam.toJson()}");
      return await db.insert(questionsTable, questionExam.toJson());
    } catch (e) {
      log("khong ghi dược $e");
      return -1;
    }
  }

  Future<int> insertStockPrice(StockModel stockModel) async {
    try {
      Database database = await instance.database;
      return await database.insert(stockTable, stockModel.toMap());
    } catch (e) {
      log("Khong them dươc gia stock $e");
      return -1;
    }
  }

  Future<int> insertStockBasis(StockBasisModel stockBasisModel) async {
    try {
      Database database = await instance.database;
      return await database.insert(stockBasisTable, stockBasisModel.toMap());
    } catch (e) {
      log("khong thêm duoc stock basis $e");
      return -1;
    }
  }

  Future<List<StockBasisModel>> queryAllStockBasis() async {
    try {
      Database db = await instance.database;
      List<Map<String, dynamic>> stockBasis = await db.query(stockBasisTable);
      return stockBasis.map((e) => StockBasisModel.fromMap(e)).toList();
    } catch (e) {
      log("can not query db");
      return [];
    }
  }

  Future<List<StockModel>> queryAllStockPrice() async {
    try {
      Database db = await instance.database;
      List<Map<String, dynamic>> stockPrices = await db.query(stockTable);
      return stockPrices.map((e) => StockModel.fromMap(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<ClassModel>> queryAllClassRoom() async {
    try {
      Database db = await instance.database;
      List<Map<String, dynamic>> classRooms = await db.query(classRoomTable);
      return classRooms.map((e) => ClassModel.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<User>> queryAllUsers() async {
    try {
      Database db = await instance.database;
      List<Map<String, dynamic>> users = await db.query(tableUsers);
      return users.map((u) => User.fromMap(u)).toList();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<List<ResultExam>> queryAllResult(String userId, String examId) async {
    try {
      Database db = await instance.database;
      List<Map<String, dynamic>> resultExams = await db.query(resultTable);
      return resultExams.map((u) => ResultExam.fromJson(u)).toList();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<List<User>> queryAllAccount() async {
    try {
      Database db = await instance.database;
      List<Map<String, dynamic>> users = await db.query(accountTable);
      return users.map((u) => User.fromMap(u)).toList();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<List<QuestionExam>> queryAllQuestions(
      {String? where, String? arg}) async {
    try {
      Database db = await instance.database;
      List<Map<String, dynamic>> listQuestion;
      if (where != null) {
        listQuestion =
            await db.query(questionsTable, where: where, whereArgs: [arg]);
      } else {
        listQuestion = await db.query(questionsTable);
      }

      // for (QuestionExam time in listQuestion) {
      //   log("tai${time.toJson()}");
      // }
      return listQuestion.map((u) => QuestionExam.fromJson(u)).toList();
    } catch (e) {
      log("có loi $e");
      return [];
    }
  }

  Future<List<TimeTable>> queryAllTimeTable(
      {String? where, String? arg}) async {
    try {
      Database db = await instance.database;
      List<Map<String, dynamic>> timeTables;
      if (arg != null) {
        timeTables = await db.query(timeTable, where: where, whereArgs: [arg]);
      } else {
        timeTables = await db.query(timeTable);
      }

      return timeTables.map((e) => TimeTable.fromJson(e)).toList();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<int> deleteAllTimeTable({String? where, String? arg}) async {
    Database db = await instance.database;
    try {
      if (arg != null) {
        final result = await db
            .delete(timeTable, where: '$columnUserId = ?', whereArgs: [arg]);
        return result;
      } else {
        return await db.delete(timeTable);
      }
    } catch (e) {
      log(e.toString());
      return -1;
    }
  }

  Future<int> deleteAll() async {
    Database db = await instance.database;
    try {
      return await db.delete(tableUsers);
    } catch (e) {
      log(e.toString());
      return -1;
    }
  }

  Future<int> update(User user) async {
    Database db = await instance.database;
    try {
      return await db.update(tableUsers, user.toMap(),
          where: '$columnUserId = ?', whereArgs: [user.userId]);
    } catch (e) {
      log(e.toString());
      return -1;
    }
  }

  Future<int> updateStock(StockModel stockModel) async {
    Database db = await instance.database;
    try {
      return await db.update(stockTable, stockModel.toMap(),
          where: '$columnStockName= ?', whereArgs: [stockModel.name]);
    } catch (e) {
      return -1;
    }
  }

  Future<int> updateStockBasis(StockBasisModel stockBasisModel) async {
    Database db = await instance.database;
    try {
      return await db.update(stockBasisTable, stockBasisModel.toMap(),
          where: '$columnStockName=?', whereArgs: [stockBasisModel.name]);
    } catch (e) {
      log('can not update $e');
      return -1;
    }
  }

  Future<int> updateTime(TimeTable time) async {
    Database db = await instance.database;
    try {
      return await db.update(timeTable, time.toJson(),
          where: '$columnUserId = ?', whereArgs: [time.userId]);
    } catch (e) {
      return -1;
    }
  }
}
