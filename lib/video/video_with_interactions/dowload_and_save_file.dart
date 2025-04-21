import 'dart:io';

class DownloadFileParams {
  DownloadFileParams({required this.videoUrl, required this.filePath});

  final String videoUrl;
  final String filePath;
}

Future<String> downloadAndSaveFile(DownloadFileParams params) async {
  final response = await HttpClient().getUrl(Uri.parse(params.videoUrl));
  final fileStream = await response.close();
  final file = File(params.filePath);
  await fileStream.pipe(file.openWrite());

  return params.filePath;
}
