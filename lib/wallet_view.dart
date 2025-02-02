// wallet_view.dart

import 'package:flutter/material.dart';
import 'package:wallet_generate/web3_service.dart';

class WalletView extends StatefulWidget {
  const WalletView({super.key});

  @override
  WalletViewState createState() => WalletViewState();
}

class WalletViewState extends State<WalletView> {
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
        backgroundColor: Colors.black,
        title: const Text(
          'Web3 Wallet Generator',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _createWallet,
                child: const Text('Create Wallet'),
              ),
              const SizedBox(height: 20),
              if (walletAddress.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mnemonic:\n$mnemonic'),
                    const SizedBox(height: 8),
                    Text('Wallet Address:\n$walletAddress'),
                    const SizedBox(height: 8),
                    Text('Private Key:\n$privateKey'),
                    const SizedBox(height: 8),
                    Text('Public Key:\n$publicKey'),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
