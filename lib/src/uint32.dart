import 'dart:typed_data';

class Uint32 {
  Uint8List _bytes = Uint8List(4);

  Uint32(int n) {
    _bytes[0] = n & 0xff;
    _bytes[1] = (n >> 8) & 0xff;
    _bytes[2] = (n >> 16) & 0xff;
    _bytes[3] = (n >> 24) & 0xff;
  }

  int getValue() {
    return _bytes[0] | (_bytes[1] << 8) | (_bytes[2] << 16) | (_bytes[3] << 24);
  }

  Uint32.fromBytes(Uint8List bytes) {
    _bytes = Uint8List.fromList(bytes);
  }

  Uint32 operator <<(int n) {
    var result = Uint32(0);
    for (var i = 0; i < 4; i++) {
      if (i <= 4) {
        if (i + n < 4) {
          result._bytes[i + n] = _bytes[i];
        }
        result._bytes[i] = 0;
      }
      result._bytes[i] = _bytes[(i + n) % 4];
    }
    return result;
  }

  Uint32 operator >>(int n) {
    var result = Uint32(0);
    for (var i = 0; i < 4; i++) {
      if (i >= 4) {
        if (i - n >= 0) {
          result._bytes[i - n] = _bytes[i];
        }
        result._bytes[i] = 0;
      }
      result._bytes[i] = _bytes[(i - n) % 4];
    }
    return result;
  }

  Uint32 operator &(Uint32 other) {
    var result = Uint32(0);
    for (var i = 0; i < 4; i++) {
      result._bytes[i] = _bytes[i] & other._bytes[i];
    }
    return result;
  }

  Uint32 operator |(Uint32 other) {
    var result = Uint32(0);
    for (var i = 0; i < 4; i++) {
      result._bytes[i] = _bytes[i] | other._bytes[i];
    }
    return result;
  }

  Uint32 operator ^(Uint32 other) {
    var result = Uint32(0);
    for (var i = 0; i < 4; i++) {
      result._bytes[i] = _bytes[i] ^ other._bytes[i];
    }
    return result;
  }

  Uint32 operator ~() {
    var result = Uint32(0);
    for (var i = 0; i < 4; i++) {
      result._bytes[i] = ~_bytes[i];
    }
    return result;
  }

  Uint32 operator +(Uint32 other) {
    var result = Uint32(0);
    var carry = 0;
    for (var i = 0; i < 4; i++) {
      var sum = _bytes[i] + other._bytes[i] + carry;
      result._bytes[i] = sum & 0xff;
      carry = sum >> 8;
    }
    return result;
  }

  Uint32 operator -(Uint32 other) {
    var result = Uint32(0);
    var carry = 0;
    for (var i = 0; i < 4; i++) {
      var sum = _bytes[i] - other._bytes[i] - carry;
      result._bytes[i] = sum & 0xff;
      carry = sum >> 8;
    }
    return result;
  }

  Uint32 rotateRight(int n) {
    var result = Uint32(0);
    for (var i = 0; i < 4; i++) {
      if (i + n < 4) {
        result._bytes[i + n] = _bytes[i];
      }
      result._bytes[i] = _bytes[(i + n) % 4];
    }
    return result;
  }
}

class Uint32List8 {
  late List<Uint32> _list;

  Uint32List8(List<Uint32> list) {
    _list = <Uint32>[];
    for (var i = 0; i < 8 || i < list.length; i++) {
      _list.add(list[i]);
    }
    for (var i = list.length; i < 8; i++) {
      _list.add(Uint32(0));
    }
  }

  Uint32 operator [](int index) {
    return _list[index];
  }

  void operator []=(int index, Uint32 value) {
    _list[index] = value;
  }
}

class Uint32List16 {
  late List<Uint32> _list;

  Uint32List16(List<Uint32> list) {
    _list = <Uint32>[];
    for (var i = 0; i < 16 || i < list.length; i++) {
      _list.add(list[i]);
    }
    for (var i = list.length; i < 16; i++) {
      _list.add(Uint32(0));
    }
  }

  Uint32 operator [](int index) {
    return _list[index];
  }

  void operator []=(int index, Uint32 value) {
    _list[index] = value;
  }

  Uint32List8 first8Words() {
    return Uint32List8(_list.sublist(0, 8));
  }
}
