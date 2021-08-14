import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:plum_test/models/image.dart';
import 'package:plum_test/layout/drag_item.dart';
import 'dart:math';
import 'package:animate_do/animate_do.dart';

class DragAndDrop extends StatefulWidget {
  const DragAndDrop({ Key key }) : super(key: key);

  @override
  _DragAndDropState createState() => _DragAndDropState();
}

class _DragAndDropState extends State<DragAndDrop> {

  final Map<String, bool> score = {};
  Random random = new Random();
  int randomNum;

  void initState() {
    super.initState();
    context.read<ImageData>().fetchDragData;
    randomNum = random.nextInt(10);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[400],
        centerTitle: true,
        title: Text('Drag and Drop',
        style: GoogleFonts.ibmPlexSans(
          //textStyle: Theme.of(context).textTheme.headline4,
          fontSize: 26,
          fontWeight: FontWeight.w400,
          letterSpacing: .5,
          //fontStyle: FontStyle.italic,
        )),
        actions: [
          Padding(padding: EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () async {
                await context.read<ImageData>().fetchDragData;
                setState(() {
                  score.clear();          
                });
              },
              child: Icon(Icons.refresh_rounded, size: 26),
            ),
          )

        ],
        // titleTextStyle: TextStyle(
        //   fontSize: 24.0,
        // ),
      ),

      body: BounceInDown(
        child: Center(
          child: Consumer<ImageData>(
            builder: (context, value, child){
              return (value.dragMap.length == 0 && !value.dragError)
              ? SizedBox(height: MediaQuery.of(context).size.height, child: Center(child: CircularProgressIndicator()))
              : value.dragError ? Text('Oops. \n${value.dragErrorMessage}',
              //Error message when dragError == true
              textAlign: TextAlign.center,
              style: GoogleFonts.ibmPlexSans(
                //textStyle: Theme.of(context).textTheme.headline4,
                fontSize: 24,
                fontWeight: FontWeight.w400,
                //fontStyle: FontStyle.italic,
                //letterSpacing: .5,
              ), )
              : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: value.dragMap.keys.map((label){
                      return Draggable<String>(
                        data: label,
                        child: DragItem(label: score[label] == true ? '' : label), 
                        feedback: DragItem(label: label),
                        childWhenDragging: DragItem(label: ''),
                      );
                    }).toList()
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: value.dragMap.entries.map((e) => dropItem(e.key, e.value)).toList()..shuffle(Random(randomNum)),
                  )
                ],
              );
            }
          ),
        ),
      ) 
    );
  }

  Widget dropItem(String label, String url) => DragTarget<String>(
    builder: (BuildContext context, List<String> accepted, List rejected){
      if (score[label] == true) {
        return Container(
          child: Text('Correct', 
          style: GoogleFonts.ibmPlexSans(
            fontSize: 26,
            fontWeight: FontWeight.w400)
          ),
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height * 0.25,
          width: MediaQuery.of(context).size.width * 0.35,
        );
      } else {
        return Container(
          height: MediaQuery.of(context).size.height * 0.25,
          width: MediaQuery.of(context).size.width * 0.35,
          // height: 200,
          // width: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: NetworkImage(url), //Load image if image is selected
                fit: BoxFit.contain,
            ),
          ),
        );
      }
    },
    onWillAccept: (data) => data == label,
    onAccept: (data) {
      setState(() {
        score[label] = true;
      });
      compareResult(context, score);
    },
    onLeave: (data){},
  );

  void compareResult(BuildContext context, Map score){
    if (score.length == 3){
      Navigator.of(context).pushReplacementNamed('/dragResultSuccess');
    }
  }
}
