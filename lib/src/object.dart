import 'methods.dart';
import 'uint32.dart';
import 'uint64.dart';
import 'uint8.dart';

class Output {
  late Uint32List8 inputChainingValue;
  late Uint32List16 blockWords;
  late Uint64 counter;
  late Uint32 blockLen;
  late Uint32 flags;

  Output(this.inputChainingValue, this.blockWords, this.counter, this.blockLen,
      this.flags);

  Uint32List8 chainingValue() {
    return compress(
      inputChainingValue,
      blockWords,
      counter,
      blockLen,
      flags,
    ).first8Words();
  }

  void root_output_bytes(List<Uint8> other) {
        var outputBlockCounter = 0;
        for (var i = 0; i < other.length; i += 2 * OUT_LEN.getValue()) {
          var words = compress(
                inputChainingValue,
                blockWords,
                Uint64(outputBlockCounter),
                blockLen,
                flags | ROOT,
            );
          var next = i + 2 * OUT_LEN.getValue();
          var block = other.sublist(i, next > other.length ? other.length : next);
          var cur = 0;
          for (var j = 0; j < 2 * OUT_LEN.getValue(); j++) {
            
          }
        }
        for out_block in other.chunks_mut(2 * OUT_LEN) {
            
            // The output length might not be a multiple of 4.
            for (word, out_word) in words.iter().zip(out_block.chunks_mut(4)) {
                out_word.copy_from_slice(&word.to_le_bytes()[..out_word.len()]);
            }
            output_block_counter += 1;
        }
    }
}
