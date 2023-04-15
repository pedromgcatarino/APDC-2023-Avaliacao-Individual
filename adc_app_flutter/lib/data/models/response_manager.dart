import 'user_model.dart';

class ResponseManager {
  final List<UserModel> userList;

  const ResponseManager({required this.userList});

  factory ResponseManager.fromJson(Map<dynamic, dynamic> json) =>
      ResponseManager(
          userList: List<UserModel>.from(
              (json as List).map((e) => UserModel.fromJson(e))));
}
