import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:society_manager/constants.dart';

part 'permission_state.dart';

class PermissionCubit extends Cubit<PermissionState> {
  PermissionCubit() : super(PermissionInitial(data: null));

  void getData({required String payload})async{
    try{
      emit(PermissionLoading());
      final List<String> subData = payload.split('-');
      final String visitorID = subData.first;
      final String resID = subData.last;
      
      final res = await firebase.collection('operationalAt').doc(resID).collection('ActiveRequest').doc(visitorID).get();


      emit(PermissionInitial(data: res.data()));
    }on FirebaseException catch(e){
      if(e.code == 'unavailable'){
        emit(PermissionError(msg: "Check your internet connection"));
      }else{
        emit(PermissionError(msg: e.message.toString()));
      }
    }catch(e){
      print(e);
      emit(PermissionError(msg: e.toString()));
    }
  }

  void respond({required bool response,required String visitorID, required String resID})async{
    try{
      emit(PermissionLoading());

      final res = await firebase
          .collection('operationalAt')
          .doc(resID)
          .collection('ActiveRequest')
          .doc(visitorID)
          .get();

      final Map<String,dynamic> data = res.data()!;
      data['allowed'] = response;

      await firebase
          .collection('operationalAt')
          .doc(resID)
          .collection('visitors')
          .doc(visitorID)
          .set(data);

      await res.reference.delete();

      emit(PermissionDone());
    }on FirebaseException catch(e){
      if(e.code == 'unavailable'){
        emit(PermissionError(msg: "Check your internet connection"));
      }else{
        emit(PermissionError(msg: e.message.toString()));
      }
    }catch(e){
      print(e);
      emit(PermissionError(msg: e.toString()));
    }
  }

}
