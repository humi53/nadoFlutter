// ignore_for_file: unused_field, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:writer/models/art_dto.dart';
import 'package:writer/modules/gallary_service.dart';
import 'package:writer/page/pic_detail_page.dart';
import 'package:writer/ui_models/input_form_field.dart';

///data/user/0/com.yopheu.writer/cache/cfc10c0b-f860-4288-9ca8-6aaafbe12a0f/여우-09-gemini761.jpg
class Pushpic extends StatefulWidget {
  const Pushpic({super.key});

  @override
  State<Pushpic> createState() => _PushpicState();
}

class _PushpicState extends State<Pushpic> {
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImg;

  String _titleValue = "";
  String _description = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("작품 올리기"),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _pickedImg != null
                  ? Image.file(File(_pickedImg!.path))
                  : const Text('이미지가 없습니다'),
              ElevatedButton(
                onPressed: _pickImg,
                child: const Text('이미지를 선택하세요.'),
              ),
              inputFormField(
                setValue: (value) => _titleValue = value,
                labelText: "Title Name",
              ),
              inputFormField(
                setValue: (value) => _description = value,
                maxLength: 500,
                maxLines: 3,
                labelText: "Details about art.",
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (_titleValue.isNotEmpty &&
                        _description.isNotEmpty &&
                        _pickedImg != null) {
                      ArtDto? artDto = await GallaryService().insertArt(
                          context: context,
                          imageFile: _pickedImg!,
                          title: _titleValue,
                          description: _description);
                      String message = "";
                      if (artDto == null) {
                        message = "system: 오류가 발생하여 실패하였습니다.";
                      } else {
                        message = "업로드가 완료되었습니다";
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PicDetail(artDto: artDto)));
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message)),
                      );
                      setState(() {});
                    }
                    // GallaryService().uploadImage(_pickedImg);
                  },
                  child: const Text("저장"))
            ],
          ),
        ));
  }

  Future<void> _pickImg() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      debugPrint("image Path : ${image.path}");
      setState(() {
        _pickedImg = image;
      });
    }
  }
}
