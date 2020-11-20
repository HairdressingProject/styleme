import 'dart:convert';

import 'package:app/models/history.dart';
import 'package:app/models/picture.dart';
import 'package:app/services/constants.dart';
import 'package:app/services/history.dart';
import 'package:app/services/pictures.dart';
import 'package:app/widgets/preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryView extends StatefulWidget {
  final Picture originalPicture;
  final String origin;
  final String userToken;

  const HistoryView(
      {Key key, this.originalPicture, this.origin, this.userToken})
      : super(key: key);

  @override
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  final ScrollController _scrollController = ScrollController();
  Future<List<Picture>> _picturesHistoryFuture;
  List<Picture> _picturesHistory;

  _onPicturePreview({@required BuildContext context, @required int pictureId}) {
    final pictureUrl = '${PicturesService.picturesUri}/file/$pictureId';
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Preview(
                  previewPictureUrl: pictureUrl,
                  userToken: widget.userToken,
                  origin: widget.origin,
                )));
  }

  @override
  void initState() {
    super.initState();
    _picturesHistoryFuture = _fetchPicturesFromHistory();
  }

  Future<List<Picture>> _fetchPicturesFromHistory() async {
    final history = await _fetchHistory();
    List<Picture> pictures = List<Picture>();
    final picturesService = PicturesService();

    if (history != null && history.isNotEmpty) {
      // try to retrieve pictures locally
      for (var entry in history) {
        final localPictureMap =
            await picturesService.getByIdLocal(id: entry.pictureId);

        if (localPictureMap != null) {
          pictures.add(Picture.fromJson(localPictureMap));
        }
      }

      if (pictures.length != history.length) {
        // not all pictures have been retrieved locally, request the API
        pictures.clear();

        for (var entry in history) {
          final response = await picturesService.getById(id: entry.pictureId);

          if (response != null &&
              response.statusCode == 200 &&
              response.body.isNotEmpty) {
            final picture = Picture.fromJson(jsonDecode(response.body));
            pictures.add(picture);
            // also add picture to local db
            await picturesService.postLocal(obj: picture.toJson());
          }
        }
      }

      setState(() {
        _picturesHistory = pictures;
      });
    }
    return pictures;
  }

  Future<List<History>> _fetchHistory() async {
    final historyService = HistoryService();
    List<History> historyEntries = List<History>();

    // try to retrieve history entries locally first
    final localHistory = await historyService.getByPictureIdLocal(
        originalPictureId: widget.originalPicture.id);

    if (localHistory.isNotEmpty && localHistory.length > 1) {
      historyEntries = localHistory;
    } else {
      // if there are only a couple of entries, try to retrieve the rest from the API
      final response = await historyService.getByPictureId(
          originalPictureId: widget.originalPicture.id);

      if (response != null &&
          response.statusCode == 200 &&
          response.body.isNotEmpty) {
        final rawHistory = List.from(jsonDecode(response.body));

        historyEntries = rawHistory.map((e) => History.fromJson(e)).toList();

        // save them locally
        historyEntries.forEach((element) async {
          await historyService.postLocal(obj: element.toJson());
        });
      }
    }
    return historyEntries;
  }

  @override
  Widget build(BuildContext context) {
    final originalPictureUrl =
        '${PicturesService.picturesUri}/file/${widget.originalPicture.id.toString()}';

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
              child: FutureBuilder(
                future: _picturesHistoryFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height * 3,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          GestureDetector(
                              onTap: () {
                                _onPicturePreview(
                                    context: context,
                                    pictureId: widget.originalPicture.id);
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
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.0)),
                                    GestureDetector(
                                      onTap: () {
                                        _onPicturePreview(
                                            context: context,
                                            pictureId:
                                                widget.originalPicture.id);
                                      },
                                      child: CachedNetworkImage(
                                        imageUrl: originalPictureUrl,
                                        httpHeaders: {
                                          "Origin": ADMIN_PORTAL_URL,
                                          "Authorization":
                                              "Bearer ${widget.userToken}"
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
                                children: List.generate(_picturesHistory.length,
                                    (index) {
                                  final currentPicture =
                                      _picturesHistory[index];
                                  final parsedDateCreated = DateTime.parse(
                                      currentPicture.dateCreated);

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
                                                "Authorization":
                                                    "Bearer ${widget.userToken}"
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
                                                  child:
                                                      CircularProgressIndicator(
                                                    value: progress.progress,
                                                  ),
                                                );
                                              },
                                              errorWidget:
                                                  (context, url, error) =>
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
                    );
                  } else if (snapshot.hasError) {
                    return Column(
                      children: [
                        const Icon(
                          Icons.error,
                          size: 128,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        Text(snapshot.error.toString())
                      ],
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )),
        ));
  }
}
