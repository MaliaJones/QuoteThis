import 'dart:ui';
// other pages
import 'package:andrea_app_v2/checkin.dart';
import 'package:andrea_app_v2/goals.dart';
import 'package:andrea_app_v2/discover.dart';
import 'package:andrea_app_v2/saved.dart';
import 'package:andrea_app_v2/pfp.dart';
// custom types & data storage
import 'package:andrea_app_v2/quote.dart';
import 'package:andrea_app_v2/goal.dart';
import 'package:andrea_app_v2/items_model.dart';
// other
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flip_card/flip_card.dart';
import 'dart:math';
// Hive database
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // Initalize Hive, register adapters, open boxes
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(GoalItemAdapter());
  final quotesBox = await Hive.openBox('quotesBox');
  final goalsBox = await Hive.openBox('goalsBox');

  runApp(ChangeNotifierProvider(create: (_)=> ItemsModel(quotesBox, goalsBox), child: 
    const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: MainPage()
    );
  }
}

// MAINPAGE (top & bottom bars)
class MainPage extends StatefulWidget{
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}
class _MainPageState extends State<MainPage>{
  final PageController _controller = PageController();
  int pageIdx = 0;
  double homeFade = 0.0;
  String searchWordQuick = "";

  void PageSwitcher(int pi, String w){
    searchWordQuick = w;
    FocusScope.of(context).unfocus();
    _controller.animateToPage(pi, duration: Duration(milliseconds: 300), curve: Curves.easeOutCubic); setState(()=>pageIdx=pi);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      extendBodyBehindAppBar: true,
      // Appbar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 40,
        actions: [
          GestureDetector(
            onTap: (){Navigator.push(context, PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 300),
              reverseTransitionDuration: Duration(milliseconds: 150),
              pageBuilder: (_, __, ___)=>PfpPage(),
              transitionsBuilder: (_, animation, __, child){
                final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
                return FadeTransition(opacity: curved, child: ScaleTransition(alignment: Alignment.topRight, scale: Tween<double>(begin: 0.9, end: 1.0).animate(curved), child: child));
              }
              ));},
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: CircleAvatar(radius: 15, backgroundColor: Colors.white, child: Icon(Icons.person, color: Color.fromARGB(255, 71, 71, 71)))
              )
          )
        ]
      ),

      // Body
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _controller,
        onPageChanged: (_){},
        children: [
          // pages
          HomePage(
            onFadeChanged: (value){setState(()=>homeFade=value);},
            pageSwitcher: PageSwitcher
          ),
          GoalsPage(),
          DiscoverPage(),
          SavedPage()
        ],
      ),

      // Bottom Nav Bar
      bottomNavigationBar: Container(
        height: 100,
        color: const Color(0xff95cef2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // home
            GestureDetector(
              onTap: (){_controller.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.easeOutCubic); setState(()=>pageIdx=0); homeFade=1; searchWordQuick="";},
              child: AnimatedScale(scale: pageIdx==0?1.1: 1.0, duration: Duration(milliseconds: 100), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(pageIdx==0? Icons.home:Icons.home_outlined, color: Colors.white, size: 45),
              Text("home", style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500
              ))
            ]))
            ),
            // goals
            GestureDetector(
              onTap: (){_controller.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.easeOutCubic); setState(()=>pageIdx=1); searchWordQuick="";},
              child: AnimatedScale(scale: pageIdx==1?1.1: 1.0, duration: Duration(milliseconds: 100), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(pageIdx==1?Icons.check_circle_sharp:Icons.check_circle_outline_sharp, color: Colors.white, size: 39),
              Text("goals", style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500
              ))
            ]))
            ),
            // discover
            GestureDetector(
              onTap: (){_controller.animateToPage(2, duration: Duration(milliseconds: 300), curve: Curves.easeOutCubic); setState(()=>pageIdx=2);},
              child: AnimatedScale(scale: pageIdx==2?1.05: 1.0, duration: Duration(milliseconds: 100), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Stack(children: [
                Icon(pageIdx==2?Icons.search:Icons.search, color: Colors.white, size: 43),
                Positioned(left: 4, top: 4, child: Icon(pageIdx==2?Icons.circle:Icons.circle_outlined, color: Colors.white, size: 25))
              ]),
              Text("discover", style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500
              ))
            ]))
            ),
            // saved
            GestureDetector(
              onTap: (){_controller.animateToPage(3, duration: Duration(milliseconds: 300), curve: Curves.easeOutCubic); setState(()=>pageIdx=3);},
              child: AnimatedScale(scale: pageIdx==3?1.1: 1.0, duration: Duration(milliseconds: 100), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(pageIdx==3?Icons.bookmark_sharp:Icons.bookmark_border_sharp, color: Colors.white, size: 40),
              Text("saved", style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500
              ))
            ]))
            ),
          ]),
    )
    );
  }
}
//----------------------------------------------------------------------------------------------


