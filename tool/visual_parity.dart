// Compares two visual capture roots produced by tool/visual/capture.mjs.
//
//   dart run tool/visual_parity.dart --baseline <root> --new <root> \
//       [--renderer wasm] [--pages id,id] [--threshold 0.5] [--tolerance 6] \
//       [--no-text-mask] [--side-by-side <dir>]
//
// Per image it reports the share of non-text pixels that differ. Text is
// masked using the <image>.text.json boxes written by the capture tool (union
// of baseline and new boxes). Area that exists in only one image (different
// page height or width) counts as differing. Exit code is 1 if any image
// exceeds the threshold or is missing, otherwise 0.
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

void main(List<String> argv) {
  final o = <String, String>{};
  for (var i = 0; i < argv.length; i++) {
    if (!argv[i].startsWith('--')) _die('unexpected argument ${argv[i]}');
    final k = argv[i].substring(2);
    final hasValue = i + 1 < argv.length && !argv[i + 1].startsWith('--');
    o[k] = hasValue ? argv[++i] : 'true';
  }
  if (o['baseline'] == null || o['new'] == null) {
    stderr.writeln(
      'usage: dart run tool/visual_parity.dart --baseline <root> --new <root> '
      '[--renderer wasm] [--pages a,b] [--threshold 0.5] [--tolerance 6] '
      '[--no-text-mask] [--side-by-side <dir>]',
    );
    exit(2);
  }
  final renderer = o['renderer'] ?? 'wasm';
  final threshold = double.parse(o['threshold'] ?? '0.5');
  final tolerance = int.parse(o['tolerance'] ?? '6');
  final useMask = o['no-text-mask'] != 'true';
  final pages = o['pages']?.split(',').toSet();
  final baseDir = _resolve(o['baseline']!, renderer);
  final newDir = _resolve(o['new']!, renderer);

  final names =
      baseDir
          .listSync()
          .whereType<File>()
          .map((f) => f.uri.pathSegments.last)
          .where((n) => n.endsWith('.png'))
          .where((n) => pages == null || pages.contains(n.split('.').first))
          .toList()
        ..sort();
  if (names.isEmpty) _die('no baseline images in ${baseDir.path}');

  var failed = 0;
  final rows = <String>[];
  for (final name in names) {
    final newFile = File('${newDir.path}/$name');
    if (!newFile.existsSync()) {
      failed++;
      rows.add('${_pad(name, 46)} MISSING in new');
      continue;
    }
    final a = _decodePng(File('${baseDir.path}/$name').readAsBytesSync());
    final b = _decodePng(newFile.readAsBytesSync());
    final w = a.width > b.width ? a.width : b.width;
    final h = a.height > b.height ? a.height : b.height;
    final mask = Uint8List(w * h);
    if (useMask) {
      for (final dir in [baseDir, newDir]) {
        _applyMask(
          mask,
          w,
          h,
          File('${dir.path}/${name.replaceFirst('.png', '.text.json')}'),
        );
      }
    }
    var masked = 0, diff = 0;
    for (var y = 0; y < h; y++) {
      for (var x = 0; x < w; x++) {
        if (mask[y * w + x] != 0) {
          masked++;
          continue;
        }
        final inA = x < a.width && y < a.height;
        final inB = x < b.width && y < b.height;
        if (inA != inB) {
          diff++;
        } else if (inA) {
          final ia = (y * a.width + x) * 4, ib = (y * b.width + x) * 4;
          for (var c = 0; c < 4; c++) {
            final d = a.rgba[ia + c] - b.rgba[ib + c];
            if (d > tolerance || d < -tolerance) {
              diff++;
              break;
            }
          }
        }
      }
    }
    final total = w * h - masked;
    final pct = total == 0 ? 0.0 : diff * 100 / total;
    final over = pct > threshold;
    if (over) failed++;
    final size = (a.width == b.width && a.height == b.height)
        ? ''
        : '  size ${a.width}x${a.height} -> ${b.width}x${b.height}';
    rows.add(
      '${_pad(name, 46)} ${pct.toStringAsFixed(3).padLeft(8)}%  '
      '(${diff}px of ${total}px non-text)${over ? '  EXCEEDS' : ''}$size',
    );
    final sbs = o['side-by-side'];
    if (sbs != null && (over || o['side-by-side-all'] == 'true')) {
      Directory(sbs).createSync(recursive: true);
      File('$sbs/$name').writeAsBytesSync(_sideBySide(a, b));
    }
  }
  final extra =
      newDir
          .listSync()
          .whereType<File>()
          .map((f) => f.uri.pathSegments.last)
          .where((n) => n.endsWith('.png') && !names.contains(n))
          .where((n) => pages == null || pages.contains(n.split('.').first))
          .toList()
        ..sort();
  rows.forEach(stdout.writeln);
  for (final e in extra) {
    stdout.writeln('${_pad(e, 46)} only in new (ignored)');
  }
  stdout.writeln(
    '\n${names.length} compared, $failed over threshold '
    '${threshold}% / missing (tolerance $tolerance, text mask '
    '${useMask ? 'on' : 'off'})',
  );
  exit(failed == 0 ? 0 : 1);
}

Directory _resolve(String root, String renderer) {
  final sub = Directory('$root/$renderer');
  final d = sub.existsSync() ? sub : Directory(root);
  if (!d.existsSync()) _die('no such directory: $root');
  return d;
}

Never _die(String m) {
  stderr.writeln(m);
  exit(2);
}

String _pad(String s, int n) => s.length >= n ? s : s + ' ' * (n - s.length);

