import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:diabetes/NavBar.dart';
import 'package:diabetes/pages/UserListPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;

class CloudinaryService {
  static const String cloudName = "doxgctmpv";
  static const String uploadPreset = "ml_default"; // Set in Cloudinary settings

  static Future<String?> uploadFile(dynamic file, String fileType) async {
    try {
      print("Uploading $fileType to Cloudinary...");
      var url = Uri.parse(
          "https://api.cloudinary.com/v1_1/$cloudName/$fileType/upload");
      var request = http.MultipartRequest('POST', url);
      request.fields['upload_preset'] = uploadPreset;

      if (kIsWeb && file is PlatformFile && file.bytes != null) {
        request.files.add(http.MultipartFile.fromBytes('file', file.bytes!,
            filename: file.name));
      } else if (file is File) {
        request.files.add(await http.MultipartFile.fromPath('file', file.path));
      } else {
        print("Unsupported file type: ${file.runtimeType}");
        return null;
      }

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonData = json.decode(responseData);

      if (response.statusCode == 200) {
        print("Upload successful: ${jsonData['secure_url']}");
        return jsonData['secure_url'];
      } else {
        print("Error uploading to Cloudinary: ${jsonData['error']['message']}");
        return null;
      }
    } catch (e) {
      print("Cloudinary Upload Error: $e");
      return null;
    }
  }

  static Future<String?> uploadBytes(Uint8List bytes, String fileType) async {
    try {
      var url = Uri.parse(
          "https://api.cloudinary.com/v1_1/$cloudName/$fileType/upload");
      var request = http.MultipartRequest('POST', url);
      request.fields['upload_preset'] = uploadPreset;
      request.files.add(
          http.MultipartFile.fromBytes('file', bytes, filename: "upload.mp4"));

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonData = json.decode(responseData);

      if (response.statusCode == 200) {
        print("Upload successful: ${jsonData['secure_url']}");
        return jsonData['secure_url'];
      } else {
        print("Error uploading to Cloudinary: ${jsonData['error']['message']}");
        return null;
      }
    } catch (e) {
      print("Cloudinary Upload Error: $e");
      return null;
    }
  }
}
