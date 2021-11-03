part of utils;

class FileUtils {
  static final FileUtils _fileUtils = FileUtils._internal();

  factory FileUtils() {
    return _fileUtils;
  }

  FileUtils._internal();

  static Future<File> get _localFile async {
    try {
      final path = await _localPath;
      return File('$path/tmp.txt');
    }catch(FileSystemException){

    }
  }

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<dynamic> readCounter({File fl}) async {

    try {

      (fl == null ? await _localFile : fl).openRead()
          .map(utf8.decode)
          .transform(new LineSplitter())
          .forEach((l) {
            var ls = jsonDecode(l);

            if(ls['key'] == 'pwd'){
              Device.setPassWord(ls['value']);
            }else if(ls['key'] == 'ip'){
              Device.setDeviceIp(ls['value']);
            }else{
              Device.setUserName(ls['value']);
            }
          }
      );

    } catch (e) {

    }
  }

}