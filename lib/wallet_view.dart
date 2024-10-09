// wallet_view.dart

import 'package:flutter/material.dart';
import 'package:wallet_generate/web3_service.dart';

class WalletView extends StatefulWidget {
  const WalletView({Key? key}) : super(key: key);

  @override
  _WalletViewState createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> {
  final Web3Service _web3Service = Web3Service();
  String walletAddress = '';
  String privateKey = '';
  String publicKey = '';
  String mnemonic = '';
  String signedMessage = '';

  Future<void> _createWallet() async {
    final result = await _web3Service.createWallet();
    if (result[0]) {
      setState(() {
        mnemonic = result[1];
        privateKey = result[2];
        publicKey = result[3];
        walletAddress = result[4];
      });
    } else {
      _showError(result[1]);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Web3 Wallet Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _createWallet,
              child: Text('Create Wallet'),
            ),
            if (walletAddress.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mnemonic: $mnemonic'),
                  Text('Wallet Address: $walletAddress'),
                  Text('Private Key: $privateKey'),
                  Text('Public Key: $publicKey'),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
