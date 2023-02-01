part of 'slider_bloc.dart';

@immutable
abstract class SliderEvent extends Equatable {}

class OnSliderChange extends SliderEvent {
  final double val;
  OnSliderChange({required this.val});

  @override
  List<Object?> get props => [val];

}
