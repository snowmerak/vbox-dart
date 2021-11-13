import 'dart:typed_data';

class Uint8 {
  final Uint8List _value = Uint8List(1);

  Uint8(int value) {
    _value[0] = value;
  }

  int get(int index) => _value[index];

  void set(int value) {
    _value[0] = value & 0xFF;
  }
}
