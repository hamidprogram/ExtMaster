import 'package:flutter/material.dart';
import 'package:extmaster/style/colors.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'dart:html' as html;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'New Tab - ExtMaster',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: AppColors.backgroungColor),
      home: homePage(),
    );
  }
}

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  String _searchText = "";
  late TextEditingController _searchController;
  late StateMachineController _controller;
  SMITrigger? _fail;
  SMITrigger? _success;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 300,
                  width: 300,
                  child: RiveAnimation.asset(
                    'assets/smoknoback.riv', // Path of animation file
                    fit: BoxFit.contain,
                    onInit:
                        _onRiveInit, // For load the animation and when the page is start this function run
                  ),
                ),
                Container(
                  width: 600,
                  child: TextField(
                    cursorColor: AppColors.primaryColor,
                    style: const TextStyle(color: AppColors.white),
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(color: AppColors.white),
                      fillColor: AppColors.seconderyColor,
                      filled: true,
                      hintText: "Search",
                      prefixIcon: InkWell(
                          onTap: () => serchGoogle(
                              _searchText), // When click on serch icon go to run the serchGoogle function
                          child:
                              const Icon(Icons.search, color: AppColors.white)),
                      suffixIcon: _searchController.text.isEmpty
                          ? null
                          : InkWell(
                              onTap: () => _searchController
                                  .clear(), // For clear text fild when user was click the clear icon
                              child: const Icon(Icons.clear,
                                  color: AppColors.primaryColor),
                            ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                    ),
                    onSubmitted: (Value) => serchGoogle(
                        _searchText), // When press enter key go to run the serchGoogle function
                  ),
                ),
                const SizedBox(
                  height: 200,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  } // For reset _searchController

  void _onRiveInit(Artboard artboard) {
    _controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
    )!; // Load state machine in rive file
    artboard.addController(
        _controller); // Add _controller to artboard for control the animation
    _fail = _controller.findInput<bool>('fail')
        as SMITrigger; // Find faild animation in state machin
    _success = _controller.findInput<bool>('success')
        as SMITrigger; // Find faild animation in state machin
  }

  void _hitSuccess() => _success?.fire(); // !animation
  void _hitFail() => _fail?.fire(); // Happy animation

  // Serch the word or line in google
  serchGoogle(String serchKey) async {
    if ((serchKey == "pornhub.com") || (serchKey == "pornhub")) {
      _hitFail(); // Play ! animation
      await Future.delayed(
          const Duration(seconds: 1), () {}); // Code for wait play animation
      // ignore: prefer_interpolation_to_compose_strings
      String url = "https://www.google.com/search?q=" +
          serchKey +
          "&oq=" +
          serchKey; // Make URL for serch
      html.window.open(url, "_self"); // Open link in tab
    } else {
      _hitSuccess(); // Play hapy animation
      await Future.delayed(
          const Duration(seconds: 1), () {}); // Code for wait play animation
      // ignore: prefer_interpolation_to_compose_strings
      String url = "https://www.google.com/search?q=" +
          serchKey +
          "&oq=" +
          serchKey; // Make URL for serch
      html.window.open(url, "_self"); // Open link in tab
    }
  }
}
