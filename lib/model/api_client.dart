  import 'package:secret_book/model/event.dart';

Future<void> createImage(String text, Event event) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/images/generations'),
        headers: {
          'Authorization': 'Bearer ${LocalData.instance.apiKey}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'prompt': text,
          'response_format': 'b64_json',
          'size': size.apiSize,
        }),
      );

      if (response.statusCode != 200) {
        return null;
      }

      final json = await compute(parseJson, response.body);
      final base64Json = json['data'][0]['b64_json'];
      final args = {
        'prompt': text,
        'data': base64Json,
        'size': size,
      };
      final image = await compute(getChatImageFromBase64, args);
      return image;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }