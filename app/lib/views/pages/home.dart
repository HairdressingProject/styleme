import 'package:flutter/material.dart';
import 'package:app/views/layout.dart';
import 'package:app/widgets/custom_button.dart';
import 'package:app/views/pages/select_face_shape.dart';

class Home extends StatelessWidget {
  static final String routeName = '/homeRoute';
  Home({Key key}) : super(key: key);

  @override
  build(BuildContext context) {
    return Layout(
        title: 'Style Me',
        header: 'Home',
        drawerItems: buildDefaultDrawerItems(context),
        body: SingleChildScrollView(
            child: Center(
                child: Padding(
          padding: const EdgeInsets.fromLTRB(50.0, 50.0, 50.0, 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
              ),
              Text("Let's get stylish!",
                  style: Theme.of(context).textTheme.headline1),
              Padding(
                  padding: const EdgeInsets.only(top: 35.0),
                  child: Text(
                    "Your progress",
                    style: Theme.of(context).textTheme.headline2,
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 35.0),
                  child: CustomButton(
                    icon: Icon(Icons.check),
                    text: "Select or take picture",
                    alreadySelected: true,
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 35.0),
                  child: CustomButton(
                    icon: Icon(Icons.check),
                    text: "Select your face shape",
                    action: SelectFaceShape(),
                    alreadySelected: true,
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 35.0),
                  child: CustomButton(
                    icon: Icon(Icons.check),
                    text: "Select a hair style",
                    alreadySelected: true,
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 35.0),
                  child: CustomButton(
                    icon: Icon(Icons.add),
                    text: "Colour your hair",
                    enabled: true,
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 35.0),
                  child: CustomButton(
                    icon: Icon(Icons.access_time),
                    text: "Save your results",
                    enabled: false,
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 35.0),
                  child: CustomButton(
                    icon: Icon(Icons.access_time),
                    text: "Compare results",
                    enabled: false,
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 35.0),
                  child: CustomButton(
                    icon: Icon(Icons.access_time),
                    text: "Upload hair style",
                    enabled: false,
                  )),
            ],
          ),
        ))));
  }
}