void _applyMask(Uint8List mask, int w, int h, File f) {
  if (!f.existsSync()) return;
  for (final box in jsonDecode(f.readAsStringSync()) as List<dynamic>) {
    final b = (box as List<dynamic>).cast<num>();
    final x0 = b[0].toInt().clamp(0, w), y0 = b[1].toInt().clamp(0, h);
    final x1 = (b[0] + b[2]).ceil().clamp(0, w);
    final y1 = (b[1] + b[3]).ceil().clamp(0, h);
    for (var y = y0; y < y1; y++) {
      mask.fillRange(y * w + x0, y * w + x1, 1);
    }
  }
}

final class _Image {
  _Image(this.width, this.height, this.rgba);
  final int width, height;
  final Uint8List rgba;
}

_Image _decodePng(Uint8List d) {
  const sig = [137, 80, 78, 71, 13, 10, 26, 10];
  for (var i = 0; i < 8; i++) {
    if (d[i] != sig[i]) throw const FormatException('not a PNG');
  }
  final bd = ByteData.sublistView(d);
  var p = 8, w = 0, h = 0, depth = 0, ctype = 0, interlace = 0;
  final idat = BytesBuilder();
  while (p < d.length) {
    final len = bd.getUint32(p);
    final type = String.fromCharCodes(d.sublist(p + 4, p + 8));
    final data = d.sublist(p + 8, p + 8 + len);
    if (type == 'IHDR') {
      final hd = ByteData.sublistView(data);
      w = hd.getUint32(0);
      h = hd.getUint32(4);
      depth = data[8];
      ctype = data[9];
      interlace = data[12];
    } else if (type == 'IDAT') {
      idat.add(data);
    } else if (type == 'IEND') {
      break;
    }
    p += 12 + len;
  }
  if (depth != 8 || interlace != 0 || (ctype != 2 && ctype != 6)) {
    throw FormatException(
      'unsupported PNG (depth $depth, colour type $ctype, interlace $interlace)',
    );
  }
  final bpp = ctype == 6 ? 4 : 3;
  final raw = Uint8List.fromList(zlib.decode(idat.toBytes()));
  final stride = w * bpp;
  final out = Uint8List(w * h * 4);
  var prev = Uint8List(stride), cur = Uint8List(stride);
  var rp = 0;
  for (var y = 0; y < h; y++) {
    final f = raw[rp++];
    for (var i = 0; i < stride; i++) {
      final x = raw[rp++];
      final a = i >= bpp ? cur[i - bpp] : 0;
      final b = prev[i];
      final c = i >= bpp ? prev[i - bpp] : 0;
      final int v;
      switch (f) {
        case 0:
          v = x;
        case 1:
          v = x + a;
        case 2:
          v = x + b;
        case 3:
          v = x + ((a + b) >> 1);
        case 4:
          final pa = (b - c).abs(),
              pb = (a - c).abs(),
              pc = (a + b - 2 * c).abs();
          v = x + ((pa <= pb && pa <= pc) ? a : (pb <= pc ? b : c));
        default:
          throw FormatException('bad PNG filter $f');
      }
      cur[i] = v & 0xff;
    }
    for (var x = 0; x < w; x++) {
      final o = (y * w + x) * 4;
      out[o] = cur[x * bpp];
      out[o + 1] = cur[x * bpp + 1];
      out[o + 2] = cur[x * bpp + 2];
      out[o + 3] = bpp == 4 ? cur[x * bpp + 3] : 255;
    }
    final t = prev;
    prev = cur;
    cur = t;
  }
  return _Image(w, h, out);
}

Uint8List _sideBySide(_Image a, _Image b) {
  const gap = 16;
  final w = a.width + gap + b.width;
  final h = a.height > b.height ? a.height : b.height;
  final out = Uint8List(w * h * 4);
  for (var i = 0; i < out.length; i += 4) {
    out[i] = 255;
    out[i + 1] = 0;
    out[i + 2] = 255;
    out[i + 3] = 255;
  }
  void blit(_Image im, int ox) {
    for (var y = 0; y < im.height; y++) {
      out.setRange(
        (y * w + ox) * 4,
        (y * w + ox + im.width) * 4,
        im.rgba,
        y * im.width * 4,
      );
    }
  }

  blit(a, 0);
  blit(b, a.width + gap);
  return _encodePng(w, h, out);
}

Uint8List _encodePng(int w, int h, Uint8List rgba) {
  final raw = BytesBuilder();
  for (var y = 0; y < h; y++) {
    raw.addByte(0);
    raw.add(Uint8List.sublistView(rgba, y * w * 4, (y + 1) * w * 4));
  }
  final out = BytesBuilder()..add([137, 80, 78, 71, 13, 10, 26, 10]);
  void chunk(String type, List<int> data) {
    final head = ByteData(4)..setUint32(0, data.length);
    final body = [...type.codeUnits, ...data];
    final crc = ByteData(4)..setUint32(0, _crc32(body));
    out
      ..add(head.buffer.asUint8List())
      ..add(body)
      ..add(crc.buffer.asUint8List());
  }

  final ihdr = ByteData(13)
    ..setUint32(0, w)
    ..setUint32(4, h)
    ..setUint8(8, 8)
    ..setUint8(9, 6);
  chunk('IHDR', ihdr.buffer.asUint8List());
  chunk('IDAT', zlib.encode(raw.toBytes()));
  chunk('IEND', const []);
  return out.toBytes();
}

final List<int> _crcTable = List<int>.generate(256, (n) {
  var c = n;
  for (var k = 0; k < 8; k++) {
    c = (c & 1) != 0 ? 0xedb88320 ^ (c >> 1) : c >> 1;
  }
  return c;
});

int _crc32(List<int> bytes) {
  var c = 0xffffffff;
  for (final b in bytes) {
    c = _crcTable[(c ^ b) & 0xff] ^ (c >> 8);
  }
  return c ^ 0xffffffff;
}
