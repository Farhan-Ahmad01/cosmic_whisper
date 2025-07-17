import 'dart:developer';

import 'package:cosmic_whisper/models/chat_message_model.dart';
import 'package:cosmic_whisper/utils/constants.dart';
import 'package:dio/dio.dart';

class ChatRepo {
  static chatTextGenerationRepo(List<ChatMessageModel> previousMessages) async {
    try {

      Dio dio = Dio();

      final response = await dio.post(
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=${API_KEY}",

        data: {
          "contents": previousMessages.map((e) => e.toMap()).toList(),
          "generationConfig": {
            "temperature": 0.5,
            "topP": 0.7,
            "responseMimeType": "text/plain",
          },
        },
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return response
            .data['candidates']
            .first['content']['parts']
            .first['text'];
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
