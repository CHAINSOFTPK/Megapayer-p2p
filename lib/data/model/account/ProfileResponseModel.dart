import 'package:local_coin/data/model/global/meassage/global_meassge.dart';
import 'package:local_coin/data/model/user/user.dart';

class ProfileResponseModel {
  ProfileResponseModel({
    String? remark,
    String? status,
    Message? message,
    Data? data,
  }) {
    _remark = remark;
    _status = status;
    _message = message;
    _data = data;
  }

  ProfileResponseModel.fromJson(dynamic json) {
    _remark = json['remark'];
    _status = json['status'].toString();
    _message = json['message'] != null ? Message.fromJson(json['message']) : null;
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? _remark;
  String? _status;
  Message? _message;
  Data? _data;

  String? get remark => _remark;
  String? get status => _status;
  Message? get message => _message;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['remark'] = _remark;
    map['status'] = _status;
    if (_message != null) {
      map['message'] = _message?.toJson();
    }
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}

class Data {
  Data({
    String? path,
    GlobalUser? user,
  }) {
    _user = user;
    _path = path;
  }

  Data.fromJson(dynamic json) {
    _user = json['user'] != null ? GlobalUser.fromJson(json['user']) : null;
    _path = json['user_image_path'].toString();
  }

  GlobalUser? _user;
  String? _path;
  GlobalUser? get user => _user;
  String? get path => _path;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    if (_path != null) {
      map['user_image_path'] = _path;
    }
    return map;
  }
}
