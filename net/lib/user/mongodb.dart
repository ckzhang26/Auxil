// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:net/config/cfg.dart';
import 'package:net/config/gui.dart';
import 'package:net/user/credentials.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/*
  Get user from mongodb  : MongoDB.getUser(String);
  Store user to local    : MongoDB.storeLocalUser(UserModel);
  Update user from local : MongoDB.syncLocalUser();
  Update local from user : MongoDB.saveLocalUser(); 
  Store locally and update instance from var : 
    MongoDB.setUser(UserModel);
*/

class MongoDB {
  static var db, collection;
  static late var user;

  static connect() async {
    db = await Db.create(dbGateway);
    await db.open();
    collection = await db.collection(dbCollection);
    await syncLocalUser(true);
  }

  static Future<String> _insert(UserModel data) async {
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

  static Future<UserModel?> getUser(String username) async {
    var user = await collection.findOne({"username": username});
    return user != null ? UserModel.fromJson(user) : null;
  }

  static Future<bool> signup(context, UserModel data) async {
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

  static Future<void> storeLocalUser(UserModel data) async {
    MongoDB.user = data;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", data.email);
    prefs.setString("username", data.username);
    prefs.setString("password", data.password);
    prefs.setString("zip", data.zip);

    prefs.setStringList(
        "shelter", data.shelter.map((e) => e.toString()).toList());
    prefs.setStringList("job", data.job.map((e) => e.toString()).toList());
    prefs.setStringList(
        "healthcare", data.healthcare.map((e) => e.toString()).toList());
    prefs.setStringList(
        "veterinary", data.veterinary.map((e) => e.toString()).toList());
  }

  static Future<void> syncLocalUser(bool init) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    MongoDB.user = UserModel(
      guest: init ? true : MongoDB.user.guest,
      email: prefs.getString("email").toString(),
      username: prefs.getString("username").toString(),
      password: prefs.getString("password").toString(),
      zip: prefs.getString("zip").toString(),
      shelter: prefs.getStringList("shelter") ?? [],
      job: prefs.getStringList("job") ?? [],
      healthcare: prefs.getStringList("healthcare") ?? [],
      veterinary: prefs.getStringList("veterinary") ?? [],
    );
  }

  static Future<void> setUser(UserModel user) async {
    storeLocalUser(user);
    syncLocalUser(false);
  }

  static Future<void> saveLocalUser() async {
    storeLocalUser(MongoDB.user);
    syncLocalUser(false);
  }

  static Future<bool> updateUserToDatabase(
      String username, UserModel newUser) async {
    var response = await collection.updateOne(
        where.eq('username', username),
        ModifierBuilder()
            .set('email', newUser.email)
            .set('username', newUser.username)
            .set('password', newUser.password)
            .set('zip', newUser.zip)
            .set('shelter', newUser.shelter)
            .set('job', newUser.job)
            .set('healthcare', newUser.healthcare)
            .set('veterinary', newUser.veterinary),
        writeConcern: const WriteConcern(w: 'majority', wtimeout: 5000));
    return response != null ? response.success : false;
  }

  static void giveAccess(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(Config.initAccessPos, true);
  }
}

UserModel databaseFromJson(String str) => UserModel.fromJson(json.decode(str));
String databaseToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  bool guest;
  String email;
  String username;
  String password;
  String zip;
  List<String> shelter;
  List<String> job;
  List<String> healthcare;
  List<String> veterinary;

  UserModel({
    required this.guest,
    required this.email,
    required this.username,
    required this.password,
    required this.zip,
    required this.shelter,
    required this.job,
    required this.healthcare,
    required this.veterinary,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        guest: false,
        email: json["email"],
        username: json["username"],
        password: json["password"],
        zip: json["zip"],
        shelter: List<String>.from(json["shelter"].map((x) => x)),
        job: List<String>.from(json["job"].map((x) => x)),
        healthcare: List<String>.from(json["healthcare"].map((x) => x)),
        veterinary: List<String>.from(json["veterinary"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "username": username,
        "password": password,
        "zip": zip,
        "shelter": List<dynamic>.from(shelter.map((x) => x)),
        "job": List<dynamic>.from(job.map((x) => x)),
        "healthcare": List<dynamic>.from(healthcare.map((x) => x)),
        "veterinary": List<dynamic>.from(veterinary.map((x) => x)),
      };

  static UserModel getGuest(String zip) {
    return UserModel(
      guest: true,
      email: "",
      username: "",
      password: "",
      zip: zip,
      shelter: [],
      job: [],
      healthcare: [],
      veterinary: [],
    );
  }
}
