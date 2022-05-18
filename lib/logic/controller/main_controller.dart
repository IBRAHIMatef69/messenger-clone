import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:store_user/model/user_model.dart';
import '../../api_services/firestore_methods.dart';
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
  RxBool internetStatus = true.obs;
  Connectivity _connectivity = Connectivity();
  late StreamSubscription _streamSubscription;

  // void checkConnectivity() async {
  //   var connectionResult = await _connectivity.checkConnectivity();
  //
  //   if (connectionResult == ConnectivityResult.mobile) {
  //     internetStatus = "MobileData";
  //   } else if (connectionResult == ConnectivityResult.wifi) {
  //     internetStatus = "Wifi";
  //   } else {
  //     internetStatus = "Not Connected";
  //   }
  //
  // }

  void checkRealtimeConnection() {
    _streamSubscription = _connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.mobile) {
        internetStatus.value = true;
      } else if (event == ConnectivityResult.wifi) {
        internetStatus.value = true;
      } else if (event == ConnectivityResult.none) {
        internetStatus.value = false;
      } else {
        internetStatus.value = false;
      }
    });
  }

  @override
  void onInit() async {
    await GetStorage.init();
    getUserData();
    getAllUsers();
    checkRealtimeConnection();

    super.onInit();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

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
