import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:medical_reminder/services/shared_prefs.dart';

class RatingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RatingPageState();
}

class Review {
  String name, email, review;
  double rate;
  Review(name, email, review, rate) {
    this.name = name;
    this.email = email;
    this.review = review;
    this.rate = double.tryParse(rate.toString());
  }
}

class _RatingPageState extends State<RatingPage>
    with SingleTickerProviderStateMixin {
  final databaseReference = FirebaseDatabase.instance.reference();
  double myRate = 0.0;
  double overallRate = 0.0;
  TextEditingController _textReviewController = new TextEditingController();
  String name, email;

  List<Review> reviews = new List();
  @override
  void initState() {
    super.initState();
    getSharedData();
    getData();
  }

  void getData() {
    reviews.clear();
    int listLength;
    double sum = 0.0;
    databaseReference.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> map = snapshot.value;
      var list = map.values.toList();
      listLength = list.length;
      for (int i = 0; i < list.length; i++) {
        reviews.add(new Review(
            list.elementAt(i)['name'],
            list.elementAt(i)['email'],
            list.elementAt(i)['review'],
            list.elementAt(i)['rate']));
        sum += double.tryParse(list.elementAt(i)['rate'].toString());
      }
      setState(() {
        overallRate = sum / listLength;
      });
    });
  }

  getSharedData() {
    SharedPrefs().getSharedEmail().then((mail) {
      setState(() {
        email = mail;
      });
    });
    SharedPrefs().getSharedName().then((nme) {
      setState(() {
        name = nme;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Application Rating",
          style: TextStyle(color: Colors.white),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: Theme(
            data: Theme.of(context).copyWith(accentColor: Colors.blue),
            child: Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    RatingBar(
                      initialRating: overallRate,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      ignoreGestures: true,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                    Container(
                      height: 5,
                    ),
                    Text(
                      "Average Rating",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white),
                    )
                  ],
                )),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            child: Text(
              "Reviews:",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            child: ListView(shrinkWrap: true, children: reviewsList()),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                contentPadding: EdgeInsets.all(2),
                title: Center(
                  child: Text(
                    "Post your Review",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                content: Container(
                  margin: EdgeInsets.only(top: 25),
                  child: dialogContent(context),
                ),
              );
            },
          );
        },
        child: Icon(Icons.rate_review),
      ),
    );
  }

  List<Widget> reviewsList() {
    List<Widget> listItems = new List();
    for (int i = 0; i < reviews.length; i++) {
      listItems.add(Container(
        margin: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Container(
                    margin: EdgeInsets.only(right: 10),
                    color: Colors.transparent,
                    child: new Container(
                      decoration: new BoxDecoration(
                          color: Colors.green,
                          borderRadius: new BorderRadius.all(
                              const Radius.circular(40.0))),
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 5, right: 5, top: 3, bottom: 3),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              reviews.elementAt(i).rate.toString() + " ",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                            Icon(
                              Icons.star,
                              size: 12,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    )),
                Text(
                  reviews.elementAt(i).name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  "  >> " + reviews.elementAt(i).email,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 5, left: 50),
              child: Text(
                reviews.elementAt(i).review,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
              ),
            )
          ],
        ),
      ));
    }
    return listItems;
  }

  Widget dialogContent(context) {
    return StatefulBuilder(// You need this, notice the parameters below:
        builder: (BuildContext context, StateSetter setState) {
      return ListView(shrinkWrap: true, children: <Widget>[
        Center(
          child: RatingBar(
            initialRating: 0,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              print(rating);
              myRate = rating;
            },
          ),
        ),
        Container(
          height: 10,
        ),
        TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          minLines: 2,
          controller: _textReviewController,
          decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: 'Write your opinion about \n the app .. ',
            labelText: 'Your Review',
            prefixIcon: const Icon(
              Icons.edit,
              color: Colors.blueGrey,
            ),
            prefixText: ' ',
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 15),
          width: double.infinity,
          child: RaisedButton(
            color: Colors.blue,
            onPressed: () {
              databaseReference
                  .child(email.replaceAll(new RegExp(r'[^\w\s]+'), ''))
                  .set({
                'name': name,
                'rate': myRate,
                'review': _textReviewController.text,
                'email': email
              });
              Navigator.of(context).pop();
              getData();
            },
            child: Text(
              "Post",
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ]);
    });
  }
}
