part of 'fetch_barber_bloc_bloc.dart';

@immutable
abstract class FetchAllbarberListState {
  const FetchAllbarberListState();
}

final class FetchAllbarberInitial extends FetchAllbarberListState {
  const FetchAllbarberInitial();
}

final class FetchAllbarberLoading extends FetchAllbarberListState {
  const FetchAllbarberLoading();
}

final class FetchAllbarberSuccess extends FetchAllbarberListState {
  final List<BarberEntity> barbers;
  
  const FetchAllbarberSuccess({required this.barbers});

}

final class FetchAllbarberListEmpty extends FetchAllbarberListState {
}

final class FetchAllbarberFailure extends FetchAllbarberListState {
  final String errorerror;

  const FetchAllbarberFailure(this.errorerror);
}