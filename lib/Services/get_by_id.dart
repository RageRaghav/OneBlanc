import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:restaurent_app/others/utils.dart';

class ApiService2 {
  static const String baseUrl = "https://uat.onebanc.ai/emulator/interview";

  static Future<Map<String, dynamic>?> getItemById({
    required int itemID,
    required BuildContext context,
  }) async {
    final url = Uri.parse('$baseUrl/get_item_by_id');


    try {
      final res = await http.post(
        url,
        headers: {
          "X-Partner-API-Key": "uonebancservceemultrS3cg8RaL30",
          "Content-Type": "application/json",
          "X-Forward-Proxy-Action": "get_item_by_id",
        },
        body: jsonEncode({"item_id": itemID}),
      );
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        ShowSnackBar(context, "Something went wrong ${res.statusCode}");
      }
    } catch (e) {
      ShowSnackBar(context, e.toString());
    }
    return null;
  }
}
