import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Revision extends StatefulWidget {

  @override
  _RevisionState createState() => _RevisionState();
}

class _RevisionState extends State<Revision> {

  // final CollectionReference imageReference = FirebaseFirestore.instance.collection("Images");

  // List<Images> _imageListFromSnapshot (QuerySnapshot snapshot){
  //   return snapshot.docs.map((doc) {
  //     return Images(
  //       label: doc.get('label') ?? '',
  //       url: doc.get('url') ?? '',
  //     );
  //   }).toList();
  // }

  // Stream <List<Images>> imageStream(){
  //   return imageReference.snapshots()
  //     .map(_imageListFromSnapshot);
  // }

  

  // CollectionReference _imageReference = FirebaseFirestore.instance.collection("Images");

  //Map <String, List> _imageMap = {};

  // Map <String, List> imageMap = {};

  // List labelList = [];

  @override
  void initState() {
    super.initState();
    //acquireClassData();
    //displayImage();
  }

  // displayImage() {
  //   return FutureBuilder(
  //     future: _collectionReference.get(),
  //     builder: (context, imageSnapshot){
  //       if (!imageSnapshot.hasData){
  //         return Center(
  //           child: Text("Loading"),
  //         );
  //       } 
  //       List <ImageList> imageResult = [];
  //       imageSnapshot.data.documents.forEach((element) async {
  //           DocumentSnapshot post1 = await _collectionReference
  //               .doc(element.id)
  //               .collection("Images")
  //               .doc("url")
  //               .get();
  //           ImageModel images = ImageModel.fromDocument(post1);
  //           ImageList imageList = ImageList(images);
  //           imageResult.add(imageList);
  //           //print("the posts is $postsresult");
  //       });
  //       return ListView(children: imageResult);
  //     });
  // }

  // Future acquireClassData() async {

  //   QuerySnapshot classData = await _collectionReference.get();
  //   for (var doc in classData.docs){
  //     Map<String, dynamic> labelMap = doc.data();
  //     dynamic label = labelMap['label'].toString();
  //     labelList.add(label);
  //   }

  //   getImageUrl(labelList);
  //   print(labelList);
  // }

  // getImageUrl (List list) async {

  //   for (String label in list){
  //     //print("$label");
  //     QuerySnapshot imageData = await FirebaseFirestore.instance.collection("$label").get();
  //     for (var doc in imageData.docs){
  //       Map<String, dynamic> urlMap = doc.data();
  //       var url = urlMap['url'];
  //       //print("$url");
  //       imageMap.update(label, (urlList) => urlList..add(url), ifAbsent: () => [url]);
  //     }
  //   }
  //   print(imageMap);
  //   return imageMap;
  // }

  // Future getImageSnapshot(CollectionReference collectionReference) async {
  //   QuerySnapshot imageSnapshot = await collectionReference.get();
  //   print(imageSnapshot);
  //   return imageSnapshot;
  // }

  // Widget _buildFutureBuilder() {
  //   return Center(
  //     child: FutureBuilder(
  //       future: getImageSnapshot(_collectionReference),
  //       builder: (context, snapshot) {
  //           return Text("Image Data= ${snapshot.data}");

  //       },
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[400],
        centerTitle: true,
        title: Text('Revision'),
        titleTextStyle: TextStyle(
          fontSize: 24.0,
        ),
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Images').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // return ListView(
          //   children: snapshot.data.docs.map((document) {
          //       return SizedBox(
          //         height: 300,
          //         child: ListView.builder(
          //           scrollDirection: Axis.horizontal,
          //           itemCount: 1,
          //           itemBuilder: (_, __) => Container(
          //             margin: EdgeInsets.all(12), 
          //             width: 300, 
          //             decoration: BoxDecoration(
          //               image: DecorationImage(
          //                 image: NetworkImage(document['url']),
          //                 fit: BoxFit.scaleDown,
          //               )
          //             ),
          //           ),
          //         ),
          //       );
          //   }).toList(),
          // );

