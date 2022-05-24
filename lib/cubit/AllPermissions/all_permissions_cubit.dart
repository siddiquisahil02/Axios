import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:society_manager/constants.dart';

part 'all_permissions_state.dart';

class AllPermissionsCubit extends Cubit<AllPermissionsState> {
  AllPermissionsCubit() : super(AllPermissionsInitial());

  void getData()async{
    try{
      emit(AllPermissionsLoading());
      final String city = box.read('city')??"N.A";
      final String residence = box.read('res')??"N.A";
      // final String state = box.read('state')??"N.A";


      emit(AllPermissionsInitial());
    } on FirebaseException catch(e){
      if(e.code=='unavailable'){
        emit(AllPermissionsError(msg: "Check your Internet connection."));
      }
      emit(AllPermissionsError(msg: e.message??"Unknown Error"));
    }catch(e){
      emit(AllPermissionsError(msg: e.toString()));
    }
  }

}
