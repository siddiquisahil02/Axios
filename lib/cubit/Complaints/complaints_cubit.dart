import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:society_manager/constants.dart';
import 'package:society_manager/utils/network/fcm_send.dart';
import 'package:society_manager/utils/upload_file.dart';

part 'complaints_state.dart';

class ComplaintsCubit extends Cubit<ComplaintsState> {
  ComplaintsCubit() : super(ComplaintsLoading());
  
  void getData()async{
    try{
      emit(ComplaintsLoading());
      final String resId = box.read('resId')??"N.A";
      final res = await firebase.collection('operationalAt').doc(resId).get();
      List<String> data;
      if(res.exists){
        data = res.data()!['services'].cast<String>();
      }else{
       data = [];
      }
      emit(ComplaintsInitial(data: data));
    }on FirebaseException catch(e){
      if(e.code == 'unavailable'){
        emit(ComplaintsError(msg: "Please check your Internet Connection"));
      }else{
        emit(ComplaintsError(msg: e.message??"Unknown Error"));
      }
    }catch(e){
      emit(ComplaintsError(msg: e.toString()));
    }
  }

  void uploadData({required String cat, required String desc, required List<XFile> images})async{
    try{
      emit(ComplaintsLoading());
      final String resId = box.read('resId')??"N.A";
      final String res = box.read('res');
      List<String> imagesUrl = [];
      if(images.isNotEmpty){
        for (var element in images){
          final String url = await UploadFile.uploadFIle(element);
          imagesUrl.add(url);
        }
      }
      await firebase
          .collection('operationalAt')
          .doc(resId)
          .collection("complaints")
          .add(
        {
          "category":cat,
          "desc":desc,
          "images":imagesUrl,
          'status':"Open",
          'residence': res,
          "createdAt":Timestamp.now()
        }
      );

      final boolRes = await FCMUtils().sendTopicMsg(
          topicName: "$resId-complaints",
          tile: "New Complaint",
          body: "for $cat"
      );

      if(!boolRes){
        Fluttertoast.showToast(msg: "Error in FCM");
      }

      emit(ComplaintsDone());
    }on FirebaseException catch(e){
      if(e.code == 'unavailable'){
        emit(ComplaintsError(msg: "Please check your Internet Connection"));
      }else{
        emit(ComplaintsError(msg: e.message??"Unknown Error"));
      }
    }catch(e){
      emit(ComplaintsError(msg: e.toString()));
    }
  }
  
}
