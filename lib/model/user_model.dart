import 'package:hive/hive.dart';

import '../db/db_const.dart';

part 'user_model.g.dart';

@HiveType(typeId: DBConst.Hive_Types_User)
class UserModel{

  @HiveField(0)
  String? name;

  @HiveField(1)
  String? nickName;

  @HiveField(2)
  int? expireTime;

  @HiveField(3)
  String? x_token;

  @HiveField(4)
  String? password;

  @HiveField(5)
  String? avatar;


  UserModel({this.name,this.nickName,this.expireTime,this.x_token,this.password,this.avatar,});

  static UserModel fromJson(Map<String,dynamic> rootData){
    ///解析第一层
    Map<String,dynamic> data = rootData["data"];
    ///解析第二层
    UserModel userModel = UserModel();

    userModel.name = data["name"];
    userModel.nickName = data["nickName"];
    userModel.expireTime= data["expireTime"];
    userModel.x_token = data["x-token"];
    userModel.password = data["password"];
    userModel.avatar = data["avatar"];

    return userModel;

  }



}