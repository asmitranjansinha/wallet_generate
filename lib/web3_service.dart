// web3_service.dart
import 'package:bip32_bip44/dart_bip32_bip44.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';
import 'package:logging/logging.dart';

class Web3Service {
  static const String pathForPublicKey = "m/44'/60'/0'/0";
  static const String pathForPrivateKey = "m/44'/60'/0'/0/0";

  final Logger _logger = Logger('Web3Service');

  String mnemonic = "";
  String privateKey = "";
  String publicKey = "";
  String walletAddress = "";
  String message = "";

  Future<List<dynamic>> createWallet() async {
    try {
      // Generate Mnemonic
      mnemonic = bip39.generateMnemonic();

      // Generate Seed and Chain from Mnemonic
      final String seed = bip39.mnemonicToSeedHex(mnemonic);
      final Chain chain = Chain.seed(seed);

      // Get Private Key
      final ExtendedKey extendedKey = chain.forPath(pathForPrivateKey);
      privateKey = extendedKey.privateKeyHex();

      // Get Wallet Address from Private Key
      final EthPrivateKey ethPrivateKey = EthPrivateKey.fromHex(privateKey);
      final EthereumAddress ethereumAddress =
          await ethPrivateKey.extractAddress();

      // Get Public Key
      final ExtendedKey extendedKeyPublic = chain.forPath(pathForPublicKey);
      publicKey = extendedKeyPublic.publicKey().toString();

      walletAddress = ethereumAddress.hex;

      _logger.info("Wallet generated: $walletAddress");

      return [true, mnemonic, privateKey, publicKey, walletAddress];
    } catch (e) {
      _logger.severe("Error creating wallet: $e");
      return [false, e.toString()];
    }
  }
}
