import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/cubits/CubitState.dart';
import 'package:note_app/cubits/UICubit.dart';
import 'package:note_app/database/DatabaseHelper.dart';
import 'package:note_app/model/NoteModel.dart';
import 'package:note_app/utils/FirebaseConstant.dart';
import 'package:note_app/utils/NetworkUtils.dart';

class NoteCubit extends Cubit<CubitState> {
  NoteCubit() : super(InitialState());
  List<NoteModel> noteList = List();
  UICubit<bool> loaderCubit = UICubit<bool>(false);
  DatabaseHelper databaseHelper;

//online data
  Future<void> addNoteToFirebase(
      String title, String description, BuildContext context, int timeStamp) {
    loaderCubit.updateState(true);
    CollectionReference news =
        FirebaseFirestore.instance.collection(FirebaseConstant.NOTE);
    return news.doc(timeStamp.toString()).set({
      'title': title,
      'description': description,
      'time_stamp': timeStamp,
    }).then((value) {
      loaderCubit.updateState(false);
      Map<String, dynamic> maps = {
        'title': title,
        'description': description,
        'time_stamp': timeStamp,
        'is_sync': 1, //1 means no need to sync
        'is_update': 1, // 1 means no need to update
        'delete_sync': 1, // 1 means no need to update
      };
      addNoteOffline(maps, timeStamp);
      Navigator.pop(context, true);
    }).catchError((error) {
      loaderCubit.updateState(false);
    });
  }

  Future<void> updateNoteToFirebase(String title, String description,
      BuildContext context, int timeStamp, String post_id) {
    loaderCubit.updateState(true);
    CollectionReference news =
        FirebaseFirestore.instance.collection(FirebaseConstant.NOTE);
    Map<String, dynamic> maps = {
      'title': title,
      'description': description,
      'time_stamp': timeStamp,
    };
    news.doc(timeStamp.toString()).update(maps).then((value) {
      Map<String, dynamic> maps = {
        'title': title,
        'description': description,
        'time_stamp': timeStamp,
        'is_update': 1, // 1 means no need to update
      };
      updateNote(maps, timeStamp);
      Navigator.pop(context, true);
    }).catchError((onError) {
      print(onError);
    });

    // addNoteOffline(maps);
  }

  Future<int> deleteFirebase(String id, int timeStamp) {
    loaderCubit.updateState(true);
    CollectionReference news =
        FirebaseFirestore.instance.collection(FirebaseConstant.NOTE);
    return news.doc(id).delete().then((value) {
      loaderCubit.updateState(false);
      getNoteListingOnline();
      deleteSqlite(timeStamp);
    }).catchError((error) {
      loaderCubit.updateState(false);
    });
  }

  void getNoteListingOnline() {
    noteList.clear();
    emit(LoadingState());
    FirebaseFirestore.instance
        .collection(FirebaseConstant.NOTE)
        .get()
        .catchError((onError) => FailedState(exception: onError))
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc["title"]);
        print(doc["description"]);
        noteList.add(NoteModel(
            title: doc["title"],
            time_stamp: doc["time_stamp"],
            description: doc["description"]));
      });
      print("getNoteListingOnline ${noteList}");
      syncOfflineDatatoOnline();

      if (noteList.length > 0) {
        emit(SuccessState());
      } else {
        emit(FailedState(message: "No data Found"));
      }
    });
  }

