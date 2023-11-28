// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:net/config/cfg.dart';
import 'package:net/config/gui.dart';
import 'package:net/user/credentials.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class MongoDB {
  static var db, collection;

  static connect() async {
    db = await Db.create(dbGateway);
    await db.open();
    collection = db.collection(dbCollection);
  }

  static Future<String> _insert(Database data) async {
    try {
      var result = await collection.insertOne(data.toJson());
      if (result != null) {
        if (result.isSuccess) {
          return "Success";
        } else {
          inspect(result);
          return "Error";
        }
      } else {
        return "Bad request result";
      }
    } catch (e) {
      return e.toString();
    }
  }

  static Future<Map<String, dynamic>?> getUser(String username) async {
    return collection == null
        ? {username: "no"}
        : await collection.findOne({"username": username});
  }

  static Future<bool> signup(context, Database data) async {
    String result = await _insert(data);
    if (result == "Success") {
      Gui.notify(context, "You have signed up! Please log in.");
      return true;
    } else if (result == "Error") {
      Gui.notify(context, "Sign up has failed!");
      return false;
    } else {
      Gui.notify(context, "!: $result");
      return false;
    }
  }

  static Future<void> updateLocalUser(Database data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", data.email);
    prefs.setString("username", data.username);
    prefs.setString("password", data.password);
    prefs.setString("zip", data.zip);

    prefs.setStringList(
        "shelter", data.bookmarks.shelter.map((e) => e.toString()).toList());
    prefs.setStringList(
        "job", data.bookmarks.job.map((e) => e.toString()).toList());
    prefs.setStringList("healthcare",
        data.bookmarks.healthcare.map((e) => e.toString()).toList());
    prefs.setStringList("veterinary",
        data.bookmarks.veterinary.map((e) => e.toString()).toList());
  }

  static Future<Database> getLocalUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    /*List<List<dynamic>> bookmarks = [];
    stringList.forEach((element) {
      mapList.add({"name": "$element", "selected": false});
    });*/

    return Database(
        email: prefs.getString("email").toString(),
        username: prefs.getString("username").toString(),
        password: prefs.getString("password").toString(),
        zip: prefs.getString("zip").toString(),
        bookmarks: Bookmarks(
            shelter:
                [],
            job: [],
            healthcare: [],
            veterinary: []));
  }

  static void giveAccess(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(Config.accessPos, true);
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
  List<dynamic> shelter;
  List<dynamic> job;
  List<dynamic> healthcare;
  List<dynamic> veterinary;

  Bookmarks({
    required this.shelter,
    required this.job,
    required this.healthcare,
    required this.veterinary,
  });

  factory Bookmarks.fromJson(Map<String, dynamic> json) => Bookmarks(
        shelter: List<dynamic>.from(json["shelter"].map((x) => x)),
        job: List<dynamic>.from(json["job"].map((x) => x)),
        healthcare: List<dynamic>.from(json["healthcare"].map((x) => x)),
        veterinary: List<dynamic>.from(json["veterinary"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "shelter": List<dynamic>.from(shelter.map((x) => x)),
        "job": List<dynamic>.from(job.map((x) => x)),
        "healthcare": List<dynamic>.from(healthcare.map((x) => x)),
        "veterinary": List<dynamic>.from(veterinary.map((x) => x)),
      };
}
