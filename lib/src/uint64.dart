import 'dart:typed_data';

import 'uint32.dart';

class Uint64 {
  Uint8List _bytes = Uint8List(8);

  Uint64(int value) {
    _bytes[0] = value & 0xFF;
    _bytes[1] = (value >> 8) & 0xFF;
    _bytes[2] = (value >> 16) & 0xFF;
    _bytes[3] = (value >> 24) & 0xFF;
    _bytes[4] = (value >> 32) & 0xFF;
    _bytes[5] = (value >> 40) & 0xFF;
    _bytes[6] = (value >> 48) & 0xFF;
    _bytes[7] = (value >> 56) & 0xFF;
  }

  int getValue() {
    return _bytes[0] |
        (_bytes[1] << 8) |
        (_bytes[2] << 16) |
        (_bytes[3] << 24) |
        (_bytes[4] << 32) |
        (_bytes[5] << 40) |
        (_bytes[6] << 48) |
        (_bytes[7] << 56);
  }

  Uint64.fromBytes(Uint8List bytes) {
    _bytes = Uint8List.fromList(bytes);
  }

  Uint64 operator >>(int n) {
    Uint64 result = Uint64(0);
    for (int i = 0; i < 8; i++) {
      result._bytes[i] = _bytes[i] >> n;
    }
    return result;
  }

  Uint64 operator <<(int n) {
    Uint64 result = Uint64(0);
    for (int i = 0; i < 8; i++) {
      result._bytes[i] = _bytes[i] << n;
    }
    return result;
  }

  Uint64 operator &(Uint64 other) {
    Uint64 result = Uint64(0);
    for (int i = 0; i < 8; i++) {
      result._bytes[i] = _bytes[i] & other._bytes[i];
    }
    return result;
  }

  Uint64 operator |(Uint64 other) {
    Uint64 result = Uint64(0);
    for (int i = 0; i < 8; i++) {
      result._bytes[i] = _bytes[i] | other._bytes[i];
    }
    return result;
  }

  Uint64 operator ^(Uint64 other) {
    Uint64 result = Uint64(0);
    for (int i = 0; i < 8; i++) {
      result._bytes[i] = _bytes[i] ^ other._bytes[i];
    }
    return result;
  }

  Uint64 operator ~() {
    Uint64 result = Uint64(0);
    for (int i = 0; i < 8; i++) {
      result._bytes[i] = ~_bytes[i];
    }
    return result;
  }

  Uint64 operator +(Uint64 other) {
    Uint64 result = Uint64(0);
    int carry = 0;
    for (int i = 0; i < 8; i++) {
      int sum = _bytes[i] + other._bytes[i] + carry;
      result._bytes[i] = sum & 0xFF;
      carry = sum >> 8;
    }
    return result;
  }

  Uint64 operator -(Uint64 other) {
    Uint64 result = Uint64(0);
    int carry = 0;
    for (int i = 0; i < 8; i++) {
      int sum = _bytes[i] - other._bytes[i] - carry;
      result._bytes[i] = sum & 0xFF;
      carry = sum >> 8;
    }
    return result;
  }

  Uint64 rotateRight(int n) {
    Uint64 result = Uint64(0);
    for (int i = 0; i < 8; i++) {
      result._bytes[i] = _bytes[(i + n) % 8];
    }
    return result;
  }

  Uint32 castUint32() {
    return Uint32(
        _bytes[0] | (_bytes[1] << 8) | (_bytes[2] << 16) | (_bytes[3] << 24));
  }
}
