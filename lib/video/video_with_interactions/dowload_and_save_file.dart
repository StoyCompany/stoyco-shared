import 'dart:io';

Future<String> downloadAndSaveFile(Map<String, String> params) async {
  final videoUrl = params['videoUrl']!;
  final filePath = params['filePath']!;

  final response = await HttpClient().getUrl(Uri.parse(videoUrl));
  final fileStream = await response.close();
  final file = File(filePath);
  await fileStream.pipe(file.openWrite());

  return filePath;
}