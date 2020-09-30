import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:photo_gallery/widgets/photo_item.dart';

class MyHomePage extends StatelessWidget {
  List<String> _imageUrlList = [];

  Future<void> getImages() async {
    final url = 'https://picsum.photos/v2/list?page=1&limit=99';
    Dio dio = Dio();
    try {
      Response response = await dio.get(url);
      print(response.statusCode);
      List extractedImages = response.data;
      List<String> loadedImages = [
        'https://theError',
      ];
      extractedImages.forEach((element) {
        loadedImages.add(element["download_url"]);
      });
      _imageUrlList = loadedImages;
    } on DioError catch (error) {
      if (error.response != null) {
        print(error.response.statusCode);
        print(error.response.statusMessage);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(error.request);
        print(error.message);
      }
      throw error;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.05,
        title: Text('Photo Gallery'),
      ),
      body: FutureBuilder(
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.error != null) {
            return Center(
              child: Text(
                'We have an error',
                style: TextStyle(color: Theme.of(context).errorColor),
              ),
            );
          } else {
            return CustomScrollView(
              slivers: [
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 5.0,
                    crossAxisSpacing: 5.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (ctx, index) => PhotoItem(_imageUrlList[index]),
                    childCount: _imageUrlList.length,
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'End of a Story :(',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
        future: getImages(),
      ),
    );
  }
}