          return ListView(
            children: snapshot.data.docs.map((document) {
              return Center(
                child: Column(
                  children: [
                    SizedBox(height: 20),

                    Text(document['label']),

                    SizedBox(height: 20),

                    Container(
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.width / 1,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(document['url']),
                          fit: BoxFit.scaleDown
                        )
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        }
      ),

      // body: StreamBuilder(
      //   stream: FirebaseFirestore.instance.collection('Images').snapshots(),
      //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
      //     if(!snapshot.hasData){
      //       return Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }

          
      //     // return ListView.builder(
      //     //   itemCount: snapshot.data.size,
      //     //   itemBuilder: (context, i) => SizedBox(
      //     //     height: 300,
      //     //     child: ListView.builder(
      //     //       scrollDirection: Axis.horizontal,
      //     //       itemBuilder: (_, __) => Container(
      //     //         margin: EdgeInsets.all(12), 
      //     //         width: 300, 
      //     //         color: Colors.orange),
      //     //     ),
      //     //   ),
      //     // );

      //     // return ListView(
      //     //   children: snapshot.data.docs.map((document) {
      //     //     return Center(
      //     //       child: Column(
      //     //         children: [
      //     //           Text("Label\n" + document['label'] + "\nUrl " + document['url']),

      //     //           Container(
      //     //             height: MediaQuery.of(context).size.height / 6,
      //     //             width: MediaQuery.of(context).size.width / 1.2,
      //     //             decoration: BoxDecoration(
      //     //               image: DecorationImage(
      //     //                 image: NetworkImage(document['url']),
      //     //                 fit: BoxFit.scaleDown
      //     //               )
      //     //             ),
      //     //           )
      //     //         ],
      //     //       ),
      //     //     );
      //     //   }).toList(),
      //     // );

      //     return ListView(
      //       children: snapshot.data.docs.map((document) {
      //           return SizedBox(
      //             height: 300,
      //             child: ListView.builder(
      //               scrollDirection: Axis.horizontal,
      //               itemCount: snapshot.data.size,
      //               itemBuilder: (_, __) => Container(
      //                 margin: EdgeInsets.all(12), 
      //                 width: 300, 
      //                 decoration: BoxDecoration(
      //                   image: DecorationImage(
      //                     image: NetworkImage(document['url']),
      //                     fit: BoxFit.scaleDown,
      //                   )
      //                 ),
      //               ),
      //             ),
      //           );

      //         // (
      //         //   child: Center(
      //         //     child: Column(
      //         //       children: [
      //         //         Text("Label\n" + document['label'] + "\nUrl " + document['url']),

      //         //         Container(
      //         //           height: MediaQuery.of(context).size.height / 6,
      //         //           width: MediaQuery.of(context).size.width / 1.2,
      //         //           decoration: BoxDecoration(
      //         //             image: DecorationImage(
      //         //               image: NetworkImage(document['url']),
      //         //               fit: BoxFit.scaleDown
      //         //             )
      //         //           ),
      //         //         )
      //         //       ],
      //         //     ),
      //         //   ),
      //         // );
      //       }).toList(),
      //     );
      //   }
      // ),

      // body: StreamBuilder(
      //   stream: _imageReference.snapshots(),
      //   builder: ,
      // ),

      // body: StreamBuilder<QuerySnapshot> (
      //   stream: _classReference.snapshots(),
      //   builder: (context, labelSnapshot){
      //     List labelList = [];
      //     for (var doc in labelSnapshot.data.docs){
      //       Map<String, dynamic> labelMap = doc.data();
      //       String label = labelMap['label'].toString();
      //       labelList.add(label);
      //       print(labelMap);
      //     }
      //     print(labelList);
          
      //     return StreamBuilder(
      //       stream: _imageReference.snapshots(),
      //       builder: (context, imageSnapshot){
              

      //         return ListView.builder(
      //           itemCount: labelSnapshot.data.docs.length,
      //           itemBuilder: (context, index){
      //             return _horizontalListView();
      //         });
      //       }
      //     );
        

      //       // return ListView.builder(
      //       //   itemCount: labelSnapshot.data.docs.length,
      //       //   itemBuilder: (context, index){
      //       //     DocumentSnapshot doc = labelSnapshot.data.docs[index];
      //       //     final label = doc['label'];
      //       //     final url = doc['url'];
      //       //     final labelList = [];
      //       //     labelList.add(label);
      //       //     return Container(
      //       //       height: 200,
      //       //       width: 200,
      //       //       alignment: Alignment.center,
      //       //       decoration: BoxDecoration(
      //       //         image: DecorationImage(
      //       //           image: NetworkImage(url),
      //       //           fit: BoxFit.contain,
      //       //         )
      //       //       ),
      //       //     );
      //       //   });
      //   },
      // )

      // body: Column(
      //   children: [
      //     SizedBox( // Horizontal ListView
      //       height: 100,
      //       child: ListView.builder(
      //         itemCount: 20,
      //         scrollDirection: Axis.horizontal,
      //         itemBuilder: (context, index) {
      //           return Container(
      //             width: 100,
      //             alignment: Alignment.center,
      //             color: Colors.blue[(index % 9) * 100],
      //             child: Text(index.toString()),
      //           );
      //         },
      //       ),
      //     ),
          
      //     SizedBox(
      //       height: 200,
      //       child: ListView.builder(
      //         itemCount: imageMap.length,
      //         itemBuilder: (context, index){
      //           return Container(
      //             width: 100,
      //             height: 100,
      //             alignment: Alignment.center,
      //             color: Colors.orange[(index % 9) * 100],
      //             child: Text(index.toString()),
      //           );
      //         }),
      //     )
      //   ],
      // )

      // body: new Center(
      //   child: new ListView(
      //     children: [
      //       new Container(
      //         height: 80.0,
      //         child: new ListView(
      //           scrollDirection: Axis.horizontal,
      //           children: new List.generate(10, (int index) {
      //             return new Card(
      //               color: Colors.blue[index * 100],
      //               child: new Container(
      //                 width: 50.0,
      //                 height: 50.0,
      //                 child: new Text("$index"),
      //               ),
      //             );
      //           }),
      //         ),
      //       )
      //     ],
      //   ),
      // ),

      
      
    );
  }

  // _verticalListView(AsyncSnapshot<QuerySnapshot> snapshot){
  //   return snapshot.data.docs.map((doc){
  //     return ListView(
  //       children: snapshot.data.docs.map((document) {
  //         return Center(
  //           child: Column(
  //             children: [
  //               Text("Label\n" + document['label'] + "\nUrl " + document['url']),

  //               Container(
  //                 height: MediaQuery.of(context).size.height / 6,
  //                 width: MediaQuery.of(context).size.width / 1.2,
  //                 decoration: BoxDecoration(
  //                   image: DecorationImage(
  //                     image: NetworkImage(document['url']),
  //                     fit: BoxFit.scaleDown
  //                   )
  //                 ),
  //               )
  //             ],
  //           ),
  //         );
  //       }).toList(),
  //     );
  //   });
  // }

  // children: snapshot.data.docs.map((document) {
  //               return SizedBox(
  //                 height: 300,
  //                 child: ListView.builder(
  //                   scrollDirection: Axis.horizontal,
  //                   itemCount: 1,
  //                   itemBuilder: (_, __) => Container(
  //                     margin: EdgeInsets.all(12), 
  //                     width: 300, 
  //                     decoration: BoxDecoration(
  //                       image: DecorationImage(
  //                         image: NetworkImage(document['url']),
  //                         fit: BoxFit.scaleDown,
  //                       )
  //                     ),
  //                   ),
  //                 ),
  //               );

  // Widget _horizontalListView() {
  //   return SizedBox(
  //     height: 300,
  //     child: ListView.builder(
  //       scrollDirection: Axis.horizontal,
  //       itemBuilder: (_, __) => _buildBox(color: Colors.orange),
  //     ),
  //   );
  // }

  // Widget _buildBox() => Container(
  //   margin: EdgeInsets.all(12), 
  //   width: 300, 
  //   color: Colors.orange);
}
