import 'package:domi/core/extensions/string.dart';
import 'package:domi/repositories/wallet_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rewardsProvider =
    StateNotifierProvider.autoDispose<RewardsProvider, RewardsState>((ref) {
  return RewardsProvider(RewardsState(0, 0));
});

class RewardsProvider extends StateNotifier<RewardsState> {
  RewardsProvider(RewardsState state) : super(state);

  getRewardsBalance() async {
    try {
      final response = await WalletRepository.getRewardBalance();
      print(response);
      state = RewardsState(response["total"], response["pending"]);
    } catch (e) {
      Future.error(e);
    }
  }
}

class RewardsState {

  double total = 0;
  double pending = 0;

  RewardsState(this.total, this.pending);
}
