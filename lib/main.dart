import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pag/pag.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PAGViewer',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'PAGViewer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController urlController = TextEditingController();

  String? previewAssetName;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenWidth = size.width;
    const double demoItemMargin = 10;
    const double marginLeftRight = 20;
    double demoItemSize = (screenWidth - marginLeftRight * 2 - demoItemMargin * 2) / 3;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Stack(
            children: [
              Container(
                color: Colors.black87,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  child: SizedBox(
                    height: size.height,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: marginLeftRight, right: marginLeftRight, top: 20, bottom: 20),
                      child: ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        // shrinkWrap: true,
                        children: <Widget>[
                          const Text(
                            'PAG file url:',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          TextField(
                            controller: urlController,
                            decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Please enter the pag file url you want to preview",
                                hintStyle: TextStyle(fontSize: 12, color: Colors.black12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                )),
                            keyboardType: TextInputType.url,
                            maxLines: 5,
                            keyboardAppearance: Brightness.dark,
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 60,
                            height: 40,
                            child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    if (urlController.text != "" && urlController.text.startsWith("http")) {
                                      FocusScope.of(context).requestFocus(FocusNode());
                                      setState(() {
                                        previewAssetName = urlController.text;
                                      });
                                    }
                                  });
                                },
                                child: const Text("Open",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black))),
                          ),
                          const SizedBox(height: 20),
                          const Divider(color: Colors.black54),
                          const SizedBox(height: 20),
                          const Text(
                            'PAG Demos',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildItem(11, demoItemSize),
                              _buildItem(12, demoItemSize),
                              _buildItem(17, demoItemSize),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildItem(14, demoItemSize),
                              _buildItem(15, demoItemSize),
                              _buildItem(8, demoItemSize),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildItem(0, demoItemSize),
                              _buildItem(6, demoItemSize),
                              _buildItem(16, demoItemSize),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              previewAssetName == null
                  ? const SizedBox.shrink()
                  : Positioned(
                      child: GestureDetector(
                      onTap: () {
                        setState(() {
                          previewAssetName = null;
                        });
                      },
                      child: Container(
                        color: Colors.transparent,
                        width: size.width,
                        height: size.height,
                        alignment: Alignment.center,
                        child: previewAssetName!.startsWith("http")
                            ? PAGView.network(previewAssetName,
                                width: size.width,
                                height: size.width,
                                autoPlay: true,
                                repeatCount: PAGView.REPEAT_COUNT_LOOP)
                            : PAGView.asset(previewAssetName,
                                width: size.width,
                                height: size.width,
                                autoPlay: true,
                                repeatCount: PAGView.REPEAT_COUNT_LOOP),
                      ),
                    ))
            ],
          ),
        ));
  }

  Widget _buildItem(idx, double size) {
    return GestureDetector(
      onTap: () {
        setState(() {
          previewAssetName = "assets/$idx.pag";
        });
      },
      child: Container(
        width: size,
        height: size,
        color: Colors.black87,
        child: Image.asset("assets/$idx.png"),
      ),
    );
  }
}
