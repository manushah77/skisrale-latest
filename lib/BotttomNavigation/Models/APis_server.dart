import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:skisreal/BotttomNavigation/Models/search_class.dart';

class SearchFeed {
  var data = [];
  List<FeedDetail> results = [];
  String urlList = 'https://sk.jeuxtesting.com/api/search_feed';

  Future<List<FeedDetail>> getuserList({String? query}) async {
    var url = Uri.parse(urlList);
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {

        data = json.decode(response.body);
        results = data.map((e) => FeedDetail.fromJson(e)).toList();
        if (query!= null){
          results = results.where((element) => element.title!.toLowerCase().contains((query.toLowerCase()))).toList();
          results = results.where((element) => element.opinion!.toLowerCase().contains((query.toLowerCase()))).toList();
        }
      } else {
        print("fetch error");
      }
    } on Exception catch (e) {
      print('error: $e');
    }
    return results;
  }
}

//
// Add the rest of your widgets here, using _searchList
// to display the filtered data.
// For example:

// Expanded(
//   child: ListView.builder(
//       itemCount: _searchList.length,
//       itemBuilder: (
//           context,
//           index,
//           ) {
//         return InkWell(
//           onTap: (){
//             PersistentNavBarNavigator.pushNewScreen(context,
//                 screen: FavoriteScreenDetail(
//                   timing: timing,
//                   image: images,
//                   title: '${_searchList[index]['title']}',
//                   siteName: '${_searchList[index]['website']}',
//                   skitrack: '${_searchList[index]['track']}',
//                   skiSlop: '${_searchList[index]['ski_slops']}',
//                   skilift: '${_searchList[index]['ski_lift']}',
//                   location: '${_searchList[index]['location']}',
//                   description:
//                   '${_searchList[index]['description']}',
//                   phone: '${_searchList[index]['phone_number']}',
//                   rate: '${_searchList[index]['rate']}',
//                   siteId: _searchList[index]['id'],
//                 ),
//                 withNavBar: false,
//                 pageTransitionAnimation:
//                 PageTransitionAnimation.fade);
//           },
//           child: ListTile(
//             trailing: Container(
//               width: 50,
//               height: 50,
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: NetworkImage(
//                     '${_searchList[index]['images'][0]['image']}',
//                   ),
//                   fit: BoxFit.fill,
//                 ),
//                 shape: BoxShape.circle,
//               ),
//             ),
//             title: Text(
//               '${_searchList[index]['title']}',
//               textAlign: TextAlign.right,
//               style: TextStyle(
//                 color: Color(0xFF172B4C),
//                 fontSize: 16,
//                 fontFamily: 'Inter',
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             subtitle: Text(
//               '${_searchList[index]['location']}',
//               textAlign: TextAlign.right,
//               style: TextStyle(
//                 color: Color(0xFF72777F),
//                 fontSize: 12,
//                 fontFamily: 'Inter',
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//             leading: Padding(
//               padding: const EdgeInsets.only(top: 8.0),
//               child: Icon(
//                 Icons.arrow_forward_ios,
//               ),
//             ),
//           ),
//         );
//       }),
// ),
