import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:society_manager/constants.dart';
import 'package:society_manager/models/emergency_model.dart';

part 'emergency_state.dart';

class EmergencyCubit extends Cubit<EmergencyState> {
  EmergencyCubit() : super(EmergencyInitial());

  void getData()async{
    try{
      emit(EmergencyLoading());
      final String resId = box.read('resId')??"N.A";

      final res = await firebase
          .collection('operationalAt')
          .doc(resId)
          .collection('emergency')
          .doc("data")
          .get();

      if(!res.exists){
        emit(EmergencyInitial());
        return;
      }
      EmergencyModel data = EmergencyModel.fromJson(res.data()??{});

      emit(EmergencyInitial(data: data));
    }on FirebaseException catch(e){
      if(e.code == 'unavailable'){
        emit(EmergencyError(msg: "Please check your Internet Connection"));
      }else{
        emit(EmergencyError(msg: e.message??"Unknown Error"));
      }
    }catch(e){
      emit(EmergencyError(msg: e.toString()));
    }
  }

}
