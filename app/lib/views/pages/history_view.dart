import 'package:app/models/picture.dart';
import 'package:app/services/constants.dart';
import 'package:app/services/pictures.dart';
import 'package:app/widgets/preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryView extends StatelessWidget {
  final Picture originalPicture;
  final List<Picture> historyPictures;
  final String origin;
  final String userToken;
  final ScrollController _scrollController = ScrollController();

  HistoryView(
      {Key key,
      @required this.originalPicture,
      @required this.historyPictures,
      this.origin = ADMIN_PORTAL_URL,
      @required this.userToken})
      : super(key: key);

  _onPicturePreview({@required BuildContext context, @required int pictureId}) {
    final pictureUrl = '${PicturesService.picturesUri}/file/$pictureId';
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Preview(
                  previewPictureUrl: pictureUrl,
                  userToken: userToken,
                  origin: origin,
                )));
  }

  @override
  Widget build(BuildContext context) {
    final originalPictureUrl =
        '${PicturesService.picturesUri}/file/${originalPicture.id.toString()}';

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 96, 96, 96),
        appBar: AppBar(
            title: Text(
          'History',
          style: TextStyle(fontFamily: 'Klavika'),
        )),
        body: Scrollbar(
          controller: _scrollController,
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 3,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    GestureDetector(
                        onTap: () {
                          _onPicturePreview(
                              context: context, pictureId: originalPicture.id);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 30.0, horizontal: 50.0),
                          child: Column(
                            children: [
                              Text(
                                'Original',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Klavika',
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.8),
                              ),
                              const Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 10.0)),
                              GestureDetector(
                                onTap: () {
                                  _onPicturePreview(
                                      context: context,
                                      pictureId: originalPicture.id);
                                },
                                child: CachedNetworkImage(
                                  imageUrl: originalPictureUrl,
                                  httpHeaders: {
                                    "Origin": ADMIN_PORTAL_URL,
                                    "Authorization": "Bearer $userToken"
                                  },
                                  progressIndicatorBuilder:
                                      (context, url, progress) {
                                    if (progress == null ||
                                        progress.progress == null) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: progress.progress,
                                      ),
                                    );
                                  },
                                  errorWidget: (context, url, error) => Center(
                                    child: Icon(
                                      Icons.error,
                                      size: 128,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                    ),
                    Expanded(
                      child: GridView.count(
                          crossAxisCount: 2,
                          padding: const EdgeInsets.all(20.0),
                          physics: NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 50.0,
                          crossAxisSpacing: 30.0,
                          children:
                              List.generate(historyPictures.length, (index) {
                            final currentPicture = historyPictures[index];
                            final parsedDateCreated =
                                DateTime.parse(currentPicture.dateCreated);

                            final pictureDateCreated =
                                DateFormat('dd/MM/yyyy HH:mm:ss')
                                    .format(parsedDateCreated);
                            final pictureUrl = Uri.encodeFull(
                                '${PicturesService.picturesUri}/file/${currentPicture.id.toString()}');

                            return GestureDetector(
                                onTap: () {
                                  _onPicturePreview(
                                      context: context,
                                      pictureId: currentPicture.id);
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      pictureDateCreated,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Klavika',
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.0)),
                                    Expanded(
                                        child: GestureDetector(
                                      onTap: () {
                                        _onPicturePreview(
                                            context: context,
                                            pictureId: currentPicture.id);
                                      },
                                      child: CachedNetworkImage(
                                        imageUrl: pictureUrl,
                                        httpHeaders: {
                                          "Origin": ADMIN_PORTAL_URL,
                                          "Authorization": "Bearer $userToken"
                                        },
                                        progressIndicatorBuilder:
                                            (context, url, progress) {
                                          if (progress == null ||
                                              progress.progress == null) {
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: progress.progress,
                                            ),
                                          );
                                        },
                                        errorWidget: (context, url, error) =>
                                            Center(
                                          child: Icon(
                                            Icons.error,
                                            size: 128,
                                          ),
                                        ),
                                      ),
                                    ))
                                  ],
                                ));
                          })),
                    )
                  ],
                ),
              )),
        ));
  }
}
