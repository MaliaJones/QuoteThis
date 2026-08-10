// other pages
import 'package:andrea_app_v2/goals.dart';
// custom types
import 'package:andrea_app_v2/quote.dart';
import 'package:andrea_app_v2/goal.dart';
// other
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
// Hive database
import 'package:hive/hive.dart';

// GLOBALS
List<Quote> quotes_from_db = [];

//**This class serves as data storage for the app's quotes & goals**
//**Main interactor with the Hive database**
class ItemsModel extends ChangeNotifier{
  List<Quote> quotes = [];
  List<GoalItem> goals = [];
  // init Hive boxes
  final Box quotesBox;
  final Box goalsBox;

  ItemsModel(this.quotesBox, this.goalsBox){_init();}

  Future<void> _init() async {
    // load quotes from .csv
    await loadCsv();
    quotes = quotes_from_db;

    // load data from Hive boxes
    savedQuoteIdxs = quotesBox.get('savedQuoteIdxs', defaultValue: []);
    goals = goalsBox.get('savedGoals', defaultValue: []);
    notifyListeners();
  }

  // FUNCTIONS - QUOTES
  // add a new custom quote to saved
  void addToQuotes(Quote q){
    quotes.add(q);
    savedQuoteIdxs.add(quotes.length-1);
  }
  // add reg. quote to saved quotes index list
  List<int> savedQuoteIdxs = [];
  void saveQuote(int idx){
    if (!savedQuoteIdxs.contains(idx)){
      savedQuoteIdxs.add(idx);
      // add saved quote to Hive box
      quotesBox.put('savedQuoteIdxs', savedQuoteIdxs);
    }
  }
  // update saved quote index list
  void updateSavedQuoteIdxs(List<int> list){
    savedQuoteIdxs = list;
    // add saved quote to Hive box
    quotesBox.put('savedQuoteIdxs', savedQuoteIdxs);
  }
  // FUNCTIONS - GOALS
  // update goal item list
  void UpdateGoalsItemsModel(List<Goal> goal_objs_list){
    goals.clear();
    for (Goal g in goal_objs_list){
      goals.add(GoalItem(goalTxt: g.goalTxt, goalNum: g.goalNum, icon: g.icon));
    }
    // add saved goal to Hive box
    goalsBox.put('savedGoals', goals);
  }
  //convert between GoalItem to Goal
  List<Goal> ConvertGoalObj(){
    goals = (goalsBox.get('savedGoals', defaultValue: []) as List).cast<GoalItem>();
    List<Goal> temp = [];
    for (GoalItem g in goals){
      temp.add(Goal(goalTxt: g.goalTxt, goalNum: g.goalNum, icon: g.icon,));
    }
    return temp;
  }
  // FUNCTIONS - OTHER
  // parse .csv file with quotes data
  Future<void> loadCsv() async{
    final raw = await rootBundle.loadString("assets/quotes_db.csv");
    List<List<dynamic>> rows = const CsvToListConverter().convert(raw);

    quotes_from_db = [
      for (List<dynamic> row in rows)
        Quote(quote: row[0], author: row[1], imgURL: row[3], tag: row[2])
    ];
    notifyListeners();
  }
}