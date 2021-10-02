import 'package:domi/models/wallet/user_transaction.dart';
import 'package:domi/re_use/utils/domi_format.dart';
import 'package:domi/repositories/wallet_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalletProvider extends StateNotifier<WalletState> {
  final repository = WalletRepository();

  WalletProvider(WalletState state) : super(state);

  refreshWallet() async {
    state.page = 1;
    state.moreResults = true;
    state.loading = false;
    state.results = [];
    await getWalletBalance();
    await getTransactions();
  }

  getTransactions() async {
    if (state.loading) {
      return;
    }
    if (!state.moreResults) {
      return;
    }

    state.loading = true;
    state = state;
    try {
      final newResults = await repository.getUserTransaction(page: state.page);
      state.moreResults = newResults.length >= state.pageSize;
      state.results.addAll(newResults);
      state.page++;
      state.loading = false;
    } catch (e) {
      state.loading = false;
      return Future.error(e);
    }
    state = state;
  }

  getWalletBalance() async {
    try {
      final response = await repository.getBalance();
      state.balance = response["total"];
      state.drawBack = response["draw_back"];
      state = state;
    } catch (e) {
      return Future.error(e);
    }
  }

  refreshState() {
    state = state;
  }

  drawback(double value){
    state.balance = state.balance - value;
    state.drawBack=state.drawBack +value;
    refreshState();
  }
}

class WalletState {
  double balance = 0;
  double drawBack = 0;
  List<UserTransaction> results = [];
  bool loading = false;
  int page = 1;
  bool moreResults = true;
  int pageSize = 15;

  String get getBalance => DomiFormat.formatCurrencyCustom(balance);
  String get getDrawback => DomiFormat.formatCurrencyCustom(drawBack);
}
