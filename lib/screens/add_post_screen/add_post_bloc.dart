import 'package:bloc/bloc.dart';
import 'add_post_event.dart';
import 'add_post_state.dart';

class AddPostBloc extends Bloc<AddPostEvent, AddPostState> {
  AddPostBloc() : super(const AddPostState()) {
    on<PickDateTimeEvent>(_onPickDateTime);
    on<SelectSourceEvent>(_onSelectSource);
    on<SelectDestinationEvent>(_onSelectDestination);
    on<SaveAdditionalInfoEvent>(_onSaveAdditionalInfo);
  }

  void _onPickDateTime(PickDateTimeEvent event, Emitter<AddPostState> emit) {
    emit(state.copyWith(selectedDateTime: event.selectedDateTime));
  }

  void _onSelectSource(SelectSourceEvent event, Emitter<AddPostState> emit) {
    emit(state.copyWith(
      sourcePoint: event.sourcePoint,
      sourceAddress: event.sourceAddress,
    ));
  }

  void _onSelectDestination(
      SelectDestinationEvent event, Emitter<AddPostState> emit) {
    emit(state.copyWith(
      destinationPoint: event.destinationPoint,
      destinationAddress: event.destinationAddress,
    ));
  }

  void _onSaveAdditionalInfo(
      SaveAdditionalInfoEvent event, Emitter<AddPostState> emit) {
    emit(state.copyWith(
      address: event.address,
      description: event.description,
    ));
  }
}
