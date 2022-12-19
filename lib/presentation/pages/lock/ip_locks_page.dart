import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/ip_lock.dart';
import '../../cubits/auth/session_cubit.dart';

class IpLocksPage extends StatelessWidget{
  const IpLocksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionCubit = BlocProvider.of<SessionCubit>(context);

    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, sessionState) {
        if (sessionState is SessionAuthenticated) {
          return FutureBuilder(
            future: sessionCubit.getAllIpLocks(token: sessionState.session.token),
            builder: (BuildContext context, AsyncSnapshot<List<IpLock>> snapshot) {
              if (snapshot.hasData) {
                return Scaffold(  
                  body: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildIpLocks(context, snapshot.data!, sessionState),
                      ],
                    ),
                  ),
                );
              } else {
                return const Text('');
              }
            }
          );
        } else {
          return const Text('');
        }
        
      }
    );
  }

  Widget _buildIpLock(BuildContext context, String ipAddress, SessionState sessionState) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Text(ipAddress),
            _buildDeleteIpLockButton(context, ipAddress, sessionState),
        ]
      ),
    );
  }

  Widget _buildDeleteIpLockButton(BuildContext context, String ipAddress, SessionState sessionState) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () async {
          if (sessionState is SessionAuthenticated) {
            final sessionCubit = BlocProvider.of<SessionCubit>(context);
            await sessionCubit.deleteIpLock(sessionState.session.token, ipAddress);
          }
        },
        child: const Text('Delete IP lock'),
      ),
    );
  }

  Widget _buildIpLocks(BuildContext context, List<IpLock> ipLocks, SessionState sessionState) {
    List<Widget> ipLockWidgets = [];
    for (var i = 0; i < ipLocks.length; i++) {
      ipLockWidgets.add(
        const Divider(color: Colors.black,),
      );
      ipLockWidgets.add(
        _buildIpLock(context, ipLocks.elementAt(i).ipAddress, sessionState),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: ipLockWidgets,
    );
  }
}