

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class CommentEvent extends Equatable{
  const CommentEvent();
}

class CommentUserEvent extends CommentEvent {
  @override
  List<Object?> get props => [];

}