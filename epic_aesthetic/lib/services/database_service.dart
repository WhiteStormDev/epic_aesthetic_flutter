import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epic_aesthetic/model/image_model.dart';
import 'package:epic_aesthetic/model/user_model.dart';

class DatabaseService
{
  final CollectionReference userCollectionReference =
  FirebaseFirestore.instance.collection('users');
  final CollectionReference postCollectionReference =
  FirebaseFirestore.instance.collection('images');

  Future createUser(UserModel user) async {
    return await userCollectionReference
        .doc(user.id)
        .set(user.toMap());
  }

  Future createPost(ImageModel image) async {
    return await postCollectionReference
        .doc(image.id)
        .set(image.toMap());
  }

  Future<UserModel?> getUser(String? id) async {
    UserModel userFromDB;
    DocumentSnapshot snapshot = await userCollectionReference.doc(id).get();
    userFromDB = UserModel.fromJson(snapshot.data());
    return userFromDB;
  }

  Future<String?> getUserName(String? id) async {
    var userFromDB = await getUser(id);
    if (userFromDB != null) {
      return userFromDB.firstName;
    }
    return null;
  }

  Future<List<ImageModel>> getPosts() async {
    QuerySnapshot snapshot = await postCollectionReference.orderBy("timeStamp").get();
    return snapshot.docs
        .map((doc) => ImageModel.fromJson(doc.id, doc.data()))
        .toList();
  }
}