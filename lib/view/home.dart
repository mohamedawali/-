

import 'dart:async';


import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran/cubit/quran_cubit.dart';
import 'package:quran/model/argument.dart';
import 'package:quran/constants/strings.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ConnectivityResult? _connectivityResult;
  var bloc;
  List<String> list = [];
  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<QuranCubit>(context);

    Connectivity().onConnectivityChanged.listen((result) {
      _connectivityResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      // WillPopScope(
      //   onWillPop: () async {
      //     Navigator.of(context).pop(true);
      //     return true;
      //   },
      Scaffold(
            appBar: AppBar(
              title: Text(
                'أئمة الحرم المكي ',
                style: TextStyle(color: Colors.white,fontSize: 22.sp),
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
            ),
            body: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 20, bottom: 20),
                child: GridView.builder(
                  itemCount: 8,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15),
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      checkInternet(index);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(image[index]), fit: BoxFit.fill),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 0,
                            right: 0,
                            left: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.5),
                                  borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(15),
                                      bottomLeft: Radius.circular(15))),
                              height: MediaQuery.of(context).size.height / 22,
                              child: Center(
                                child: Text(
                                  'فضيلةالشيخ/${shaikhName[index]}',
                                  textDirection: TextDirection.rtl,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal[900]),
                                ),
                              ),
                            ),
                            //  )
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ));
  }

  Future<void> checkInternet(int index, ) async {
    final ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {

list =    await   bloc.getAllSurah(id[index]);

      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/allSurah', arguments: ScreenArgument(
                list,   image[index],shaikhName[index]));

    } else {
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                title: Text(
                  '! حدث خطأ',
                  textAlign: TextAlign.end,
                ),
                content: Text(
                  'لايوجداتصال بالانترنت',
                  textAlign: TextAlign.end,
                ),
              ));
    }
    setState(() {
      _connectivityResult = connectivityResult;
    });
  }
}
