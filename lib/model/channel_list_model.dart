import 'package:hive/hive.dart';

import '../db/db_const.dart';
import 'channel_model.dart';

part 'channel_list_model.g.dart';



@HiveType(typeId: DBConst.Hive_Types_CHANNEL_LIST)
class ChannelListModel {

  @HiveField(0)
  List<ChannelModel>? channels;

  ChannelListModel({this.channels,});

  static ChannelListModel fromJson(Map<String, dynamic> rootData) {
    List<dynamic> data = rootData["data"];
    ChannelListModel listModel = ChannelListModel();
    List<ChannelModel> list = [];
    for (var element in data) {
      ChannelModel warningModel = ChannelModel();
      warningModel.id = element["id"];
      warningModel.code = element["code"];
      warningModel.name = element["name"];
      warningModel.checked = element["checked"];
      list.add(warningModel);
    }
    listModel.channels = list;
    return listModel;
  }

}