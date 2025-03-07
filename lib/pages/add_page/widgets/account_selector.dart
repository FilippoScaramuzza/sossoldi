import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/constants.dart';
import '../../../constants/functions.dart';
import '../../../constants/style.dart';
import '../../../model/bank_account.dart';
import '../../../providers/accounts_provider.dart';

class AccountSelector extends ConsumerStatefulWidget {
  const AccountSelector({
    required this.provider,
    required this.scrollController,
    this.fromAccount,
    super.key,
  });

  final StateProvider provider;
  final ScrollController scrollController;
  final int? fromAccount;

  @override
  ConsumerState<AccountSelector> createState() => _AccountSelectorState();
}

class _AccountSelectorState extends ConsumerState<AccountSelector> with Functions {
  @override
  Widget build(BuildContext context) {
    final accountsList = ref.watch(accountsProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppBar(
          title: const Text("Account"),
          actions: [
            IconButton(
              onPressed: () => Navigator.of(context).pushNamed('/add-account'),
              icon: const Icon(Icons.add_circle),
              splashRadius: 28,
            ),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: widget.scrollController,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 16, top: 32, bottom: 8),
                  child: Text(
                    "MORE FREQUENT",
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                Container(
                  color: Theme.of(context).colorScheme.surface,
                  height: 74,
                  width: double.infinity,
                  child: accountsList.when(
                    data: (accounts) => ListView.builder(
                      itemCount: (accounts.length > 4) ? 4 : accounts.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        BankAccount account = accounts[i];
                        IconData? icon = accountIconList[account.symbol];
                        Color? color = accountColorListTheme[account.color];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: color,
                                ),
                                padding: const EdgeInsets.all(10.0),
                                child: icon != null
                                    ? Icon(
                                        icon,
                                        size: 24.0,
                                        color: Theme.of(context).colorScheme.background,
                                      )
                                    : const SizedBox(),
                              ),
                              Text(
                                account.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(color: Theme.of(context).colorScheme.primary),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Text('Error: $err'),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 16, top: 32, bottom: 8),
                  child: Text(
                    "ALL ACCOUNTS",
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                accountsList.when(
                  data: (accounts) => ListView.separated(
                    itemCount: accounts.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => const Divider(height: 1, color: grey1),
                    itemBuilder: (context, i) {
                      BankAccount account = accounts[i];
                      IconData? icon = accountIconList[account.symbol];
                      Color? color = accountColorListTheme[account.color];
                      return ListTile(
                        onTap: () => ref.read(widget.provider.notifier).state = account,
                        enabled: account.id != widget.fromAccount,
                        leading: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color,
                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: icon != null
                              ? Icon(
                                  icon,
                                  size: 24.0,
                                  color: Theme.of(context).colorScheme.background,
                                )
                              : const SizedBox(),
                        ),
                        title: Text(account.name),
                        trailing: (ref.watch(widget.provider)?.id == account.id)
                            ? Icon(
                                Icons.done,
                                color: Theme.of(context).colorScheme.secondary,
                              )
                            : null,
                      );
                    },
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Text('Error: $err'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
