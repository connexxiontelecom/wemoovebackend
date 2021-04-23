import 'package:hive/hive.dart';

part 'Credentials.g.dart';

@HiveType(typeId: 1)
class Credentials extends HiveObject {
  @HiveField(0)
  String username;

  @HiveField(1)
  String password;

  Credentials({this.username, this.password});
}
