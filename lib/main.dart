import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:blinkgameno/start.dart';
import 'package:blinkgameno/webview.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  final client = HttpClient();
  final containerIdentifier = 'iCloud.GameDetectObstacles';
  final apiToken =
      '120915fc9a23e3687797af38acce303ecc1bf61e48ada91468736abd67e38ce9';
  final environment = 'development'; // Hoặc 'production'
  final baseUrl = 'https://api.apple-cloudkit.com/database/1';
  late String _link;

  Future<void> getDataFromCloudKit() async {
    try {
      // Xây dựng URL cho yêu cầu lấy bản ghi
      final queryUrl =
          '$baseUrl/$containerIdentifier/$environment/public/records/query?ckAPIToken=$apiToken';

      // Tạo yêu cầu HTTP POST
      final request = await client.postUrl(Uri.parse(queryUrl));

      // Tạo truy vấn
      final query = {
        'query': {'recordType': 'get'}
      };

      request.write(json.encode(query));

      // Gửi yêu cầu và đợi phản hồi
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      // Kiểm tra mã trạng thái phản hồi
      if (response.statusCode == HttpStatus.ok) {
        // Phân tích phản hồi JSON
        Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
        final records = jsonResponse['records'];

        if (records != null && records.isNotEmpty) {
          final data = records[0]['fields'];
          final access = data['access']['value'];
          final url = data['url']['value'];

          print('Access: $access');
          print('URL: $url');

          if (access == "1") {
            // Chờ 1 giây rồi mở URL
            Future.delayed(Duration(seconds: 1), () {
              launch(url, forceSafariVC: false, forceWebView: false);
              setState(() {
                _link = url;
              });
            });
          } else if (access == "2") {
            // Mở URL bằng cửa sổ mặc định
            launch(url);
          } else if (access == "3") {
            // Chuyển đến màn hình WebView
            Future.delayed(Duration(seconds: 1), () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WebViewScreen(initialUrl: url)));
            });
          } else {
            // Trường hợp access không hợp lệ
            Future.delayed(Duration(seconds: 1), () {
              // Chuyển đến màn hình hướng dẫn
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InstructionScreen()));
            });
          }
        } else {
          // Không có bản ghi nào
          throw Exception('No records found');
        }
      } else {
        // Không thành công
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Xử lý lỗi
      print('Error: $e');

      // Chuyển đến màn hình hướng dẫn
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => InstructionScreen()));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    getDataFromCloudKit();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _link != null) {
      // Xử lý khi quay lại từ nền
      getDataFromCloudKit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/logo.png',
              fit: BoxFit.fill,
            ),
          ),
          // Loading circle ở dưới màn hình
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Catch Blink",
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.dark,
      ),
      home: SplashScreen(),
    );
  }
}
