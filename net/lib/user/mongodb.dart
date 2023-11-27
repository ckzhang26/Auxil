// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:mongo_dart/mongo_dart.dart';
import 'package:net/config/gui.dart';
import 'package:net/user/credentials.dart';
import 'dart:convert';

class MongoDB {
  static var db, collection;

  static connect() async {
    db = await Db.create(dbGateway);
    await db.open();
    collection = db.collection(dbCollection);
  }

  static Future<bool> _insert(Database data) async {
    try {
      var result = await collection.insertOne(data.toJson());
      if (result != null) {
        return result.isSuccess;
      }
    } catch (e) {
      Gui.notify("An error occured!");
    }
    return false;
  }

  static void signup(Database data) async {
    bool result = await _insert(data);
    if (result) {
      Gui.notify("You have signed up!");
    } else {
      Gui.notify("Sign up has failed.");
    }
  }
}

Database databaseFromJson(String str) => Database.fromJson(json.decode(str));

String databaseToJson(Database data) => json.encode(data.toJson());

class Database {
  String email;
  String username;
  String password;
  String zip;
  Bookmarks bookmarks;

  Database({
    required this.email,
    required this.username,
    required this.password,
    required this.zip,
    required this.bookmarks,
  });

  factory Database.fromJson(Map<String, dynamic> json) => Database(
        email: json["email"],
        username: json["username"],
        password: json["password"],
        zip: json["zip"],
        bookmarks: Bookmarks.fromJson(json["bookmarks"]),
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "username": username,
        "password": password,
        "zip": zip,
        "bookmarks": bookmarks.toJson(),
      };
}

class Bookmarks {
  List<dynamic> shelther;
  List<dynamic> job;
  List<dynamic> healthcare;
  List<dynamic> veterinary;

  Bookmarks({
    required this.shelther,
    required this.job,
    required this.healthcare,
    required this.veterinary,
  });

  factory Bookmarks.fromJson(Map<String, dynamic> json) => Bookmarks(
        shelther: List<dynamic>.from(json["shelther"].map((x) => x)),
        job: List<dynamic>.from(json["job"].map((x) => x)),
        healthcare: List<dynamic>.from(json["healthcare"].map((x) => x)),
        veterinary: List<dynamic>.from(json["veterinary"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "shelther": List<dynamic>.from(shelther.map((x) => x)),
        "job": List<dynamic>.from(job.map((x) => x)),
        "healthcare": List<dynamic>.from(healthcare.map((x) => x)),
        "veterinary": List<dynamic>.from(veterinary.map((x) => x)),
      };
}
