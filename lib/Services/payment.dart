import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:restaurent_app/others/utils.dart';

class ApiService4 {
  static const String baseUrl = "https://uat.onebanc.ai/emulator/interview";

  static Future<Map<String, dynamic>?> make_payment({
    required String totalAmount,
    required int totalItems,
    required List<Map<String, dynamic>> data,
    required BuildContext context,
  }) async {
    final url = Uri.parse('$baseUrl/make_payment');
    final payload = {
      "total_amount": totalAmount, // must be string
      "total_items": totalItems,
      "data": data,
    };

    print("Sending make_payment payload:");
    print(const JsonEncoder.withIndent('  ').convert(payload));

    try {
      final res = await http.post(
        url,
        headers: {
          "X-Partner-API-Key": "uonebancservceemultrS3cg8RaL30",
          "Content-Type": "application/json",
          "X-Forward-Proxy-Action": "make_payment",
        },
        body: jsonEncode({
          "total_amount": totalAmount.toString(), // convert to int if needed
          "total_items": totalItems,
          "data": data,
        }),
      );
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        ShowSnackBar(context, "Something went wrong ${payload}");
      }
    } catch (e) {
      ShowSnackBar(context, e.toString());
    }
    return null;
  }
}
