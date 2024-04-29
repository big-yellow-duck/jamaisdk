library jamaisdk;

import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class ParseAddRow {
  String object;
  List<ParseColumn> columns;
  String rowId;

  ParseAddRow({
    required this.rowId,
    required this.columns,
    required this.object,
  });

  factory ParseAddRow.fromJson(Map<String, dynamic> json) {
    return ParseAddRow(
      rowId: json['row_id'],
      columns: (json['columns'] as List)
          .map((x) => ParseColumn.fromJson(x))
          .toList(),
      object: json['object'],
    );
  }
}

class ParseColumn {
  String id;
  String object;
  int created;
  String model;
  ParseUsage usage;
  List<ParseChoices> choices;

  ParseColumn({
    required this.id,
    required this.object,
    required this.created,
    required this.model,
    required this.usage,
    required this.choices,
  });

  factory ParseColumn.fromJson(Map<String, dynamic> json) {
    return ParseColumn(
      id: json['id'],
      object: json['object'],
      created: json['created'],
      model: json['model'],
      usage: ParseUsage.fromJson(json['usage']),
      choices: (json['choices'] as List)
          .map((x) => ParseChoices.fromJson(x))
          .toList(),
    );
  }
}

class ParseUsage {
  int promptTokens;
  int completionTokens;
  int totalTokens;

  ParseUsage({
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
  });

  factory ParseUsage.fromJson(Map<String, dynamic> json) {
    return ParseUsage(
      promptTokens: json['prompt_tokens'],
      completionTokens: json['completion_tokens'],
      totalTokens: json['total_tokens'],
    );
  }
}

class ParseChoices {
  ParseMessage message;
  int index;
  String finishReason;

  ParseChoices({
    required this.message,
    required this.index,
    required this.finishReason,
  });

  factory ParseChoices.fromJson(Map<String, dynamic> json) {
    return ParseChoices(
      message: ParseMessage.fromJson(json['message']),
      index: json['index'],
      finishReason: json['finish_reason'],
    );
  }
}

class ParseMessage {
  String role;
  String content;
  String? name;

  ParseMessage({
    required this.role,
    required this.content,
    required this.name,
  });

  factory ParseMessage.fromJson(Map<String, dynamic> json) {
    return ParseMessage(
      role: json['role'],
      content: json['content'],
      name: json['name'],
    );
  }
}

class jamaiService {
  final String user;
  final String password;

  jamaiService({
    required this.user,
    required this.password,
  });

  Future<String> addRow(String tableId, List<String> data, bool stream) async {
    const addRowApiUrl =
        "https://app.jamaibase.com/api/v1/gen_tables/action/rows/add";
    var authHeader = 'Basic ${base64.encode(utf8.encode('$user:$password'))}';

    final response = await http.post(Uri.parse(addRowApiUrl),
        headers: {
          'Authorization': authHeader,
          "accept": 'application/json',
          'content-type': 'application/json'
        },
        body: jsonEncode({
          'table_id': tableId,
          'data': data,
          'stream': stream,
        }));

    if (response.statusCode == 200) {
      print('add row successfully');
      return response.body.toString();
    } else {
      throw Exception(
          'Error Adding Row: Status Code: ${response.statusCode}, Body: ${response.body}');
    }
  }
}
