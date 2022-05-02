import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:store_user/logic/controller/main_controller.dart';
import 'package:store_user/utils/constants.dart';

class SearchWidget extends StatelessWidget {
  final controller = Get.put(MainController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * .03),
      child: Obx(
        () {
          return Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 8),
              width: double.infinity,
              height: Get.height * .06,
              decoration: BoxDecoration(
                  color: grey.withOpacity(.25),
                  borderRadius: BorderRadius.circular(20)),
              child: TextField(
                controller: controller.searchTextController,
                onChanged: (value) {
                  if (value != "") {
                    controller.addSearchToList(value);
                  } else if(value=="") {
                    controller.clearSearch();
                  }
                },
                cursorColor: Color(0xFF000000),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    suffixIcon: controller.isSearching.value == false
                        ? Text("")
                        : IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              controller.clearSearch();
                            },
                          ),
                    prefixIcon: IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.black87,
                      ),
                      onPressed: () {
                        // if (
                        // // controller.textEditingController.text != "") {
                        // //   controller.onSearchBtnClick();
                        // }
                      },
                    ),
                    hintText: "Search..",
                    hintStyle: TextStyle(
                      fontSize: 15,
                    ),
                    border: InputBorder.none),
              ));
        },
      ),
    );
  }
}
