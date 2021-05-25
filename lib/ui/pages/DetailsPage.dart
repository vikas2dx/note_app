import 'package:flutter/material.dart';
import 'package:note_app/model/NoteModel.dart';
import 'package:note_app/ui/widgets/CustomText.dart';

class DetailsPage extends StatelessWidget {
 NoteModel noteModel;
  DetailsPage(this.noteModel, {Key key}) : super(key: key);

  final verticalGap = SizedBox(
    height: 10,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Text("Note Details"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            )),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(8),
            child: Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: noteModel.title,
                        fontWeight: FontWeight.bold,
                      ),
                      verticalGap,
                      CustomText(
                        text: noteModel.description,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
