//**GoalItem custom type */

import 'package:hive/hive.dart';
part 'goal.g.dart';

@HiveType(typeId: 1)
class GoalItem{
  @HiveField(0)
  String goalTxt;
  @HiveField(1)
  int goalNum;
  @HiveField(2)
  String icon;

  GoalItem({
    required this.goalTxt,
    required this.goalNum,
    this.icon = ""
  });

}