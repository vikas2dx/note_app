import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/cubits/NoteCubit.dart';
import 'package:note_app/cubits/UICubit.dart';
import 'package:note_app/model/NoteModel.dart';
import 'package:note_app/ui/resources/AppStrings.dart';
import 'package:note_app/ui/widgets/CustomButton.dart';
import 'package:note_app/ui/widgets/CustomTextFormField.dart';
import 'package:note_app/ui/widgets/LoadingWidget.dart';
import 'package:note_app/utils/NetworkUtils.dart';

class AddNotePage extends StatefulWidget {
  bool isUpdate = false;
  NoteModel noteModel;
  AddNotePage({this.isUpdate,this.noteModel});

  @override
  _AddNotePageState createState() => _AddNotePageState(isUpdate,noteModel);
}

class _AddNotePageState extends State<AddNotePage> {
  NoteCubit newsCubit = NoteCubit();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final verticalGap = const SizedBox(
    height: 15,
  );
  FirebaseFirestore firestore;
  bool isUpdate = false;
  NoteModel noteModel;

  _AddNotePageState(this.isUpdate, this.noteModel);

  @override
  void initState() {
    firestore = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.NOTE,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(AppStrings.NOTE),
        ),
        body: Container(
          padding: EdgeInsets.all(8),
          child: Stack(
            children: [
              Builder(builder: (scaffoldContext) {
                return Column(
                  children: [
                    CustomTextFormField(
                      hintText: AppStrings.NOTE_TITLE,
                      controller: titleController,
                    ),
                    verticalGap,
                    CustomTextFormField(
                      hintText: AppStrings.NOTE_DESCRIPTION,
                      controller: descriptionController,
                    ),
                    verticalGap,
                    CustomButton(
                      text: isUpdate
                          ? AppStrings.NOTE_UPDATE
                          : AppStrings.NOTE_ADD,
                      pressedCallBack: () async {
                        if (isUpdate) {
                          noteUpdate();
                        } else {
                          noteAdd();
                        }
                      },
                    )
                  ],
                );
              }),
              BlocBuilder<UICubit<bool>, bool>(
                cubit: newsCubit.loaderCubit,
                builder: (context, state) {
                  return state ? LoadingWidget(true) : LoadingWidget(false);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void noteAdd() async {
    int timeStamp = DateTime.now().microsecondsSinceEpoch;
    if (await NetworkUtils.isInternetAvailable()) {
      newsCubit.addNoteToFirebase(
          titleController.text, descriptionController.text, context, timeStamp);
    } else {
      Map<String, dynamic> maps = {
        'title': titleController.text,
        'description': descriptionController.text,
        'time_stamp': timeStamp,
        'is_sync': 0, //data need to be synced
        'is_update': 1, //no need of update
      };
      int id = await newsCubit.addNoteOffline(maps,timeStamp);
      if (id > 0) {
        Navigator.pop(context, true);
      }
    }
  }

  void noteUpdate() async {
    if (await NetworkUtils.isInternetAvailable()) {
      newsCubit.updateNoteToFirebase(
          titleController.text, descriptionController.text, context, noteModel.time_stamp,noteModel.time_stamp.toString());
    } else {
      //No internet case
      Map<String, dynamic> maps = {
        'title': titleController.text,
        'description': descriptionController.text,
        'time_stamp': noteModel.time_stamp,
        'is_sync': 1, //data not need to be synced
        'is_update': 0, //data need to be update
        'delete_sync': 1, //data need to be update

      };
      int id = await newsCubit.updateNote(maps,noteModel.time_stamp);
      if (id > 0) {
        Navigator.pop(context, true);
      }
    }
  }
}
