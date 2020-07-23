import 'package:flutter/material.dart';
import 'package:schuul/src/constants.dart';

class AttendScreen extends StatefulWidget {
  @override
  _AttendScreenState createState() => _AttendScreenState();
}

class _AttendScreenState extends State<AttendScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            "출결 관리",
            style: TextStyle(color: kTextColor),
          ),
          iconTheme: IconThemeData(
            color: kTextColor, //change your color here
          ),
          brightness: Brightness.light,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color(0xFFb5bfd0),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0.0,
          actions: [],
          bottom: TabBar(
            tabs: [
              Tab(
                child: Container(
                    child: Text("전체",
                        style: TextStyle(fontSize: 18, color: kTextColor))),
              ),
              Tab(
                child: Text("일별",
                    style: TextStyle(fontSize: 18, color: kTextColor)),
              ),
            ],
          ),
//    centerTitle: false,
        ),
        body: TabBarView(
          children: [
            Container(child: Text("전체")),
            Icon(Icons.directions_transit),

            // return Expanded(
            //             child: StickyHeadersTable(
            //               columnsLength: keys.length,
            //               rowsLength: snapshot.data.documents.length,
            //               columnsTitleBuilder: (i) => Text(keys[i]),
            //               rowsTitleBuilder: (i) {
            //                 Map doc = docList[i].data;
            //                 bool hasPhoto = false;
            //                 if (doc.containsKey("photoUrl") &&
            //                     doc["photoUrl"] != null &&
            //                     doc["photoUrl"].length > 0) {
            //                   hasPhoto = true;
            //                 }
            //                 return Row(
            //                   children: [
            //                     hasPhoto
            //                         ? ExtendedImage.network(doc["photoUrl"],
            //                             width: 30,
            //                             height: 30,
            //                             fit: BoxFit.fill,
            //                             cache: true,
            //                             shape: BoxShape.circle,
            //                             loadStateChanged: myloadStateChanged)
            //                         : ExtendedImage.asset(
            //                             "assets/images/login_bottom.png",
            //                             width: 30,
            //                             height: 30,
            //                             fit: BoxFit.fill,
            //                             shape: BoxShape.circle,
            //                             loadStateChanged: myloadStateChanged),
            //                     SizedBox(
            //                       width: 15,
            //                     ),
            //                     Text(docList[i].data["name"])
            //                   ],
            //                 );
            //               },
            //               contentCellBuilder: (i, j) => Material(
            //                   child: InkWell(
            //                       onTap: () {
            //                         print("$i, $j");
            //                       },
            //                       child: Text(data[i][j]))),
            //               legendCell: Text('학생 명단'),
            //             ),
            //           );
          ],
        ),
      ),
    );
  }
}
