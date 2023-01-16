import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _textController = TextEditingController();
  GlobalKey globalKey = GlobalKey();
  String qrText = "";
  String downloadText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Generator"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RepaintBoundary(
                  key: globalKey,
                  child: QrImage(
                    data: qrText,
                    size: 160.0,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Masukkan teks",
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _textController.clear();
                        });
                      },
                      child: Icon(Icons.close),
                    )
                  ),
                  controller: _textController,
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      qrText = _textController.text;
                      downloadText = "";
                    });
                    _saveQRText();
                  },
                  label: const Text("Generate"),
                  icon: const Icon(Icons.save),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _captureImageShareFirestorage();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green
                  ),
                  label: const Text("Generate & Simpan QR"),
                  icon: const Icon(Icons.save),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(downloadText),
              ]
            ),
          ),
        ),
      )
    );
  }

  Future<void> _saveQRText() async {
    await FirebaseFirestore.instance.collection('generate').doc('qrcode').set({
      'result': qrText
    });
  }
  
  Future<void> _captureImageShareFirestorage() async {
    try {
      RenderRepaintBoundary boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png) as ByteData;
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final ref = FirebaseStorage.instance.ref().child("qr/QR_${DateTime.now()}.png");
      final uploadTask = ref.putData(pngBytes);

      final snapshot = await uploadTask.whenComplete(() {});

      final urlDownload = await snapshot.ref.getDownloadURL();
      setState(() {
        downloadText = urlDownload;
      });
      print('Download QR image : $urlDownload');
    } catch (e) {
      print(e.toString());
    }
  }
}
