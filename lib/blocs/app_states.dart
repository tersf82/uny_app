import 'package:equatable/equatable.dart';
import '../models/models.dart';

abstract class CommentState extends Equatable {}

class UserLoadingState extends CommentState {
  @override
  List<Object> get props => [];
}

class CommentLoadedState extends CommentState {
  CommentLoadedState(this.comments);
  final List<CommentModel> comments;

  @override
  List<Object> get props => [];
}

class CommentErrorState extends CommentState {
  CommentErrorState(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
