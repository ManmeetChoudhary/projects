import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';

class UsernameDialog {
  static Future<String> getUsername(
    //dunno might reuse it
    BuildContext context,
  ) async {
    final value = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String _username;
        final User _user = Provider.of<User>(context);
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                //can change to validate if you want
                decoration: new InputDecoration(hintText: "Enter Username"),
                initialValue: (_user != null)
                    ? _user.displayName ?? 'Anonymous'
                    : 'Anonymous', //todo:try to rewrite this..
                onChanged: (text) {
                  _username = text;
                },
              ),
              FlatButton(
                child: Text(FlutterI18n.translate(context, "login.pickimage")),
                onPressed: () {
                  Navigator.of(context).pop(_username);
                  Scaffold.of(context).showSnackBar(SnackBar(
                    duration: Duration(seconds: 2),
                    content: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(FlutterI18n.translate(
                              context, "login.loggedanon"))
                        ]),
                  ));
                },
              )
            ],
          ),
        );
      },
    );
    return (value != null) ? value : 'Anonymous';
  }
}
