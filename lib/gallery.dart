import 'dart:math';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

bool _isLoading = true; 
bool _isLoadMoreRunning = false;

class Gallery extends StatefulWidget {
  const Gallery({Key? key}) : super(key: key);


  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {

  List photosList = [];

  void getFirstImages() async{

    for( var i = 0 ; i <= 18; i++ ) {
      var rng = Random(); 
      var linkOfPhoto = "https://picsum.photos/300/200?random=${(rng.nextInt(999999))}";
      // var response = await httpService.getImages(rng.nextInt(999999));
      photosList.add(linkOfPhoto);
   } 
    
    // for (var element in response) {
    //    photosList.add(element['download_url'].toString());
    // }
    
    setState(() {
      _isLoading = false;
    });
  }

  void loadMore() async{
    if(_isLoading == false && _isLoadMoreRunning == false){
      setState(() {
        _isLoadMoreRunning = true;
      });

      for( var i = 0 ; i <= 18; i++ ) {
        var rng = Random(); 
        var linkOfPhoto = "https://picsum.photos/300/200?random=${(rng.nextInt(999999))}";
        // var response = await httpService.getImages(rng.nextInt(999999));
        photosList.add(linkOfPhoto);
      } 
    
      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    getFirstImages();
    _controller = ScrollController()..addListener(loadMore);
  }

  @override
  void dispose() {
    _controller.removeListener(loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) { 

    return Scaffold(
      appBar: AppBar(

        title: const Text('Photo Gallery'),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : Column(
          children: [
            Expanded(
              child: GridView.builder(
                controller: _controller,
                itemCount: photosList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  crossAxisCount: 3,
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
            ),
            _isLoadMoreRunning == true ? const Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 40),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ) : Container(),
          ],
        ) 
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