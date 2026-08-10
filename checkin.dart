import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class CheckInPage extends StatefulWidget{
  const CheckInPage({super.key});

  @override
  _CheckInPageState createState() => _CheckInPageState();
}
class _CheckInPageState extends State<CheckInPage>{
  int qidx = -1;
  // make list of Qs
  List<Question> questions = [
    Question(prompt: "How are you feeling?", type: "slider"),
    Question(prompt: "Feel free to add more details on your mood.", type: "freeResp"),
    Question(prompt: "What kind of messages do you need most today?", type: "mcq", answerChoices: ["Resiliance", "Productivity & Action", "Recovery", "Leadership"]),
  ];
  List<dynamic> answers = [];

  @override
  void initState(){
    super.initState();
    answers = List.filled(questions.length, null);
    // Transition from blank question --> 1st question
    Future.delayed(Duration(milliseconds: 500), (){setState((){qidx=0;});});
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color(0xff95cef2),
      // app bar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Padding(padding: const EdgeInsets.only(top: 25), child: Stack(
          children: [
            Align(alignment: Alignment.bottomCenter, child: Text("check-in", style: GoogleFonts.montserrat(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold))),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Transform.rotate(
                angle: -1.5708,
                child: Icon(Icons.navigation_sharp, color: Colors.white, size: 30,)
              ),
            )
          ],
        ))
      ),
      // body
      body: Center(child: Container( padding: EdgeInsets.symmetric(vertical: 180),
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.white.withAlpha(0), Colors.white, Colors.white, Colors.white.withAlpha(0)], begin: Alignment.topCenter, end: Alignment.bottomCenter, stops: [0.0, 0.3, 0.7, 1.0])),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
        // Question (+capture answer) + Animations & Transitions
        Center(child: AnimatedSize(duration: Duration(milliseconds: 300), curve: Curves.easeOut,
          child: AnimatedSwitcher(duration: Duration(milliseconds: 500), switchInCurve: Curves.easeIn, switchOutCurve: Curves.easeOut, transitionBuilder: (child, animation)=>FadeTransition(opacity: animation, child: child),
          child: BuildQuestions(questions: questions, startIdx: qidx, key: ValueKey(qidx), onAnswer: (value){answers[qidx]=value;})
          ))
        ),
        SizedBox(height: 25),
        // Next/Submit Button
        if (qidx < questions.length)
        InkWell(
          onTap: ()async{var oldidx = qidx; setState((){qidx=-1;}); await Future.delayed(Duration(milliseconds: 1000)); setState((){qidx=oldidx+1;}); if(qidx>=questions.length){}},
          borderRadius: BorderRadius.circular(16),
          child: AnimatedScale(
            scale: 1,
            duration: Duration(milliseconds: 150),
            child: Container(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(color: Color(0xff005f86), borderRadius: BorderRadius.circular(100)),
              child: Text(qidx>=questions.length-1?"submit":"next", style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500
              )))
          )
        )
      ])))
    );
  }
}
// ----------------------------------------------------------------------


// BuildQuestion class - builds questions
class BuildQuestions extends StatefulWidget{
  final List<Question> questions;
  final int startIdx;
  final Function(dynamic) onAnswer;

  const BuildQuestions({super.key, required this.questions, required this.startIdx, required this.onAnswer});
  @override
  State<BuildQuestions> createState() => _BuildQuestionsState();

}
class _BuildQuestionsState extends State<BuildQuestions>{
  double sliderVal = 0.0;
  String mcqVal = "";

  @override 
  Widget build(BuildContext context){
  Question emptyQ = Question(prompt: "", type: "");
  Question endQ = Question(prompt: "", type: "endQ");
  Question currQ = widget.startIdx >= widget.questions.length?endQ:(0<=widget.startIdx) && (widget.startIdx<widget.questions.length)? widget.questions[widget.startIdx]:emptyQ;
  // build UI based on type of question: slider, freeResp, or mcq
  switch(currQ.type){
    case "slider":
      return Column(
        children: [
          Text(currQ.prompt, style: GoogleFonts.montserrat(
            fontSize: 25,
            color: Colors.black
          )),
          SizedBox(height: 10),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              thumbColor: Color(0xff005f86),
              activeTrackColor: Color(0xff95cef2),
              inactiveTrackColor: Colors.grey
            ),
            child: Slider(
              value: sliderVal,
              min: 0,
              max: 10,
              divisions: 10,
              onChanged: (v){widget.onAnswer(sliderVal+1); setState((){sliderVal = v;});},
          )),
          Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 20), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children:
            List.generate(11, (i)=>Text("$i", style: TextStyle(fontSize: 12)))
          )),
          Padding(padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("bad", style: GoogleFonts.montserrat(fontSize: 17, color: Colors.black, fontWeight: FontWeight.w600)),
            Text("great", style: GoogleFonts.montserrat(fontSize: 17, color: Colors.black, fontWeight: FontWeight.w600)),
          ]))
        ],
      );
    case "freeResp":
      return Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Column(children: [
        Text(currQ.prompt, style: GoogleFonts.montserrat(
          fontSize: 20,
          color: Colors.black
        )),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xfff5f5f5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Color(0xff95cef2), width: 1.2)
          ),
          child: TextField(
            onChanged: widget.onAnswer,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(hintText: "Write response here...", border: InputBorder.none),
            style: GoogleFonts.montserrat(fontSize: 15, color: Colors.black)
          )
        )
      ]));
    case "mcq":
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(child: Padding(padding: EdgeInsets.symmetric(horizontal: 15), child: Text(currQ.prompt, style: GoogleFonts.montserrat(
            fontSize: 25,
            color: Colors.black
          )))),
          SizedBox(height: 10),
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            for (String answer in currQ.answerChoices ?? [])
              GestureDetector(onTap: (){widget.onAnswer(answer); setState((){mcqVal=answer;});}, child: Padding(padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5), child: Container(height: 50, decoration: BoxDecoration(color: mcqVal==answer?Color(0xffe3e3e3):Color(0xfff2f2f2), borderRadius: BorderRadius.circular(50)), child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                SizedBox(width: 10),
                AnimatedContainer(width: 35, height: 35, duration: Duration(milliseconds: 250), curve: Curves.easeOut, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Color(0xff005f86), width: 4), color: mcqVal==answer?Color(0xff005f86):Color(0xfff2f2f2))),
                SizedBox(width: 5),
                Text(answer, style: GoogleFonts.montserrat(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500))

            ])))),
          ])
        ],
      );
    // end case - all questions answered
    case "endQ": return Text("Questionnaire Submitted.", style: GoogleFonts.montserrat(fontSize: 23, color: Colors.black));
    default: return Text("");
  }
}
}

// Question class - defines types of questions
class Question{
  final String prompt;
  // slider, freeResp, mcq, mmcq, date, time, dropDown
  final String type;
  final List<String>? answerChoices;

  Question({
    required this.prompt,
    required this.type,
    this.answerChoices
  });
}