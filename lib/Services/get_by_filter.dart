import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:restaurent_app/others/utils.dart';

class ApiService3 {
  static const String baseUrl = "https://uat.onebanc.ai/emulator/interview";

  static Future<Map<String, dynamic>?> getItemByFilter({
    required BuildContext context,
    String? cuisine,
    double? minRating,
    double? minPrice,
    double? maxPrice,
  }) async {
    final url = Uri.parse('$baseUrl/get_item_by_filter');
    Map<String, dynamic> filterData = {};

    if (cuisine != null) {
    filterData["cuisine_type"] = [cuisine];
  }

  if (minPrice != null || maxPrice != null) {
    filterData["price_range"] = {
      if (minPrice != null) "min_amount": minPrice.toInt(),
      if (maxPrice != null) "max_amount": maxPrice.toInt(),
    };
  }

  if (minRating != null) {
    filterData["min_rating"] = minRating;
  }

    try {
      final res = await http.post(
        url,
        headers: {
          "X-Partner-API-Key": "uonebancservceemultrS3cg8RaL30",
          "Content-Type": "application/json",
          "X-Forward-Proxy-Action": "get_item_by_filter",
        },
        body: jsonEncode(filterData),
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
