import 'dart:io';
import 'dart:convert';

class KhaerulTerminalTimeEngine {
  static const int wibOffsetSeconds = 7 * 3600; 
  static const int maxAgeLimitSeconds = 30 * 3600;

  static DateTime getNowUtc() => DateTime.now().toUtc();

  static DateTime getNowWib() {
    DateTime utcNow = getNowUtc();
    DateTime shifted = utcNow.add(const Duration(seconds: wibOffsetSeconds));
    return DateTime.utc(
      shifted.year, shifted.month, shifted.day,
      shifted.hour, shifted.minute, shifted.second, shifted.millisecond,
    );
  }

  Map<String, dynamic> processMarketData(Map<String, dynamic> rawFeed) {
    final DateTime nowUtc = getNowUtc();
    final DateTime nowWib = getNowWib();
    final DateTime expiryUtc = nowUtc.add(const Duration(seconds: maxAgeLimitSeconds));

    return {
      'status': 'success',
      'id': rawFeed['id'] ?? 'unknown',
      'title': rawFeed['title'] ?? 'No Title',
      'rating': rawFeed['rating'] ?? 0,
      'timestamp_wib': formatWibTime(nowWib),
      'created_at_epoch': nowUtc.millisecondsSinceEpoch,
      'expiry_timestamp': expiryUtc.millisecondsSinceEpoch,
    };
  }

  static String formatWibTime(DateTime time) {
    String hour = time.hour.toString().padLeft(2, '0');
    String minute = time.minute.toString().padLeft(2, '0');
    String second = time.second.toString().padLeft(2, '0');
    return "$hour:$minute:$second WIB";
  }
}

void main() async {
  // Ambil PORT dinamis dari Render Cloud
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await HttpServer.bind(InternetAddress.anyIPv4, port);
  final engine = KhaerulTerminalTimeEngine();

  print('🚀 Khaerul Terminal Server berjalan di port $port');

  await for (HttpRequest request in server) {
    if (request.method == 'GET') {
      final response = {
        'service': 'Khaerul Terminal Time Engine',
        'current_wib': KhaerulTerminalTimeEngine.formatWibTime(KhaerulTerminalTimeEngine.getNowWib()),
        'status': 'online 24/7'
      };
      request.response
        ..headers.contentType = ContentType.json
        ..write(jsonEncode(response))
        ..close();
    } else if (request.method == 'POST') {
      final content = await utf8.decoder.bind(request).join();
      final data = jsonDecode(content);
      final result = engine.processMarketData(data);

      request.response
        ..headers.contentType = ContentType.json
        ..write(jsonEncode(result))
        ..close();
    }
  }
}
