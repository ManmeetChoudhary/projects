import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:major_project/models/post_model.dart';
import 'package:major_project/services/firestore_services.dart';
import 'package:provider/provider.dart';

class AddPostPopup extends StatefulWidget {
  @override
  _AddPostPopupState createState() => _AddPostPopupState();
}

class _AddPostPopupState extends State<AddPostPopup> {
  String _text;
  String _location;
  String _image;
  final _db = FirebaseService();

  @override
  Widget build(BuildContext context) {
    var _user;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 20,
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      child: Container(
        // 80% width of screen
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // box for post text
            Container(
              padding: EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 4),
              child: TextFormField(
                // bigger to indicate more text is allowed
                minLines: 5,
                maxLines: 10,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: "Check In",
                  hintText: 'What are you up to?',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  // border animates when in focus
                  // looks good!
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(1.0)),
                    borderSide:
                        BorderSide(color: Theme.of(context).accentColor),
                  ),
                ),
                onChanged: (String value) {
                  setState(() {
                    _text = value;
                  });
                },
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 4, left: 8, right: 8, bottom: 4),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Location",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(1.0)),
                      borderSide:
                          BorderSide(color: Theme.of(context).accentColor),
                    ),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      _location = value;
                    });
                  },
                )),
            Container(
                padding: EdgeInsets.only(top: 4, left: 8, right: 8, bottom: 4),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Image",
                    //TODO: pick image from device
                    hintText: "URL of image",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(1.0)),
                      borderSide:
                          BorderSide(color: Theme.of(context).accentColor),
                    ),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      _image = value;
                    });
                  },
                )),
            Container(
              padding: EdgeInsets.only(top: 4, bottom: 8),
              child: RaisedButton(
                  child: Text('Check In'),
                  onPressed: () {
                    _user = Provider.of<User>(context);
                    _db.addPost(
                        username: _user.username,
                        body: _text ?? '',
                        userImgURL: User ?? 'null',
                        postImgURL: _image ?? null,
                        uid: _user.uid,
                        location: _location ?? 0);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
