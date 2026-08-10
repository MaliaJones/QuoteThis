// custom types & data storage
import 'quote.dart';
import 'package:andrea_app_v2/items_model.dart';
// other
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';


class DiscoverPage extends StatefulWidget{
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage>{
  // Quote categories (resiliance, productivity & action, leadership, recovery)
  late List<Quote> resil_cat = [];
  late List<Quote> panda_cat = [];
  late List<Quote> lead_cat = [];
  late List<Quote> recov_cat = [];
  late List<Quote> pg_quotes = [];

  bool isPressed = false;

  @override
  Widget build(BuildContext context){
    // Populate categories
    pg_quotes = context.read<ItemsModel>().quotes;
    for (Quote q in pg_quotes){
      if (q.tag == "resil"){
        resil_cat.add(q);
      } else if (q.tag == "panda"){
        panda_cat.add(q);
      } else if (q.tag == "lead"){
        lead_cat.add(q);
      } else if (q.tag == "recov"){
        recov_cat.add(q);
      } else{
        print("untagged quote");
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xffbbd5d7),
      extendBodyBehindAppBar: true,
      body: MediaQuery.removePadding(context: context, removeTop: true, child: ListView(children: [
        // Title
        Padding(padding: EdgeInsets.only(top: 22), child: Center(child: Text("Discover", style: GoogleFonts.montserrat(fontSize: 32, color: Colors.white, fontWeight: FontWeight.w600)))),
        // blank space
        SizedBox(height: 30),
        // Row Categories
        RowCategory(sectionTitle: "Resiliance", flipQuotes: [
          for (Quote q in resil_cat)
            FlipCard(quoteIdx: pg_quotes.indexOf(q))
        ]),
        Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 15, vertical: 15), child: Divider(color: Colors.white, thickness: 0.75)),
        RowCategory(sectionTitle: "Productivity & Action", flipQuotes: [
          for (Quote q in panda_cat)
            FlipCard(quoteIdx: pg_quotes.indexOf(q))
        ]),
        Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 15, vertical: 15), child: Divider(color: Colors.white, thickness: 0.75)),
        RowCategory(sectionTitle: "Leadership", flipQuotes: [
          for (Quote q in lead_cat)
            FlipCard(quoteIdx: pg_quotes.indexOf(q))
        ]),
        Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 15, vertical: 15), child: Divider(color: Colors.white, thickness: 0.75)),
        RowCategory(sectionTitle: "Recovery", flipQuotes: [
          for (Quote q in recov_cat)
            FlipCard(quoteIdx: pg_quotes.indexOf(q))
        ]),
      ]))
    );
  }
}

// CUSTOM CLASS/WIDGETS: FlipCard
class FlipCard extends StatefulWidget{
  final int quoteIdx;

  const FlipCard({super.key, required this.quoteIdx});

  @override
  _FlipCardState createState() => _FlipCardState();

}
class _FlipCardState extends State<FlipCard> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  bool isFront = true;
  bool isPressed = false;
  bool isPinned = false;
  late Quote myQuote;
  Color cardColor = Colors.white.withAlpha(100);

  @override
  void initState(){
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this
      );
      myQuote = context.read<ItemsModel>().quotes[widget.quoteIdx];
  }

  void flip(){
    if (isFront){
      _controller.forward();
    } else{
      _controller.reverse();
    }
    isFront = !isFront;
  }

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: flip,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child){
          double angle = _controller.value*3.14159;
          bool showFront = angle < 1.5708;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..setEntry(3, 2, 0.001)..rotateY(angle),
            child: showFront?_buildFront():Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateY(3.14159),
              child: _buildBack()
            )
          ); 
        }
      ),
    );

  }
  Widget _buildFront() => AnimatedScale(
    scale: isPressed?0.95:1.0,
    duration: Duration(milliseconds: 200),
    curve: Curves.easeOut,
    child: Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Color(0xff95cef2),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(
          color: Colors.black.withAlpha(40),
          spreadRadius: 1,
          blurRadius: 5,
          offset: const Offset(5, 5)
        )]
      ),
      child: Material(color: Colors.transparent, child: InkWell(
        onTap: () async {
          setState(()=>isPressed=true);
          await Future.delayed(Duration(milliseconds: 100));
          setState(()=>isPressed=false);
          flip();
        },
        borderRadius: BorderRadius.circular(20),
        splashColor: Colors.white.withAlpha(150),
      ))
    ));
    Widget _buildBack() => AnimatedScale(
    scale: isPressed?0.95:1.0,
    duration: Duration(milliseconds: 200),
    curve: Curves.easeOut,
    child: AnimatedContainer(
      duration: Duration(milliseconds: 200),
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(
          color: isPinned?Colors.blue:Colors.black.withAlpha(40),
          spreadRadius: isPinned?4:1,
          blurRadius: isPinned?3:5,
          offset: isPinned?const Offset(0, 0):const Offset(5, 5)
        )],
        // .withAlpha(100)
        image: DecorationImage(image: AssetImage(myQuote.imgURL), fit: BoxFit.cover, colorFilter: ColorFilter.mode(cardColor, BlendMode.srcATop))
      ),
      child: Material(color: Colors.transparent, child: InkWell(
        onTap: () async {
          if (!isPinned){
            setState(()=>isPressed=true);
            await Future.delayed(Duration(milliseconds: 100));
            setState(()=>isPressed=false);
            flip();
          }
        },
        onDoubleTap: (){
          setState(()=>isPinned=!isPinned);
        },
        onLongPress: (){
          setState(() {
            cardColor = Color(0xfffffdc4);
          });
          context.read<ItemsModel>().saveQuote(widget.quoteIdx);
          Future.delayed(Duration(milliseconds: 500), (){
            if (mounted){
              setState(() {
                cardColor = Colors.white.withAlpha(100);
              });
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("saved!", style: GoogleFonts.montserrat(fontSize: 15)),
            duration: Duration(milliseconds: 1000),
            backgroundColor: Colors.black.withAlpha(100),

          ));
        },
        borderRadius: BorderRadius.circular(20),
        splashColor: Colors.white.withAlpha(150),
        child: Center(child: AutoSizeText(myQuote.quote+".\n—"+myQuote.author, textAlign: TextAlign.center, maxLines: 10, minFontSize: 8, style: GoogleFonts.montserrat(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.w600
        )))
      ))
    ));
}

// CUSTOM WIDGET: RowCategory
class RowCategory extends StatelessWidget{
  final String sectionTitle;
  final List<FlipCard> flipQuotes;

  const RowCategory({
    super.key,
    required this.sectionTitle,
    required this.flipQuotes
  });

  @override
  Widget build(BuildContext context){
    return Column(children: [
      // Category Container
      Container(
        color:  Colors.transparent,
        width: double.infinity,
        height: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text
            Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 15),
              child: Text(
                sectionTitle,
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400
                ),
                textAlign: TextAlign.left,
              )),
              SizedBox(height: 15),
              // Tiles
              SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: flipQuotes.asMap().entries.map((entry){
                  final index = entry.key;
                  final tile = entry.value;
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0? 16 : 12
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                    SizedBox(
                      width: 130,
                      height: 130,
                      child: tile
                    ),
                    SizedBox(height: 5),
                    Padding(padding: EdgeInsetsGeometry.only(left: 3), child: Align(alignment: Alignment.centerLeft, child: SizedBox(width: 127, height: 25, child:
                      AutoSizeText("", minFontSize: 10, style: GoogleFonts.montserrat(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w500
                    )))))
                ]));
                }).toList(),
              ))
          ]
        )
      )
    ]);
  }}