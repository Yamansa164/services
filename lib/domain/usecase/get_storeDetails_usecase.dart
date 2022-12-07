
import 'package:dartz/dartz.dart';

import '../../data/network/failure.dart';
import '../model/models.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class StoreDetailsUseCase implements BaseUseCase<void, StoreDetails> {
  final Repository _repository;
  StoreDetailsUseCase(this._repository);

  @override
  Future<Either<Failure, StoreDetails>> execute(void input) async {
    return await _repository.getStoreDetails();
  }
}
