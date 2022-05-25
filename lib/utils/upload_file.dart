import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class UploadFile{

  static String basicAuth(){
    const String key = "private_vT8t/BnF0nY1DKAEyHdlh1GmTd8=:";
    final String encodedKey = base64.encode(utf8.encode(key));
    return encodedKey;
  }

  static Future<String> uploadFIle(XFile file)async{
    try{
      var postUri = Uri.parse("https://upload.imagekit.io/api/v1/files/upload");
      var request = MultipartRequest("POST", postUri);
      request.headers['Authorization'] = "Basic ${basicAuth()}";
      request.headers[HttpHeaders.contentTypeHeader] = 'multipart/form-data';
      request.fields['fileName'] = file.name;
      request.fields['folder'] = '/Axios/';
      request.files.add(MultipartFile.fromBytes(
        'file',
        await file.readAsBytes(),
        filename: file.name,
      ));

      final res  = await request.send();
      final response = await Response.fromStream(res);
      if(res.statusCode==200){
        final Map<String,dynamic> data =  json.decode(response.body);
        return data['url'];
      }else{
        return 'N/A';
      }
    }catch(e){
      return 'N/A: ${e.toString()}';
    }
  }
}