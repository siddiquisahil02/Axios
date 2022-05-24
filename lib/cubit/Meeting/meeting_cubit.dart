import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:society_manager/constants.dart';
import 'package:society_manager/models/meeting_model.dart';

part 'meeting_state.dart';

class MeetingCubit extends Cubit<MeetingState> {
  MeetingCubit() : super(MeetingLoading());

  void getData()async{
    try{
      emit(MeetingLoading());
      final String resId = box.read('resId')??"N.A";
      List<MeetingModel> data = [];

      final res = await firebase
          .collection('operationalAt')
          .doc(resId)
          .collection('meeting')
          .orderBy('createdAt',descending: true)
          .get();

      for (var element in res.docs){
        MeetingModel model = MeetingModel.fromJson(element.data());
        data.add(model);
      }

      emit(MeetingInitial(data: data));
    }on FirebaseException catch(e){
      if(e.code == 'unavailable'){
        emit(MeetingError(msg: "Please check your Internet Connection"));
      }else{
        emit(MeetingError(msg: e.message??"Unknown Error"));
      }
    }catch(e){
      emit(MeetingError(msg: e.toString()));
    }
  }

}
