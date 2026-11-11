import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../core/utils/api_exception.dart';
import '../models/buku_model.dart';

abstract class BukuRemoteDataSource {
  Future<List<BukuModel>> getBuku();
  Future<BukuModel> createBuku(BukuModel buku);
}

class BukuRemoteDataSourceImpl implements BukuRemoteDataSource {
  final http.Client client;

  BukuRemoteDataSourceImpl({http.Client? client}) : client = client ?? http.Client();

  /// Alamat backend.
  /// - Chrome / desktop : http://localhost:3000
  /// - Emulator Android : http://10.0.2.2:3000
  /// - HP asli          : flutter run --dart-define=API_URL=http://IP-LAPTOP:3000
  String get baseUrl {
    const dariEnv = String.fromEnvironment('API_URL');
    if (dariEnv.isNotEmpty) return dariEnv;
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000';
    }
    return 'http://localhost:3000';
  }

  Future<http.Response> _kirim(Future<http.Response> Function() panggil) async {
    try {
      return await panggil().timeout(const Duration(seconds: 8));
    } catch (_) {
      throw ApiException('Tidak bisa terhubung ke server ($baseUrl). Pastikan backend sudah berjalan.');
    }
  }

  dynamic _urai(http.Response res) {
    dynamic body;
    try {
      body = jsonDecode(utf8.decode(res.bodyBytes));
    } catch (_) {
      body = null;
    }
    if (res.statusCode < 200 || res.statusCode >= 300) {
      final pesan = (body is Map && body['message'] is String)
          ? body['message'] as String
          : 'Permintaan gagal (${res.statusCode}).';
      throw ApiException(pesan);
    }
    return body;
  }

  @override
  Future<List<BukuModel>> getBuku() async {
    final res = await _kirim(() => client.get(Uri.parse('$baseUrl/buku')));
    final body = _urai(res) as List;
    return body.map((e) => BukuModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<BukuModel> createBuku(BukuModel b) async {
    final res = await _kirim(() => client.post(
          Uri.parse('$baseUrl/buku'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(b.toJson()),
        ));
    return BukuModel.fromJson(_urai(res) as Map<String, dynamic>);
  }
}
