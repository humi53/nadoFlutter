import 'package:flutter/material.dart';
import 'package:writer/models/art_dto.dart';

class PicDetail extends StatefulWidget {
  const PicDetail({
    super.key,
    required this.artDto,
  });
  final ArtDto artDto;

  @override
  State<PicDetail> createState() => _PicDetailState();
}

class _PicDetailState extends State<PicDetail> {
  @override
  Widget build(BuildContext context) {
    var artDto = widget.artDto;
    return Scaffold(
      appBar: AppBar(
        title: Text("제목 : ${widget.artDto.title}"),
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 이미지 표시
              Image.network(artDto.imagePath),

              // 제목
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  artDto.title,
                  style: const TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),

              // 작성자
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("작성자: ${artDto.userNick}"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("작성일: ${artDto.getDate()} ${artDto.getTime()}"),
                  ),
                ],
              ),

              // 설명
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(artDto.description),
              ),

              // 작성일
            ],
          ),
        ),
      ),
    );
  }
}
