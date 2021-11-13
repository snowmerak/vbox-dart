import 'dart:typed_data';
import 'package:vbox_dart/src/uint32.dart';
import 'package:vbox_dart/src/uint64.dart';

var OUT_LEN = Uint64(32);
var KEY_LEN = Uint64(32);
var BLOCK_LEN = Uint64(64);
var CHUNK_LEN = Uint64(1024);

var CHUNK_START = Uint32(1 << 0);
var CHUNK_END = Uint32(1 << 1);
var PARENT = Uint32(1 << 2);
var ROOT = Uint32(1 << 3);
var KEYED_HASH = Uint32(1 << 4);
var DERIVE_KEY_CONTEXT = Uint32(1 << 5);
var DERIVE_KEY_MATERIAL = Uint32(1 << 6);

var IV = <Uint32>[
  Uint32(0x6A09E667),
  Uint32(0xBB67AE85),
  Uint32(0x3C6EF372),
  Uint32(0xA54FF53A),
  Uint32(0x510E527F),
  Uint32(0x9B05688C),
  Uint32(0x1F83D9AB),
  Uint32(0x5BE0CD19),
];

var MSG_PERMUTATION = <Uint32>[
  Uint32(2),
  Uint32(6),
  Uint32(3),
  Uint32(10),
  Uint32(7),
  Uint32(0),
  Uint32(4),
  Uint32(13),
  Uint32(1),
  Uint32(11),
  Uint32(12),
  Uint32(5),
  Uint32(9),
  Uint32(14),
  Uint32(15),
  Uint32(8)
];

Uint32List16 g(Uint32List16 state, Uint64 a, Uint64 b, Uint64 c, Uint64 d,
    Uint32 mx, Uint32 my) {
  state[a.getValue()] = state[a.getValue()] + state[b.getValue()] + mx;
  state[d.getValue()] =
      (state[d.getValue()] ^ state[a.getValue()]).rotateRight(16);
  state[c.getValue()] = state[c.getValue()] + state[d.getValue()];
  state[b.getValue()] =
      (state[b.getValue()] ^ state[c.getValue()]).rotateRight(12);
  state[a.getValue()] = state[a.getValue()] + state[b.getValue()] + my;
  state[d.getValue()] =
      (state[d.getValue()] ^ state[a.getValue()]).rotateRight(8);
  state[c.getValue()] = state[c.getValue()] + state[d.getValue()];
  state[b.getValue()] =
      (state[b.getValue()] ^ state[c.getValue()]).rotateRight(7);
  return state;
}

Uint32List16 round(Uint32List16 state, Uint32List16 m) {
  // Mix the columns.
  g(state, Uint64(0), Uint64(4), Uint64(8), Uint64(12), m[0], m[1]);
  g(state, Uint64(1), Uint64(5), Uint64(9), Uint64(13), m[2], m[3]);
  g(state, Uint64(2), Uint64(6), Uint64(10), Uint64(14), m[4], m[5]);
  g(state, Uint64(3), Uint64(7), Uint64(11), Uint64(15), m[6], m[7]);
  // Mix the diagonals.
  g(state, Uint64(0), Uint64(5), Uint64(10), Uint64(15), m[8], m[9]);
  g(state, Uint64(1), Uint64(6), Uint64(11), Uint64(12), m[10], m[11]);
  g(state, Uint64(2), Uint64(7), Uint64(8), Uint64(13), m[12], m[13]);
  g(state, Uint64(3), Uint64(4), Uint64(9), Uint64(14), m[14], m[15]);

  return state;
}

Uint32List16 permute(Uint32List16 m) {
  var permuted = Uint32List16([]);
  for (var i = 0; i < 16; i++) {
    permuted[i] = m[MSG_PERMUTATION[i].getValue()];
  }
  return permuted;
}

Uint32List16 compress(
  Uint32List8 chainingValue,
  Uint32List16 blockWords,
  Uint64 counter,
  Uint32 blockLen,
  Uint32 flags,
) {
  Uint32List16 state = Uint32List16([
    chainingValue[0],
    chainingValue[1],
    chainingValue[2],
    chainingValue[3],
    chainingValue[4],
    chainingValue[5],
    chainingValue[6],
    chainingValue[7],
    IV[0],
    IV[1],
    IV[2],
    IV[3],
    counter.castUint32(),
    (counter >> 32).castUint32(),
    blockLen,
    flags,
  ]);
  var block = Uint32List16([]);
  for (var i = 0; i < 16; i++) {
    block[i] = blockWords[i];
  }

  state = round(state, block); // round 1
  block = permute(block);
  state = round(state, block); // round 2
  block = permute(block);
  state = round(state, block); // round 3
  block = permute(block);
  state = round(state, block); // round 4
  block = permute(block);
  state = round(state, block); // round 5
  block = permute(block);
  state = round(state, block); // round 6
  block = permute(block);
  state = round(state, block); // round 7

  for (var i = 0; i < 8; i++) {
    state[i] ^= state[i + 8];
    state[i + 8] ^= chainingValue[i];
  }

  return state;
}
