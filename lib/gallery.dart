import 'package:flutter/material.dart';
import 'package:gallery_app_assignment/http/http_service.dart';
import 'package:photo_view/photo_view.dart';

bool isLoading = true; 

class Gallery extends StatefulWidget {
  const Gallery({Key? key}) : super(key: key);


  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {

  List photosList = [];

  final HttpService httpService = HttpService();

  getImages() async{
    var response = await httpService.getImages();
    for (var element in response) {
       photosList.add(element['download_url'].toString());
    }
    
    print(' lenght of photo list: ${photosList.length}, response: $response');
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    isLoading = true;
    getImages();
    
  }

  @override
  Widget build(BuildContext context) { 

    return Scaffold(
      appBar: AppBar(

        title: const Text('Photo Gallery'),
      ),
      body: isLoading ? const CircularProgressIndicator() : GridView.builder(
        itemCount: photosList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          crossAxisCount: 3
        ),
        itemBuilder: (BuildContext ctx, int index) {
          return GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewImageFullScreen(
                      image: photosList[index]),
                ),
              );
            },
            child: Image.network(photosList[index], fit: BoxFit.cover,
               errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                // Appropriate logging or analytics, e.g.
                // myAnalytics.recordError(
                //   'An error occurred loading "https://example.does.not.exist/image.jpg"',
                //   exception,
                //   stackTrace,
                // );
                return const Text('ð¢');
              },
            ),
          );
        },
      ),
 // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class ViewImageFullScreen extends StatelessWidget {
  final String image;

  const ViewImageFullScreen({Key? key, required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: PhotoView(
        imageProvider: NetworkImage(image),
      )
    );
  }
}