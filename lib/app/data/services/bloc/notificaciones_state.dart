part of 'notificaciones_bloc.dart';

sealed class NotificacionesState extends Equatable {
  const NotificacionesState();

  @override
  List<Object> get props => [];
}

final class NotificacionesInitial extends NotificacionesState {}
