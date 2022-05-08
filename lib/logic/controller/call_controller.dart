import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:store_user/model/call_model.dart';

import '../../utils/my_string.dart';

class CallController extends GetxController {
  GetStorage authBox = GetStorage();
  RxBool isComingCall = false.obs;
  final comingCall = Rxn<Call>();

  @override
  void onInit() async {
    await GetStorage.init();

    callStream();

    super.onInit();
  }

  CollectionReference callCollection =
      FirebaseFirestore.instance.collection(callsCollectionKey);

  callStream() async {
    isComingCall.value = false;

    await callCollection
        .doc(authBox.read(KUid))
        .snapshots()
        .listen((event) async {
      if (event.exists) {
        comingCall.value = Call.fromMap(event);
        isComingCall.value = true;
      } else {
        isComingCall.value = false;

      }
    });
  }
}
