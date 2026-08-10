// custom types & data storage
import 'package:andrea_app_v2/items_model.dart';
// other
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
// Hive database
import 'package:hive/hive.dart';


// GLOBALS
// goals List
List<Goal> goals = [
  ];
// update goals (when txt changed)
void updateGoals(int n, String s){
  Goal oldGoal = goals[n-1];
  goals[n-1] = Goal(
    goalNum: oldGoal.goalNum,
    goalTxt: s,
    icon: oldGoal.icon,
  );
}

// MAIN PG
class GoalsPage extends StatefulWidget{
  const GoalsPage({super.key});

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}
class _GoalsPageState extends State<GoalsPage>{
  String chosenIcon = "";
  String goalUserInput = "";
  List<int> goalsToDelete = [];
  Map<int, String> goalsToUpdate = {};

  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      goals = context.read<ItemsModel>().ConvertGoalObj();
      setState((){});
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color(0xffbbd5d7),
      extendBodyBehindAppBar: true,
      body: MediaQuery.removePadding(context: context, removeTop: true, child: ListView(children: [
        // Title
        Padding(padding: EdgeInsets.only(top: 22), child: Center(child: Text("Goals", style: GoogleFonts.montserrat(fontSize: 32, color: Colors.white, fontWeight: FontWeight.w600)))),
        // Goal List
        SizedBox(height: 25),
        Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: [
          for (Goal goal in goals)
          Padding(padding: const EdgeInsetsGeometry.symmetric(vertical: 8), child: goal),
        ]),
        // Edit button
        Padding(padding: const EdgeInsetsGeometry.only(right: 15), child: Align(alignment: Alignment.topRight, child: IconButton(onPressed: (){
          // Edit goals dialouge box
          showDialog(context: context, builder: (context){return StatefulBuilder(builder: (context, setStateDialouge){return Dialog(
            child: Padding(padding: EdgeInsetsGeometry.all(15), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              // txt
              Padding(padding: EdgeInsets.all(5), child: Text("Edit Goals", style: GoogleFonts.montserrat(fontSize: 20))),
              // textformfield xgoals
              for (Goal goal in goals)
                Padding(padding: EdgeInsets.symmetric(vertical: 5), child: Row(children: [
                   Expanded(child: TextFormField(key: ValueKey("${goal.goalNum}-$goalsToDelete"), initialValue: goal.goalTxt, style: TextStyle(decoration: goalsToDelete.contains(goal.goalNum)?TextDecoration.lineThrough:null), onChanged: (value){goalsToUpdate[goal.goalNum] = value;}, maxLines: null, keyboardType: TextInputType.multiline, decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.grey, width: 1.2), borderRadius: BorderRadius.circular(15)),
                    focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.grey, width: 1.2), borderRadius: BorderRadius.circular(15))
                  ))),
                  SizedBox(width: 10),
                  // remove button xgoals
                  InkWell(onTap: (){setStateDialouge((){
                    if (goalsToDelete.contains(goal.goalNum)){
                      goalsToDelete.remove(goal.goalNum);
                    } else{
                      goalsToDelete.add(goal.goalNum);
                    }
                  });}, child: Icon(goalsToDelete.contains(goal.goalNum)?Icons.remove_circle:Icons.remove_circle_outline, size: 30, color: Colors.red))
                ])),
              SizedBox(height: 10),
              // save button
              Center(child: InkWell(onTap: (){
                if (goalsToUpdate.isNotEmpty){
                  goalsToUpdate.forEach((n, txt){updateGoals(n, txt); context.read<ItemsModel>().UpdateGoalsItemsModel(goals);});
                }
                Navigator.pop(context);
                setState((){
                  for (int n in goalsToDelete){
                    goals.remove(goals[n-1]);
                    for (Goal goal in goals){
                      if (goal.goalNum>n){
                        goal.goalNum-=1;
                      }
                    }
                  }
                  goalsToDelete.clear();
                  context.read<ItemsModel>().UpdateGoalsItemsModel(goals);
                });
                }, borderRadius: BorderRadius.circular(16), child: AnimatedScale(
              scale: 1, duration: Duration(milliseconds: 150), child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(color: Color(0xff6db4e3), borderRadius: BorderRadius.circular(100)),
                child: Text("save", style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500
              )))
            )))
            ])),
          );});});
        }, icon: Icon(Icons.edit), color: Colors.grey.shade600))),
      ])),
      // Add goal button
      floatingActionButton: IconButton(onPressed: (){
        // Create a new goal dialouge
        showDialog(context: context, builder: (context){return StatefulBuilder(builder: (context, setStateDialouge){return Dialog( child: Padding(
          padding: EdgeInsetsGeometry.all(15),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            // txt
            Padding(padding: EdgeInsets.all(5), child: Text("Create a New Goal", style: GoogleFonts.montserrat(fontSize: 20))),
            // textfield
            Container(padding: EdgeInsets.all(16), decoration: BoxDecoration(color: Color(0xfff5f5f5), borderRadius: BorderRadius.circular(16), border: Border.all(color: Color(0xff6db4e3), width: 1.2)), child: TextField(
              onChanged: (value){goalUserInput=value;}, maxLines: null, keyboardType: TextInputType.multiline,
              decoration: InputDecoration(hintText: "Write goal here...", border: InputBorder.none),
              style: GoogleFonts.montserrat(fontSize: 15, color: Colors.black)
            )),
            SizedBox(height: 10),
            // icon options
            Row(children: [
              Padding(padding: EdgeInsets.all(5), child: Text("icon:", style: GoogleFonts.montserrat(fontSize: 15))),
              Expanded(child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
                SizedBox(width: 5),
                for (var entry in Goal(goalTxt: "", goalNum: 0).iconMap.entries)
                  InkWell(key: ValueKey(entry.key), onTap: (){setStateDialouge((){chosenIcon=entry.key; print(chosenIcon);});}, child: Icon(entry.value, color: chosenIcon==entry.key?Color(0xff005f86):Color(0xff95cef2), size: 35)),
              ])))
            ]),
            SizedBox(height: 10),
            // create button
            Center(child: InkWell(onTap: (){Navigator.pop(context); goals.add(Goal(goalTxt: goalUserInput, goalNum: goals.length+1, icon: chosenIcon,));chosenIcon=""; goalUserInput=""; context.read<ItemsModel>().UpdateGoalsItemsModel(goals); setState((){});}, borderRadius: BorderRadius.circular(16), child: AnimatedScale(
              scale: 1, duration: Duration(milliseconds: 150), child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(color: Color(0xff6db4e3), borderRadius: BorderRadius.circular(100)),
                child: Text("create", style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500
              )))
            ))),
          ])));}
        );});
      // looks of Add goal button
      }, icon: Icon(
        Icons.add_circle_rounded,
        size: 55,
        color: Color(0xff6db4e3)
      )),

    );
  }
}
//---------------------------------------------------------------------------------


