import 'package:flutter_music_player/utils/file_util.dart';

class SongUtil {
  static String getArtistNames(Map song) {
    if (song.containsKey('artistNames')) {
      return song['artistNames'];
    }

    String names = '';
    List arList;

    if (song.containsKey('ar')) {
      arList = song['ar'];
    } else if (song.containsKey('artists')) {
      arList = song['artists'];
    } else {
      arList = song['song']['artists'];
    }

    if (arList != null) {
      bool isFirst = true;
      arList.forEach((ar) {
        if (isFirst) {
          isFirst = false;
          names = ar['name'];
        } else {
          names += " " + ar['name'];
        }
      });
    }
    
    // 取了之后存下来，不用重复取了。
    song['artistNames'] = names;

    // 测试，不要在build里面调用相同的函数，会频繁执行。
    //print("getAritistNames: $names");
    return names;
  }

  static String getSongImage(Map song, {int size:100}) {
    String imgUrl;
    if (song.containsKey('imageUrl')) {
      imgUrl = song['imageUrl'];
    } else {
      try {
        if (song.containsKey('al')) {
          imgUrl = song['al']['picUrl'];
        } else {
          imgUrl = song['song']['album']['picUrl'];
        }
        song['imageUrl'] = imgUrl;  // 取一次之后存下来，不用后面计算。
      } catch(e) {
        print(e);
        print(song.toString());
        return '';
      } 
    }

    if (imgUrl == null || imgUrl.length == 0) {
      return '';
    }

    if (size > 0) {
      imgUrl += '?param=${size}y$size';
    }

    //print('imageUrl: $imgUrl');
    return imgUrl;
  }


  static String getSongUrl(Map song) {
    return "https://music.163.com/song/media/outer/url?id=${song['id']}.mp3";
  }


  static Future<String> getPlayPath(Map song) async{
    String localPath = await FileUtil.getSongLocalPath(song);
    if (await FileUtil.isFileExists(localPath)) {
      return localPath;
    } else {
      return getSongUrl(song);
    }

  }

}
