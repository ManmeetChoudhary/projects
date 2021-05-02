import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:major_project/models/chat_session_model.dart';
import 'package:major_project/views/pages/chart_page/likes_table.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:major_project/models/settings_model.dart';

//todo
class ProfileDrawer extends StatelessWidget {
  String peerUID;
  String sessionId;
  String peerProfileImageURL;
  User _user;
  Settings _settings;
  @override
  Widget build(BuildContext context) {
    _user = context.watch<User>();
    _settings = context.watch<Settings>();
    if (_user != null) {
      return ListView(children: <Widget>[
        Text(_user.displayName),
        Container(
          padding: EdgeInsets.all(10),
          child: CircleAvatar(
              child: _user.photoURL != null && _user.photoURL != ""
                  ? SizedBox(
                      // width: iconSize,
                      // height: iconSize,
                      child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: _user.photoURL,
                        fit: BoxFit.fill,
                        errorWidget: (context, url, error) => _user
                                        .displayName !=
                                    null &&
                                _user.displayName != ""
                            ? Text(
                                '${_user.displayName.characters.first.toUpperCase()}')
                            : Text('?'),
                      ),
                    ))
                  : _user.displayName != null && _user.displayName != ""
                      ? Text(
                          '${_user.displayName.characters.first.toUpperCase()}')
                      : Text('?')),
        ),
        Container(
          height: 100,
          color: Colors.black45,
          child: InkWell(
              child: TextField(
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: FlutterI18n.translate(context, "drawer.aboutme")),
          )),
        ),
        InkWell(
          child: ExpansionTile(
              title: Text(FlutterI18n.translate(context, "drawer.settings")),
              children: [
                InkWell(
                  child: ExpansionTile(
                      title: Text(FlutterI18n.translate(context, "drawer.map")),
                      children: [
                        InkWell(
                          child: ListTile(
                            title: Text(
                                FlutterI18n.translate(context, "drawer.dark")),
                            onTap: () => {_settings.saveMapTheme("/dark.txt")},
                          ),
                        ),
                        InkWell(
                          child: ListTile(
                            title: Text(FlutterI18n.translate(
                                context, "drawer.forest")),
                            onTap: () =>
                                {_settings.saveMapTheme("/forest.txt")},
                          ),
                        ),
                        InkWell(
                          child: ListTile(
                            title: Text(
                                FlutterI18n.translate(context, "drawer.night")),
                            onTap: () =>
                                {_settings.saveMapTheme("/night.json")},
                          ),
                        ),
                        InkWell(
                          child: ListTile(
                            title: Text(
                                FlutterI18n.translate(context, "drawer.candy")),
                            onTap: () =>
                                {_settings.saveMapTheme("/candy.json")},
                          ),
                        ),
                      ]),
                ),
                InkWell(
                  child: ExpansionTile(
                      title:
                          Text(FlutterI18n.translate(context, "drawer.theme")),
                      children: [
                        InkWell(
                          child: ListTile(
                            title: Text(
                                FlutterI18n.translate(context, "drawer.blue")),
                            onTap: () => _settings.saveTheme('blueTheme'),
                          ),
                        ),
                        InkWell(
                          child: ListTile(
                            title: Text(
                                FlutterI18n.translate(context, "drawer.dark")),
                            onTap: () => _settings.saveTheme('darkTheme'),
                          ),
                        ),
                        InkWell(
                          child: ListTile(
                            title: Text(FlutterI18n.translate(
                                context, "drawer.sunset")),
                            onTap: () => _settings.saveTheme('sunsetTheme'),
                          ),
                        ),
                      ]),
                )
              ]),
        ),
        InkWell(
          child: ExpansionTile(
              title: Text(FlutterI18n.translate(context, "drawer.languages")),
              children: [
                InkWell(
                  child: ListTile(
                    title: Text(
                        FlutterI18n.translate(context, "languages.english")),
                    onTap: () async {
                      Locale newLocale = Locale('en');
                      await FlutterI18n.refresh(context, newLocale);
                    },
                  ),
                ),
              ]),
        ),
        Container(
          height: 70,
          color: Colors.blue,
          child: InkWell(
            child: ListTile(
              title: Text(FlutterI18n.translate(context, "drawer.analytics")),
              onTap: () => {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LikesTable(
                          user: _user,
                        )))
              },
            ),
          ),
        ),
        Container(
          height: 70,
          color: Colors.pink,
          child: InkWell(
            child: ListTile(
              title: Text(FlutterI18n.translate(context, "drawer.logout")),
              onTap: () => {FirebaseAuth.instance.signOut()},
            ),
          ),
        ),
        // Expanded(
        //   // add this
        //   child: Align(
        //     alignment: Alignment.bottomCenter,
        //     child: Container(color: Colors.black12),
        //   ),
        // ),
      ]);
    }
    return Center(
      child: Text(FlutterI18n.translate(context, "drawer.signin")),
    );
  }
}
