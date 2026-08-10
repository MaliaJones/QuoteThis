// custom types & data storage
import 'package:andrea_app_v2/quote.dart';
import 'package:andrea_app_v2/items_model.dart';
// other
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';


// MAIN PG
class SavedPage extends StatefulWidget{
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _GoalsPageState();
}
class _GoalsPageState extends State<SavedPage>{

  String quoteUserInput = "";
  String authorUserInput = "";
  List<Quote> pg_quotes = [];
  List<int> pg_savedQuoteIdxs = [];
  List<Quote> savedQuotes = [];
  bool firstPress = false;
  List<bool> isPressed = [];
  bool showUnsave = false;

  @override
  void initState(){
    super.initState();
    pg_quotes = context.read<ItemsModel>().quotes;
    pg_savedQuoteIdxs = context.read<ItemsModel>().savedQuoteIdxs;
    for (int idx in pg_savedQuoteIdxs){
      savedQuotes.add(Quote(quote: pg_quotes[idx].quote, author: pg_quotes[idx].author, imgURL: pg_quotes[idx].imgURL, tag: pg_quotes[idx].tag));
    }
    isPressed = List.filled(savedQuotes.length, false, growable: true);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color(0xffbbd5d7),
      extendBodyBehindAppBar: true,
      body: MediaQuery.removePadding(context: context, removeTop: true, child: ListView(children: [
        // Title
        Padding(padding: EdgeInsets.only(top: 22), child: Center(child: Text("Saved", style: GoogleFonts.montserrat(fontSize: 32, color: Colors.white, fontWeight: FontWeight.w600)))),
        // Staggered Grid
        SizedBox(height: 25),
        SizedBox(height: 600, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 15), child:
          MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            itemCount: savedQuotes.length,
            itemBuilder: (context, index){
              return InkWell(
                onLongPress: () {
                  if (!isPressed.contains(true)){
                    setState(() {isPressed[index]=true;});
                    showUnsave = true;
                    }
                  },
                onTap: (){
                  if (isPressed.contains(true)){
                    setState((){isPressed[index]=!isPressed[index];});
                  }
                  if (!isPressed.contains(true)){
                    showUnsave = false;
                  }
                },
                child: Container(
                constraints: BoxConstraints(minHeight: 80),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage(savedQuotes[index].imgURL),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Colors.white.withAlpha(100), BlendMode.srcATop),
                  ),
                  boxShadow: [BoxShadow(
                    color: isPressed[index]?Colors.grey.shade600:Colors.transparent,
                    spreadRadius: 4,
                    blurRadius: 3,
                    offset: const Offset(0, 0)
                  )],
                ),
                
                child: Center(child: Text(savedQuotes[index].quote+".\n—"+savedQuotes[index].author, textAlign: TextAlign.center, style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w600
                )))
              ));
            },
          ))
        ),
      // Unsave button (pop-up)
      AnimatedSlide(offset: showUnsave?Offset(0, 0):Offset(0, 1.5), duration: Duration(milliseconds: 300), curve: Curves.easeOut, child:
      Column(mainAxisAlignment: MainAxisAlignment.center , children: [
        InkWell(onTap: (){
          for (int i = isPressed.length-1; i>= 0; i--){
            if (isPressed[i]){
              isPressed.removeAt(i);
              savedQuotes.removeAt(i);
              pg_savedQuoteIdxs.removeAt(i);
            }
          }
          showUnsave = false;
          setState((){});
          context.read<ItemsModel>().updateSavedQuoteIdxs(pg_savedQuoteIdxs);
        }, child:
          Container(height: 50, width: 50, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade600), child:
            Icon(Symbols.bookmark_remove_sharp, size: 30, color: Color(0xffe6e6e6)))
        ),
        Text("un-save", style: GoogleFonts.montserrat(
          color: Colors.grey.shade600,
          fontSize: 13,
          fontWeight: FontWeight.w500
        ))
      ]))
      ])
      ),
      // Add quote button
      floatingActionButton: IconButton(onPressed: (){
        // Create a new quote dialouge
        showDialog(context: context, builder: (context){return StatefulBuilder(builder: (context, setStateDialouge){return Dialog( child: Padding(
          padding: EdgeInsetsGeometry.all(15),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            // txt
            Padding(padding: EdgeInsets.all(5), child: Text("Add Your Own Quote", style: GoogleFonts.montserrat(fontSize: 20))),
            // textfield
            Container(padding: EdgeInsets.all(16), decoration: BoxDecoration(color: Color(0xfff5f5f5), borderRadius: BorderRadius.circular(16), border: Border.all(color: Color(0xff6db4e3), width: 1.2)), child: TextField(
              onChanged: (value){quoteUserInput=value;}, maxLines: null, keyboardType: TextInputType.multiline,
              decoration: InputDecoration(hintText: "Write quote here...", border: InputBorder.none),
              style: GoogleFonts.montserrat(fontSize: 15, color: Colors.black)
            )),
            // textfield
            Padding(padding: const EdgeInsetsGeometry.all(5), child: Text("by", style: GoogleFonts.montserrat(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w400))),
            Container(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5), decoration: BoxDecoration(color: Color(0xfff5f5f5), borderRadius: BorderRadius.circular(16), border: Border.all(color: Color(0xff6db4e3), width: 1.2)), child: TextField(
              onChanged: (value){authorUserInput=value;}, maxLines: null, keyboardType: TextInputType.multiline,
              decoration: InputDecoration(hintText: "Write author's name here...", border: InputBorder.none),
              style: GoogleFonts.montserrat(fontSize: 15, color: Colors.black)
            )),
            SizedBox(height: 10),
            // create button
            Center(child: InkWell(onTap: (){
              Navigator.pop(context);
              Quote newQuote = Quote(quote: quoteUserInput, author: authorUserInput, imgURL: "assets/images/tempimg.jpg", tag: "selfcreate");
              savedQuotes.add(newQuote);
              isPressed.add(false);
              context.read<ItemsModel>().addToQuotes(newQuote);
              setState((){});
              }, borderRadius: BorderRadius.circular(16), child: AnimatedScale(
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
      // looks of add quote button
      }, icon: Icon(
        Icons.add_circle_rounded,
        size: 55,
        color: Color(0xff6db4e3)
      ))
    );
  }
}