import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/customer/account_provider.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/utils/candidate_bank_util.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';
import 'package:collection/collection.dart';

import 'institution_repository.dart';

class InstitutionViewModel extends BaseViewModel {
  late final InstitutionRepository _institutionRepository;

  final List<AccountProvider> institutions =  [];

  InstitutionViewModel({
    InstitutionRepository? institutionRepository}) {
    this._institutionRepository = institutionRepository ?? GetIt.I<InstitutionRepository>();
  }

  Stream<Resource<List<AccountProvider>>> getInstitutions() {
    return _institutionRepository.getInstitutions().map((event) {
      if(event is Loading || event is Success){
        print('data--->>> ${event.data?.length.toString()}');
        institutions.clear();
        institutions.addAll(event.data ?? []);
      }
      return event;
    });
  }

  List<AccountProvider> sortAndRankWithAccountNumber(List<AccountProvider> accountProviders, String accountNumber) {
    final bankCodes = accountProviders.map((e) => e.bankCode!).toSet();
    final matchingCodes = CandidateBankUtil.getMatchingBanks(bankCodes, accountNumber);
    print(matchingCodes);
    final sortedList = List.of(accountProviders);

    sortedList.sort((a, b) {
      final aMatch = matchingCodes.contains(a.bankCode);
      final bMatch = matchingCodes.contains(b.bankCode);
      if(!aMatch && bMatch) return 1;
      if(aMatch && !bMatch) return -1;
      return 0;
    });

    // if (matchingCodes.contains("950515")) {
    //   print('available');
    //   sortedList.sort((a, b) => (a.bankCode != "950515" && b.bankCode == "950515")
    //       ? 1
    //       : (a.bankCode == "950515" && b.bankCode != "950515")
    //           ? -1
    //           : 0);
    // }

    // sortedList.sort((a, b) {
    //   final aCategoryId = int.parse(a.categoryId ?? "0");
    //   final bCategoryId = int.parse(b.categoryId ?? "0");
    //   if(aCategoryId > bCategoryId) return 1;
    //   if(aCategoryId < bCategoryId) return -1;
    //   // print("$aCategoryId $bCategoryId");
    //   // print(aCategoryId - bCategoryId);
    //   return sortedList.indexOf(a) - sortedList.indexOf(b);
    // });
    return sortedList;
  }

  @override
  void dispose() {
    super.dispose();
  }

}