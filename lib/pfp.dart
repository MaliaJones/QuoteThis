import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PfpPage extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 32,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        // Top bar - back arrow
        title: Padding(padding: const EdgeInsets.only(top: 10), child:
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Transform.rotate(
              angle: -1.5708,
              child: Icon(Icons.navigation_sharp, color: Colors.white, size: 30,)
        )))
      ),

      body: Column( children: [
        Stack( children: [
          Container(height: 200, color: Colors.blue),
          // Profile pic circle
          Padding(padding: EdgeInsets.only(top: 100), child: Center(child: CircleAvatar(radius: 80, 
            //backgroundImage: AssetImage("assets/images/breath_man.jpg")
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Color.fromARGB(255, 71, 71, 71), size: 120)
          ))),
          // Edit button
          Padding(padding: EdgeInsets.only(top: 230, left: 270), child: Icon(Icons.edit, color: Color.fromARGB(255, 71, 71, 71), size: 30))
        ]),
        // extra space
        SizedBox(height: 50),
        // Prefrences **WIP**
        Padding(padding: EdgeInsets.only(left: 20), child: Align(alignment: Alignment.topLeft, child: Text("prefrences:", style: GoogleFonts.montserrat(
          fontSize: 22,
          color: Colors.black
        ))))
    ]));
  }
}