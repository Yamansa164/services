import 'package:advanced_flutter_arabic/domain/usecase/base_usecase.dart';

import 'package:dartz/dartz.dart';

import '../../data/network/failure.dart';
import '../model/models.dart';
import '../repository/repository.dart';

class ForgetPasswordUseCase implements BaseUseCase<String, String>  {
  Repository _repository;
  ForgetPasswordUseCase(this._repository);
  
  @override
  Future<Either<Failure, String>> execute(String input)async {
    return await _repository.forgotPassword(input);
  }

  
}
