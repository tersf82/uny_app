
import 'package:bloc/bloc.dart';
import '../repos/repositories.dart';

import 'app_events.dart';
import 'app_states.dart';


class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final CommentRepository _commentRepository;

  CommentBloc(this._commentRepository) : super(CommentLoadingState()) {
    on<CommentUserEvent> ((event, emit) async {
      emit(CommentLoadingState());

      try{
        final comments = await _commentRepository.getComments();
        emit(CommentLoadedState(comments));
      }catch (e) {
        emit(CommentErrorState(e.toString()));
      }


    });
  }
}