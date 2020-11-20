import 'package:app/services/constants.dart';
import 'package:app/widgets/preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ComparisonPicture extends StatelessWidget {
  final String title;
  final TextStyle titleStyle;
  final String origin;
  final String userToken;
  final String pictureUrl;
  final bool sideBySide;
  final bool interactive;

  const ComparisonPicture(
      {Key key,
      @required this.title,
      this.titleStyle,
      @required this.pictureUrl,
      this.origin = ADMIN_PORTAL_URL,
      @required this.userToken,
      this.sideBySide = true,
      this.interactive = false})
      : super(key: key);

  _onPicturePreview(
      {@required BuildContext context, @required String pictureUrl}) {
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
    return sideBySide
        ? Expanded(
            child: !interactive
                ? Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            title,
                            style: titleStyle ??
                                TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontFamily: 'Klavika',
                                    letterSpacing: 1.0),
                          )),
                      GestureDetector(
                        onTap: () {
                          _onPicturePreview(
                              context: context, pictureUrl: pictureUrl);
                        },
                        child: CachedNetworkImage(
                          imageUrl: pictureUrl,
                          httpHeaders: {
                            "Origin": ADMIN_PORTAL_URL,
                            "Authorization": "Bearer $userToken"
                          },
                          progressIndicatorBuilder: (context, url, progress) {
                            if (progress == null || progress.progress == null) {
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
                    ].where((element) => element != null).toList(),
                  )
                : Stack(
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            title,
                            style: titleStyle ??
                                TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontFamily: 'Klavika',
                                    letterSpacing: 1.0),
                          )),
                      GestureDetector(
                        onTap: () {
                          _onPicturePreview(
                              context: context, pictureUrl: pictureUrl);
                        },
                        child: CachedNetworkImage(
                          imageUrl: pictureUrl,
                          httpHeaders: {
                            "Origin": ADMIN_PORTAL_URL,
                            "Authorization": "Bearer $userToken"
                          },
                          progressIndicatorBuilder: (context, url, progress) {
                            if (progress == null || progress.progress == null) {
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
                    ].where((element) => element != null).toList(),
                  ),
          )
        : Container(
            child: !interactive
                ? Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            title,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontFamily: 'Klavika',
                                letterSpacing: 1.0),
                          )),
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          _onPicturePreview(
                              context: context, pictureUrl: pictureUrl);
                        },
                        child: CachedNetworkImage(
                          imageUrl: pictureUrl,
                          httpHeaders: {
                            "Origin": ADMIN_PORTAL_URL,
                            "Authorization": "Bearer $userToken"
                          },
                          progressIndicatorBuilder: (context, url, progress) {
                            if (progress == null || progress.progress == null) {
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
                      ))
                    ].where((element) => element != null).toList(),
                  )
                : Stack(
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            title,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontFamily: 'Klavika',
                                letterSpacing: 1.0),
                          )),
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          _onPicturePreview(
                              context: context, pictureUrl: pictureUrl);
                        },
                        child: CachedNetworkImage(
                          imageUrl: pictureUrl,
                          httpHeaders: {
                            "Origin": ADMIN_PORTAL_URL,
                            "Authorization": "Bearer $userToken"
                          },
                          progressIndicatorBuilder: (context, url, progress) {
                            if (progress == null || progress.progress == null) {
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
                      ))
                    ].where((element) => element != null).toList(),
                  ),
          );
  }
}