// HOMEPAGE
class HomePage extends StatefulWidget{
  final Function(double)? onFadeChanged;
  final Function(int, String) pageSwitcher;
  const HomePage({this.onFadeChanged, required this.pageSwitcher, super.key});
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  final ScrollController _scroll = ScrollController();
  double titleOffset = 0;
  double titleScale = 1;
  List<Quote> activities = [];
  int pathOption = 0;
  String newPath = "";
  List<int> randCardIdxs = [];
  final rand = Random();

  @override
  void initState(){
    super.initState();
    _scroll.addListener((){
      final offset = _scroll.offset.clamp(0.0, 120.0);
      setState(() {
        titleOffset = offset;
        titleScale = 1 - (offset/300);
      });
      final rawT = (offset-120)/(70-120);
      final double t = rawT.clamp(0.0, 1.0);
      if (widget.onFadeChanged != null){widget.onFadeChanged!(t);}
    });
  }

    @override
    void dispose(){
      _scroll.dispose();
      super.dispose();
    }

  //**Content**
  bool isPressed = false;
  bool sectionHit = false;
  @override
  Widget build(BuildContext context) {
    // Load quotes into flipcard tiles
    final items = context.watch<ItemsModel>();
    if (items.quotes.isEmpty){
      return const Center(child: CircularProgressIndicator());
    }
    activities = context.read<ItemsModel>().quotes;
    randCardIdxs.clear();
    int count = 0;
    while (count < 9){
      int n = rand.nextInt(activities.length);
      Quote currQuote = activities[n];
      if (currQuote.tag != "selfcreate"){
        randCardIdxs.add(n);
        count++;
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xffbbd5d7),
        body: MediaQuery.removePadding(context: context, removeTop: true, child: ListView(
          controller: _scroll,
          children: [
            // Container1: Picture + Greeting
            Stack(children: [
            Positioned.fill(child: Image.asset(
              'assets/images/lakerocks.jpg',
              alignment: Alignment.topCenter,
              color: Colors.black.withAlpha(25),
              colorBlendMode: BlendMode.darken,
            )),
            Column( children: [
            SizedBox(height: 50),
            SizedBox(
            width: double.infinity,
            height: 60,
            child: Stack(
              fit: StackFit.expand,
              children: [
              Center(
                child: Transform.scale(
                scale: titleScale.clamp(0.6, 1),
                child: Text(
                  "hello, user",
                  style: GoogleFonts.dongle(
                    fontSize: 55,
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                  ))
              )
            )
            ])),
          // Container2: Betweens + Daily Quote Board
          Container(
            decoration: BoxDecoration(
              color: const Color(0xffbbd5d7),
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors:[const Color(0xffbbd5d7).withAlpha(0), const Color(0xffbbd5d7)],
                stops: [0.0, 0.05]
              )
            ),
            child: Column(children: [
              // extra space
              SizedBox(height: 40),
              // check-in button
              Align(
              alignment: Alignment.center,
              child: Padding(
              padding: EdgeInsetsGeometry.all(20),
              child: Listener(onPointerDown:(_)=>setState(()=>isPressed=true), onPointerUp:(_)=>setState(()=>isPressed=false), onPointerCancel:(_)=>setState(()=>isPressed=false), child: AnimatedContainer(duration: Duration(milliseconds: 500), curve: Curves.easeOutCubic, child: ElevatedButton(
                onPressed: ()async{setState(()=>isPressed=false); await Future.delayed(Duration(milliseconds: 150)); Navigator.push(context, MaterialPageRoute(builder: (context) => CheckInPage()));},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffa1c6de),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                  padding: EdgeInsets.symmetric(horizontal: 35, vertical: 13),
                  elevation: isPressed?0.0:7.0,
                ),
                child: Text("check-in", style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w500
                ))
              ))),
              )),
              // grid title
              Padding(padding: const EdgeInsetsGeometry.only(top: 20), child: Center(child:Text(
                "Your daily quotes",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500
                )
              ))),
              // 3x3 flipping tiles layout
              Container(width: double.infinity, height: 480, child: Padding(padding: const EdgeInsets.all(20), child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 11,
                crossAxisSpacing: 11,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(), 
                children: [
                  for (int i in randCardIdxs)
                    FlipCard(quoteIdx: i),
                  ]))
                )
            ])
        ),
        ])
        ]),
      ])),
    );
  }}

// ------------------------------------------------------------------------


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