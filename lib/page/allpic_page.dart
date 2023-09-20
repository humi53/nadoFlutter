import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:writer/models/art_dto.dart';
import 'package:writer/page/pic_detail_page.dart';
import 'package:writer/providers/gallary_provider.dart';

class Allpic extends StatelessWidget {
  const Allpic({super.key});

  @override
  Widget build(BuildContext context) {
    final gallaryProvider =
        Provider.of<GallaryProvider>(context, listen: false);
    gallaryProvider.loadStation();
    return Scaffold(
      appBar: AppBar(
        title: const Text("모든작품들"),
      ),
      body: Consumer<GallaryProvider>(
        builder: (context, provider, child) {
          if (provider.artList.isNotEmpty) {
            return ListView.separated(
              itemBuilder: (context, index) {
                ArtDto artDto = provider.artList[index];
                String now = DateFormat('yyyy-MM-dd').format(DateTime.now());

                return InkWell(
                  onTap: () {
                    debugPrint("target DocumnetID: ${artDto.docId}");
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PicDetail(artDto: artDto)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text("제목: ${artDto.title} |  "),
                        Text("작가: ${artDto.userNick} |  "),
                        const Text("  "),
                        Text(
                            "작성일: ${now != artDto.getDate() ? artDto.getDate() : artDto.getTime()}"),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: provider.artList.length,
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
