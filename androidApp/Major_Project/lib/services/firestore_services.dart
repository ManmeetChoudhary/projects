import 'dart:async';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:major_project/models/chat_session_model.dart';
import 'package:major_project/models/chat_message_model.dart';
import 'package:major_project/models/live_chat_message_model.dart';
import 'package:major_project/models/live_chat_message_model.dart';
import 'package:major_project/models/live_chat_message_model.dart';
import 'package:major_project/models/profile_model.dart';
import 'package:major_project/models/markerpopup_model.dart';
import 'package:major_project/models/post_model.dart';
import 'package:major_project/services/location_service.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final geo = Geoflutterfire();
  final String postCollectionReference = 'posts';
  final String profileCollectionReference = 'profiles';
  final String chatSessionCollectionReference = 'chatSessions';
  final String profileChatsCollectionReference = 'userChatSessions';
  /* Stream<Post> streamPost(String id) {
    return _db
        .collection(postCollectionReference)
        .doc(id)
        .snapshots()
        .map((snap) => Post.fromFirestore(snap));
  }

  Stream<List<Post>> streamPosts() {
    var ref = _db.collection(postCollectionReference);

    return ref.snapshots().map((list) =>
        list.docs.map((doc) => Post.fromFirestore(doc)).toList());
  }*/
  Stream<List<Post>> streamPostsInRadius(
      {double radius, LocationData currentLocation}) {
    if (currentLocation == null) {
      return null;
    }
    GeoFirePoint center = geo.point(
        latitude: currentLocation.latitude,
        longitude: currentLocation.longitude);
    Stream<List<DistanceDocSnapshot>> streamSnaps;
    String field = 'position';
    var collectionReference = _db.collection('posts');
    streamSnaps = geo
        .collection(collectionRef: collectionReference)
        .within(center: center, radius: radius ?? 50, field: field);
    streamSnaps.map((list) => list.map(
          (doc) => print(doc),
        ));
    return streamSnaps.map((list) => list
        .map(
          (doc) => Post.fromFirestore(doc),
        )
        .toList());
  }

  //every method calling imgurl needs to check null
  //add post
  void addPost(
      {String username,
      String body,
      String userImgURL,
      String postImgURL,
      String uid,
      LatLng location,
      String type,
      String address}) {
    print("adding at location: " + location.toString());
    GeoFirePoint myLocation =
        geo.point(latitude: location.latitude, longitude: location.longitude);
    var id = _db.collection(postCollectionReference).doc().id;
    _db.collection(postCollectionReference).doc(id).set({
      "username": username ?? 'Anonymous',
      "body": body ?? '',
      "userImgURL": userImgURL,
      "postImgURL": postImgURL,
      "postedBy": uid ?? '',
      "postedDate": Timestamp.now() ?? 0,
      'name': id,
      "type": type,
      'position': myLocation.data,
      'addressName': address,
      'likes': <String>[],
    });
  }

  Future<List<Post>> getUserPosts(User user) async {
    List<Post> posts = [];
    var collectionReference = _db.collection('posts');
    collectionReference.get().then((snapshot) => {
          snapshot.docs.forEach((element) {
            posts.add(Post.fromFirebase(element));
          })
        });
    return posts;
  }

  Stream<List<Profile>> streamProfilesInRadius(
      {double radius, LocationData currentLocation}) {
    if (currentLocation == null) {
      return null;
    }
    GeoFirePoint center = geo.point(
        latitude: currentLocation.latitude,
        longitude: currentLocation.longitude);
    Stream<List<DistanceDocSnapshot>> streamSnaps;
    String field = 'position';
    var collectionReference = _db.collection('profiles');
    streamSnaps = geo
        .collection(collectionRef: collectionReference)
        .within(center: center, radius: radius ?? 50, field: field);
    return streamSnaps.map((list) => list
        .map(
          (doc) => Profile.fromFirestore(doc),
        )
        .toList());
  }

  //add profile
  Future<void> createProfile(
      {String uid, String username, String profileImgURL}) {
    print("creating profile with $username and $profileImgURL");
    return _db.collection(profileCollectionReference).doc(uid).set({
      "username": username ?? 'Anonymous',
      "profileImgURL": profileImgURL ?? 'http://placekitten.com/200/300',
    });
  }

  Future<void> updateProfileLocation({String uid, LocationData location}) {
    GeoFirePoint myLocation =
        geo.point(latitude: location.latitude, longitude: location.longitude);
    print("updated location to $location");
    return _db.collection(profileCollectionReference).doc(uid).set(
        {'name': 'random name', 'position': myLocation.data},
        SetOptions(merge: true));
  }

  //get profile
  /*Future<Profile> getProfile({String uid}) async {
    var snap = await _db.collection(profileCollectionReference)
        .doc(uid)
        .get();
    return Profile.fromFirestore(snap);
  }*/

  //update profile
  Future<void> updateProfileUsername({String uid, String username}) {
    return _db
        .collection(profileCollectionReference)
        .doc(uid)
        .set({"username": username ?? 'Anonymous'});
  }

  //every method calling imgurl needs to check null
  //update profile image
  Future<void> updateProfileImage({String uid, String profileImgURL}) {
    return _db.collection(profileCollectionReference).doc(uid).set(
        {"profileImgURL": profileImgURL ?? 'http://placekitten.com/200/300'});
  }

  //chat services
  //stream chat sessions of user, listen to this to get new chats
  Stream<List<ChatSession>> streamChatSessions(String uid) {
    var ref = _db
        .collection(profileCollectionReference)
        .doc(uid)
        .collection(profileChatsCollectionReference);
    return ref.snapshots().map((list) =>
        list.docs.map((doc) => ChatSession.fromFirestore(doc)).toList());
  } //todo: put list of chatsessions in profile and in local storage

  //sessionids are always uid+uid, cache these locally
  Future<String> guessChatSessionId(
      String uid1,
      String uid2,
      String user1ImageURL,
      String user2ImageURL,
      String user1Username,
      String user2Username) async {
    var doc = await _db
        .collection(chatSessionCollectionReference)
        .doc(uid1 + uid2)
        .get();
    if (doc.exists) {
      return uid1 + uid2;
    } else {
      doc = await _db
          .collection(chatSessionCollectionReference)
          .doc(uid2 + uid1)
          .get();
      if (doc.exists) {
        return uid2 + uid1;
      }
      print('failed to get chat session');
      return createChatSession(uid1, uid2, user1ImageURL, user2ImageURL,
          user1Username, user2Username);
    }
  }

  //returns session id, set for both users as well
  String createChatSession(String uid1, String uid2, String user1ImageURL,
      String user2ImageURL, String user1Username, String user2Username) {
    _db.collection(chatSessionCollectionReference).doc(uid1 + uid2).set({
      "sessionId": uid1 + uid2,
      "user1": uid1,
      "user2": uid2,
    });
    _db
        .collection(profileCollectionReference)
        .doc(uid1)
        .collection(profileChatsCollectionReference)
        .doc(uid1 + uid2)
        .set({
      "sessionId": uid1 + uid2,
      "peer": uid2,
      "peerUsername": user2Username,
      "peerProfileImageURL": user2ImageURL,
    });
    _db
        .collection(profileCollectionReference)
        .doc(uid2)
        .collection(profileChatsCollectionReference)
        .doc(uid1 + uid2)
        .set({
      "sessionId": uid1 + uid2,
      "peer": uid1,
      "peerUsername": user1Username,
      "peerProfileImageURL": user1ImageURL,
    });
    return uid1 + uid2;
  }

  //stream messages
  Stream<List<ChatMessage>> streamChatMessages(
      String sessionId, String userId) {
    var ref = _db
        .collection(chatSessionCollectionReference)
        .doc(sessionId)
        .collection('messages');

    return ref.snapshots().map((list) => list.docs
        .map((doc) => ChatMessage.fromFirestore(doc, userId))
        .toList());
  }

  pushMessage({String sessionId, User user, bool isImage, String body}) {
    _db
        .collection(chatSessionCollectionReference)
        .doc(sessionId)
        .collection('messages')
        .add({
      "userId": user.uid ?? '',
      "username": user.displayName ?? '',
      "body": body ?? '',
      "userImgURL": user.photoURL ?? 'http://placekitten.com/200/300',
      "foreignUser": false,
      "isImage": isImage ?? false,
      "createdDate": Timestamp.now() ?? 0,
    });
  }
  //livechat

  pushLiveChatMessage({String text, DateTime dateTime, Position position}) {
    GeoFirePoint myLocation =
        geo.point(latitude: position.latitude, longitude: position.longitude);
    var id = _db.collection('livechatmessages').doc().id;
    _db.collection('livechatmessages').doc(id).set({
      "text": text ?? 'Anonymous',
      "time": dateTime.toString() ?? '',
      'position': myLocation.data,
    });
  }

  Stream<List<LiveChatMessage>> streamLiveChatMessages(
      {double radius, LocationData currentLocation}) {
    if (currentLocation == null) {
      return null;
    }
    GeoFirePoint center = geo.point(
        latitude: currentLocation.latitude,
        longitude: currentLocation.longitude);
    Stream<List<DistanceDocSnapshot>> streamSnaps;
    String field = 'position';
    var collectionReference = _db.collection('livechatmessages');
    streamSnaps = geo
        .collection(collectionRef: collectionReference)
        .within(center: center, radius: radius ?? 50, field: field);
    return streamSnaps.map((list) => list
        .map(
          (doc) => LiveChatMessage.fromFirestore(doc),
        )
        .toList());
  }
}
