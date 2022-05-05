import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:store_user/model/user_model.dart';

import '../../firebase_services/firestore_methods.dart';
import '../../utils/my_string.dart';

class MainController extends GetxController {
  TextEditingController searchTextController = TextEditingController();

  ////////////////////myUser data//////////////////////
  final userInfoModel = Rxn<UserModel>();
  GetStorage authBox = GetStorage();

  /////////////////////////
  var allUsersList = <UserModel>[].obs;
  var searchList = <UserModel>[].obs;
  RxBool isSearching = false.obs;

  @override
  void onInit() async {
    await GetStorage.init();
    getUserData();
    getAllUsers();
    super.onInit();
  }

  // @override
  // void dispose(){
  //   searchTextController.dispose();
  //   searchTextController.clear();
  //   super.dispose();
  // }


  getUserData() async {
    await FireStoreMethods()
        .users
        .doc(authBox.read(KUid))
        .snapshots()
        .listen((event) {
      //userInfoModel.value = null;
      userInfoModel.value = UserModel.fromMap(event);
      //  update();
    });
  }

  getAllUsers() async {
    await FireStoreMethods().users.snapshots().listen((event) {
      allUsersList.clear();
      for (int i = 0; i < event.docs.length; i++) {
        allUsersList.add(UserModel.fromMap(event.docs[i]));
      }
    });
  }

  void addSearchToList(String searchName) {
    searchName = searchName.toLowerCase();
    searchList.value = allUsersList.where((search) {
      var searchTitle = search.displayName!.toLowerCase();

      return searchTitle.contains(searchName);
    }).toList();
    //print(searchList[0].displayName);
    if (searchTextController.text.isEmpty) {
      isSearching.value = false;
    } else {
      isSearching.value = true;
    }
    update();
  }

  void clearSearch() {
     searchList.clear();
    searchTextController.clear();

    isSearching.value = false;

    update();
  }
}
