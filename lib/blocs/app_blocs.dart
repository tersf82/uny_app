
import 'package:bloc/bloc.dart';
import '../repos/repositories.dart';

import 'app_events.dart';
import 'app_states.dart';


class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final UserRepository _userRepository;

  CommentBloc(this._userRepository) : super(UserLoadingState()) {
    on<CommentUserEvent> ((event, emit) async {
      emit(UserLoadingState());

      try{
        final comments = await _userRepository.getComments();
        emit(CommentLoadedState(comments));
      }catch (e) {
        emit(CommentErrorState(e.toString()));
      }


    });
  }
}