//offline data
  Future<int> addNoteOffline(Map<String, dynamic> row, int timeStamp) async {
    if (databaseHelper == null) {
      databaseHelper = DatabaseHelper.instance;
    }
    var id = await databaseHelper.addNote(row);
    print("Add note $id");
    return id;
  }

  Future<int> updateNote(Map<String, dynamic> row, int timeStamp) async {
    if (databaseHelper == null) {
      databaseHelper = DatabaseHelper.instance;
    }
    var id = await databaseHelper.updateNote(row, timeStamp);
    print("Update Note id $id");
    return id;
  }

  void fetchNoteOffline() async {
    emit(LoadingState());
    if (databaseHelper == null) {
      databaseHelper = DatabaseHelper.instance;
    }
    noteList = await databaseHelper.fetchNote();
    if (noteList.isEmpty) {
      emit(FailedState());
    } else {
      emit(SuccessState());
    }
  }

  void syncOfflineDatatoOnline() async {
    if (databaseHelper == null) {
      databaseHelper = DatabaseHelper.instance;
    }
    //sync add data
    var unSyncedAddList = await databaseHelper.fetchedUnSyncedAdd();
    print("unSyncedAddList $unSyncedAddList");

    for (int i = 0; i < unSyncedAddList.length; i++) {
      CollectionReference news =
          FirebaseFirestore.instance.collection(FirebaseConstant.NOTE);
      return news.doc(unSyncedAddList[i].time_stamp.toString()).set({
        'title': unSyncedAddList[i].title,
        'description': unSyncedAddList[i].description,
        'time_stamp': unSyncedAddList[i].time_stamp,
      }).then((value) {
        Map<String, dynamic> maps = {
          'title': unSyncedAddList[i].title,
          'description': unSyncedAddList[i].description,
          'time_stamp': unSyncedAddList[i].time_stamp,
          'is_sync': 1, //1 means data is synced
        };

        databaseHelper.updateNote(maps, unSyncedAddList[i].time_stamp);
        fetchNote(); //reload list if data is synced
      }).catchError((error) {});
    }
    //sync edited data
    var unSyncedUpdateList = await databaseHelper.fetchedUnSyncedUpdate();
    print("unSyncedUpdateList $unSyncedUpdateList");

    for (int i = 0; i < unSyncedUpdateList.length; i++) {
      CollectionReference news =
          FirebaseFirestore.instance.collection(FirebaseConstant.NOTE);
       news.doc(unSyncedUpdateList[i].time_stamp.toString()).update({
        'title': unSyncedUpdateList[i].title,
        'description': unSyncedUpdateList[i].description,
        'time_stamp': unSyncedUpdateList[i].time_stamp,
      }).then((value) {
        Map<String, dynamic> maps = {
          'title': unSyncedUpdateList[i].title,
          'description': unSyncedUpdateList[i].description,
          'time_stamp': unSyncedUpdateList[i].time_stamp,
          'is_update': 1, //1 means data is synced
        };

        databaseHelper.updateNote(maps, unSyncedUpdateList[i].time_stamp);
        fetchNote(); //reload list if data is synced
      }).catchError((error) {});
    }

    //sync delete data
    var unSyncedDeleteList = await databaseHelper.fetchedUnSyncedDelete();
    print("unSyncedDeleteList $unSyncedDeleteList");
    for (int i = 0; i < unSyncedDeleteList.length; i++) {
      CollectionReference news =
          FirebaseFirestore.instance.collection(FirebaseConstant.NOTE);
      return news
          .doc(unSyncedDeleteList[i].time_stamp.toString())
          .delete()
          .then((value) {
        Map<String, dynamic> maps = {
          'title': unSyncedDeleteList[i].title,
          'description': unSyncedDeleteList[i].description,
          'time_stamp': unSyncedDeleteList[i].time_stamp,
          'delete_sync': 1, //1 means data is synced
        };
        databaseHelper.updateNote(maps, unSyncedDeleteList[i].time_stamp);
        databaseHelper.deleteNote(unSyncedDeleteList[i].time_stamp);
        fetchNote();
      }).catchError((error) {});
    }
  }

  Future<int> deleteSqlite(int timeStamp) async {
    if (databaseHelper != null) {
      databaseHelper = DatabaseHelper.instance;
    }
    int isDeleted = await databaseHelper.deleteNote(timeStamp);
    print("Deleted status $isDeleted");
    return isDeleted;
  }

  void fetchNote() async {
    if (await NetworkUtils.isInternetAvailable()) {
      getNoteListingOnline();
    } else {
      fetchNoteOffline();
    }
  }
}
