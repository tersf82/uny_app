import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'slider_event.dart';
part 'slider_state.dart';

class SliderBloc extends Bloc<SliderEvent, SliderState> {
  SliderBloc() : super(SliderInitial(val: 5)) {
    on<OnSliderChange>((event, emit) {
       emit(SliderInitial(val: event.val));
    });

  }
}
