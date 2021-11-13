import 'package:cryptography/cryptography.dart';

class VBox {
  late List<int> key;

  VBox(this.key);

  static Future<VBox> from(List<int> key) async {
    var hashedKey = await Blake2s().hash(key);
    var box = VBox(hashedKey.bytes);

    var chacha = Chacha20.poly1305Aead();
    var chachaSecretKey = chacha.newSecretKeyFromBytes(box.key.sublist(0, 32));

    return box;
  }
}
