import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class Content extends StatefulWidget {
  final int id;

  const Content({Key? key, required this.id}) : super(key: key);

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  List<Map<String, String>> responseData = [];
  List<List<Map<String, String>>> secondResponseData = [];
  int selectedIndex = 0;
  bool isSpeaking = false;
  final _flutterTts = FlutterTts();

  void initializeTts() {
    _flutterTts.setStartHandler(() {
      setState(() {
        isSpeaking = true;
      });
    });
    _flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });
    _flutterTts.setErrorHandler((message) {
      setState(() {
        isSpeaking = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    initializeTts();
  }

  void speak() async {
    if (secondResponseData.isNotEmpty) {
      await _flutterTts.speak(secondResponseData.toString());
    }
  }

  void stop() async {
    await _flutterTts.stop();
    setState(() {
      isSpeaking = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _flutterTts.stop();
  }

  Future<void> fetchData() async {
    try {
      final firstUri = Uri.parse(
          'https://jobportal.techallylabs.com/api/v1/life-coach/top-nav/${widget.id}');
      final firstResponse = await http.get(firstUri);

      if (firstResponse.statusCode == 200) {
        final decodedData = jsonDecode(firstResponse.body) as List<dynamic>;
        final dataList = decodedData.map((data) {
          final name = data['name'].toString();
          final id = data['id'].toString();
          return {'name': name, 'id': id};
        }).toList();
        setState(() {
          responseData = dataList;
        });
      }

      final secondResponseList = await Future.wait(responseData.map((data) {
        final secondUri = Uri.parse(
            'https://jobportal.techallylabs.com/api/v1/life-coach/types/${data['id']}');
        return http.get(secondUri).then((secondResponse) {
          if (secondResponse.statusCode == 200) {
            final decodedData =
                jsonDecode(secondResponse.body) as List<dynamic>;
            final dataList = decodedData.map((data) {
              final name = data['name'].toString();
              final content = data['content'].toString();
              return {'name': name, 'content': content};
            }).toList();
            return dataList;
          }
          return [];
        });
      }));

      setState(() {
        secondResponseData =
            secondResponseList.cast<List<Map<String, String>>>();
      });
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: responseData.isEmpty
          ? const Center(
              child: Text('No data available'),
            )
          : DefaultTabController(
              length: responseData.length,
              child: Column(
                children: [
                  TabBar(
                    isScrollable: true,
                    tabs: responseData
                        .map(
                          (data) => Tab(
                            child: Container(
                              alignment: Alignment.center,
                              constraints: const BoxConstraints.expand(
                                width: 150,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE6ECF9),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Text(
                                data['name'] ?? " ",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF265DD1),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onTap: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  ),
                  Expanded(
                    child: TabBarView(
                      children: secondResponseData.isNotEmpty
                          ? [
                              for (final secondResponse in secondResponseData)
                                SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      for (final response in secondResponse)
                                        Column(
                                          children: [
                                            const SizedBox(height: 20),
                                            Center(
                                              child: Text(
                                                response['name'] ?? '',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            HtmlWidget(
                                              response['content'] ?? '',
                                              webView: true,
                                            ),
                                            ElevatedButton(
                                                onPressed: () {
                                                  isSpeaking ? stop() : speak();
                                                },
                                                child: Text(isSpeaking
                                                    ? "Stop"
                                                    : "Speak"))
                                          ],
                                        ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                            ]
                          : [
                              const Center(
                                child: Text('No data available'),
                              ),
                            ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
