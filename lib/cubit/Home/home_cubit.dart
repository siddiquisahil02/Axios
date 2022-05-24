import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:society_manager/constants.dart';
import 'package:society_manager/models/home_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeLoading());

  void getDues()async{
    try{
      emit(HomeLoading());
      final String resId = box.read('resId')??"N.A";

      final res = await firebase
          .collection('users').doc(auth.currentUser?.uid??"N.A").get();

      if(res.exists){
        HomeModel model = HomeModel.fromJson(res.data()!);
        emit(HomeInitial(data: model));
      }else{
       emit(HomeError(msg: "No user data found..!"));
      }
    }on FirebaseException catch(e){
      if(e.code == 'unavailable'){
        emit(HomeError(msg: "Please check your Internet Connection"));
      }else{
        emit(HomeError(msg: e.message??"Unknown Error"));
      }
    }catch(e){
      emit(HomeError(msg: e.toString()));
    }
  }
}
