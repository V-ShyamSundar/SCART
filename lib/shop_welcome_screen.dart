import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ShopWelcomeScreen extends StatefulWidget {
  final String shopName;

  const ShopWelcomeScreen({required this.shopName});

  @override
  _ShopWelcomeScreenState createState() => _ShopWelcomeScreenState();
}

class _ShopWelcomeScreenState extends State<ShopWelcomeScreen> {
  String _qrCodeContent = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to ${widget.shopName}'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 8.0),
            child: Text('Welcome to ${widget.shopName}'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _scanQRCode();
              },
              child: Text('Scan QR Code'),
            ),
            SizedBox(height: 20),
            Text(
              'Scanned QR Code Content:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              _qrCodeContent,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _scanQRCode();
        },
        child: Icon(Icons.qr_code),
      ),
    );
  }

  Future<void> _scanQRCode() async {
    String qrCodeContent = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666',
      'Cancel',
      true,
      ScanMode.QR,
    );

    setState(() {
      _qrCodeContent = qrCodeContent;
    });

    if (_qrCodeContent.isNotEmpty) {
      _showQRCodePopup(_qrCodeContent);
    }
  }

  void _showQRCodePopup(String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('QR Code Content'),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );

    // Dismiss the popup after 1 minute (for debugging purposes)
    Future.delayed(Duration(minutes: 1), () {
      Navigator.of(context).pop();
    });
  }
}
