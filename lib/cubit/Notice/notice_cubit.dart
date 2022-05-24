import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:society_manager/constants.dart';
import 'package:society_manager/models/notice_model.dart';

part 'notice_state.dart';

class NoticeCubit extends Cubit<NoticeState> {
  NoticeCubit() : super(NoticeInitial(listData: const []));

  void getData()async{
    try{
      emit(NoticeLoading());

      final String resId = box.read('resId')??"N.A";

      List<NoticeModel> listData = [];

      final res = await firebase
          .collection('operationalAt')
          .doc(resId)
          .collection('notice')
          .orderBy('createdAt',descending: true)
          .get();

      for (var element in res.docs){
        NoticeModel model = NoticeModel.fromJson(element.data());
        listData.add(model);
      }

      emit(NoticeInitial(listData: listData));
    }on FirebaseException catch(e){
      if(e.code == 'unavailable'){
        emit(NoticeError(msg: "Please check your Internet Connection"));
      }else{
        emit(NoticeError(msg: e.message??"Unknown Error"));
      }
    }catch(e){
      emit(NoticeError(msg: e.toString()));
    }
  }
}
