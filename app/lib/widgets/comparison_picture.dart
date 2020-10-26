import 'package:app/services/constants.dart';
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
                      Image.network(
                        pictureUrl,
                        headers: {
                          "Origin": origin,
                          "Authorization": "Bearer $userToken"
                        },
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
                      Image.network(
                        pictureUrl,
                        headers: {
                          "Origin": origin,
                          "Authorization": "Bearer $userToken"
                        },
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
                          child: Image.network(
                        pictureUrl,
                        headers: {
                          "Origin": origin,
                          "Authorization": "Bearer $userToken"
                        },
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
                          child: Image.network(
                        pictureUrl,
                        headers: {
                          "Origin": origin,
                          "Authorization": "Bearer $userToken"
                        },
                      ))
                    ].where((element) => element != null).toList(),
                  ),
          );
  }
}