// Goal class - builds single goal widget
class Goal extends StatefulWidget{
  String goalTxt;
  int goalNum;
  final String icon;
  // map connecting String descriptor to Icon
  final Map<String, IconData> iconMap = {
    "default":Icons.flag_circle_rounded,
    "bell":Icons.circle_notifications_rounded,
    "activity":Icons.run_circle_rounded,
    "health":Icons.add_circle_rounded,
    "build":Icons.build_circle_rounded,
    "outdoors":Icons.cloud_circle_rounded,
    "swap":Icons.change_circle_rounded,
    "idea":Icons.lightbulb_circle_rounded,
    "others":Icons.supervised_user_circle_rounded,
  };

  Goal({
    super.key,
    required this.goalTxt,
    required this.goalNum,
    this.icon = "default"
  });

  @override
  _GoalState createState() => _GoalState();
}
class _GoalState extends State<Goal>{

  @override
  Widget build(BuildContext context){
    return Stack(children: [
      // rectangle
      Container(width: 375, height: 100, decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xff6db4e3), width: 2)
        ),
        // number, text, icon
        child: Row(children: [
          Padding(padding: const EdgeInsetsGeometry.only(left: 15), child: SizedBox(width: 30, child: Text(widget.goalNum.toString()+".", style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black)))),
          SizedBox(width: 275, child: Text(widget.goalTxt+".", style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black))),
          SizedBox(width: 20, child: Icon(widget.iconMap[widget.icon], size: 35, color: Color(0xff95cef2)))
        ])
      )
    ]);
  }
}