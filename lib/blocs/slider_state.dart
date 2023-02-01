part of 'slider_bloc.dart';

@immutable
abstract class SliderState extends Equatable {}

class SliderInitial extends SliderState {
  final double val;
  SliderInitial({required this.val});
  @override
  List<Object?> get props => [val];
}
